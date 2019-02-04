//
//  EnvironmentsViewController.m
//  sda-mobile-app
//
//  Created by Anthony D'Ambrosio on 2/12/15.
//  Copyright (c) 2015 Serena. All rights reserved.
//

#import "EnvironmentsViewController.h"
#import "NetworkManager.h"
#import "EnvironmentsCellView.h"
#import "EnvironmentsModel.h"
#import "SnapShotService.h"
#import "ApplicationProcessService.h"

#import "ApplicationsViewController.h"
#import "ProcessesViewController.h"
/**
 * View Controller implementation for Environments screen.
 *
 * @author Evan Hughes
 */
@interface EnvironmentsViewController ()

/**
 * An array containing environments and info to be displayed
 * in the view's tableview.
 */
@property (strong, nonatomic) NSArray *envs;

/**
 * Indicates which Environment is selected by it's envID, passed
 * to next screen so it knows which Environment to
 * display data under.
 */
@property (strong, nonatomic) NSString *selectedEnvironment;

/**
 * Indicates which Environment is selected by it's name, passed
 * to next screen so it knows which Environment to
 * display data under.
 */
@property (strong, nonatomic) NSString *selectedEnvironmentName;

/**
 * Segue name for segue to Applications screen.
 */
@property (strong, nonatomic) NSString *segueToApp;

/**
 * Segue name for segue to Processes screen.
 */
@property (strong, nonatomic) NSString *segueToProc;

/**
 * UIView for displaying the Application under which
 * we are displaying Environments. (Only used when
 * navigating from Applications)
 */
@property (strong, nonatomic) UIView *topBar;

@property (strong, nonatomic) UIRefreshControl *refreshControl;

@end

@implementation EnvironmentsViewController

- (void)reloadData {
    NSString *appId = self.appId == nil ? @"" : self.appId;
    self.envs = [[NetworkManager getDataFor:environments
                                withOptions:@{@"appId": appId}]
                 valueForKey:STRINGIFY(environments)];
    [self.tableView reloadData];

    [self.refreshControl endRefreshing];
}

/**
 * Refer to Apple Documentation for more in-depth explanation.
 * Called after the view has loaded.
 * Does general setup for screen.
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    if(self.segueFromOverflow){
        ALog(@"segue from overflow TRUE");
    } else {
        ALog(@"segue from overflow FALSE");
    }
    if([self cameFromApplications]  && !self.hideNavBar){
        [self displayNavBar];
    }
    self.segueToApp = @"EnvToApp";
    self.segueToProc = @"EnvToProc";

    //set the table size and properites
    NSString *appId = self.appId == nil ? @"" : self.appId;
    self.envs = [[NetworkManager getDataFor:environments
                               withOptions:@{@"appId": appId}]
                 valueForKey:STRINGIFY(environments)];
    self.tableView.backgroundColor = [UIColor colorWithRed:0.957 green:0.957 blue:0.957 alpha:1];
    self.tableView.backgroundView.backgroundColor = [UIColor colorWithRed:0.957 green:0.957 blue:0.957 alpha:1];
    
    //removes extra separator lines in the table
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    // Initialize the refresh control
    self.refreshControl = [UIRefreshControl new];
    [self.tableView addSubview:self.refreshControl];
    self.refreshControl.backgroundColor = refreshBackground;
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self
                            action:@selector(reloadData)
                  forControlEvents:UIControlEventValueChanged];

    // Offset the Refresh view to match the table view
    // TODO: 22 is a magic number, and im not sure what i should use for screenWidth - Anthony
    CGFloat screenWidth = self.view.bounds.size.width;
    self.refreshControl.bounds = CGRectMake(22 - (screenWidth / 2),
                                            self.refreshControl.bounds.origin.y,
                                            self.refreshControl.bounds.size.width,
                                            self.refreshControl.bounds.size.height);
    [self.refreshControl beginRefreshing];
    [self.refreshControl endRefreshing];
}

/**
 * Displays the bar at the top indicating which Application was selected on
 * the previous screen. This method will not be called if we did not
 * navigate to the Environments screen from the Applications screen.
 */
- (void) displayNavBar {
    ALog(@"displayNavBar");
    ALog(@"selected app: %@", self.application);
    CGFloat screenWidth = self.view.frame.size.width;
    self.topBar = [[UIView alloc] init];
    self.topBar.backgroundColor = [UIColor colorWithRed:0.522 green:0.816 blue:0.925 alpha:1];
    CGRect frame = self.tableView.frame;
    frame.size.height = 44;
    frame.origin.y = 64;
    self.topBar.frame = frame;
    UILabel *application = [[UILabel alloc] init];
    UILabel *applicationName = [[UILabel alloc] init];
    
    application.text = @"Application";
    application.textColor = [UIColor colorWithRed:0.035 green:0.325 blue:0.478 alpha:1]; /*#09537a*/
    application.font = [UIFont boldSystemFontOfSize:12];
    
    applicationName.text = self.application;
    applicationName.textColor = [UIColor whiteColor];
    applicationName.font = [UIFont systemFontOfSize:12];
    
    [self.topBar addSubview:application];
    [self.topBar addSubview:applicationName];
    
    CGRect labelFrame = CGRectMake(5, 2, screenWidth/2, 20);
    application.frame = labelFrame;
    labelFrame.origin.y += 18;
    applicationName.frame = labelFrame;
    
    CGRect tableFrame = self.tableView.frame;
    tableFrame.origin.y = self.tableView.frame.origin.y + frame.size.height;
    [self.tableView setTranslatesAutoresizingMaskIntoConstraints:YES];
    self.tableView.frame = tableFrame;
    [self.view addSubview: self.topBar];
    [self.view bringSubviewToFront:self.overflowTable];

}

/**
 * Returns a boolean indicating whether or not we came from the Applications screen,
 * by checking the navigationController's viewController stack.
 */
- (BOOL) cameFromApplications
{
    NSArray *vcstack = self.navigationController.viewControllers;
    if([[vcstack objectAtIndex:([vcstack count] - 2)] isKindOfClass:[ApplicationsViewController class]]){
        return YES;
    }
    return NO;
}

/**
 * All table view methods make a check to super to see if the tableview is
 * actually the overflow menu and not the desired tableView.
 * If it is the overflow menu, we call the overflow menu's tableView method instead.
 */

/**
 * Refer to Apple Documentation for more in-depth explanation.
 * Sets number of rows in provided tableview.
 */
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    if(tableView == super.overflowTable){
        return [super tableView:tableView numberOfRowsInSection:section];
    }
    NSUInteger count = [self.envs count];
    if(count > 0)
        return count;
    CGRect noDataFrame = CGRectMake(0, 0, 300, 100);
    if(self.cameFromApplications){
        noDataFrame.origin.y += 44;
    }
    UIView *noData = [[UIView alloc] initWithFrame:noDataFrame];
    UILabel *noDataLabel = [[UILabel alloc] initWithFrame:noDataFrame];
    [noData addSubview: noDataLabel];
    noDataLabel.text = @"   No records found.";
    noDataLabel.textColor = [UIColor blackColor];
    noDataLabel.numberOfLines = 0;
    self.tableView.backgroundView = noData;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    return count;}

/**
 * Refer to Apple Documentation for more in-depth explanation.
 * Populates tableView's cell at indexPath with appropriate information.
 * 
 * If we came from the Applications screen, we don't display the
 * createdOn or createdBy labels, and center the > arrow and Environment
 * name label appropriately.
 */
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView == super.overflowTable){
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
        NSString *cellId = @"EnvironmentTableCell";
        EnvironmentsCellView *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellId owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }

    // INITIALIZING LABELS
    EnvironmentsModel *model = ((EnvironmentsModel *)self.envs[indexPath.row]);
    if([self cameFromApplications] && !self.hideNavBar){
        cell.nameLabel.text = model.name;
        cell.createdOnLabel.text = @"";
        cell.createdByLabel.text = @"";
        [cell.nameLabel setTranslatesAutoresizingMaskIntoConstraints:YES];
        [cell.nameLabel setCenter:CGPointMake(cell.nameLabel.center.x, 22.0)];
        [cell.arrow setTranslatesAutoresizingMaskIntoConstraints:YES];
        [cell.arrow setCenter:CGPointMake(cell.arrow.center.x, 22.0)];
    } else {
        cell.nameLabel.text = model.name;
        cell.createdOnLabel.text = [NSString stringWithFormat:@"Created On: %@",
                                    model.createdOn];
        cell.createdByLabel.text = [@"Created By: " stringByAppendingFormat:@"%@",
                                    model.createdBy];
    }

    cell.contentView.backgroundColor = [UIColor colorWithRed:0.957 green:0.957 blue:0.957 alpha:1];
    [tableView setSeparatorInset:UIEdgeInsetsZero];
    [tableView setLayoutMargins:UIEdgeInsetsZero];
    [cell setSeparatorInset:UIEdgeInsetsZero];
    [cell setLayoutMargins:UIEdgeInsetsZero];
    return cell;
}

/**
 * Refer to Apple Documentation for more in-depth explanation.
 * Sets action for each cell in provided tableView at provided indexPath.
 *
 * Here, it segues to the next screen (Applications or Processes),
 * passing along data appropriately in prepareForSegue.
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView == super.overflowTable){
        [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    } else {
        EnvironmentsModel *model = ((EnvironmentsModel *)self.envs[indexPath.row]);
        self.selectedEnvironment = model.appId;
        self.selectedEnvironmentName = model.name;
        [self performSegueWithIdentifier:(self.appId == nil ? self.segueToApp : self.segueToProc)
                                  sender:self];
    }
}

/**
 * Refer to Apple Documentation for more in-depth explanation.
 * Dictates the height of each cell in provided tableView at provided indexPath.
 *
 * Default height (44px) is used for if we came from Applications.
 * Otherwise, height of custom EnvironmentsCell (65px) is used.
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == super.overflowTable){
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }
    if([self cameFromApplications] && !self.hideNavBar){
        return 44;
    }
    return 65;
}

/**
 * Refer to Apple Documentation for more in-depth explanation.
 * Method is automatically called before segues are executed.
 * Here, we set up the destinationViewController and initialize
 * values as needed.
 */
- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender {
    if ([[segue identifier] isEqualToString:self.segueToApp]) {
        ApplicationsViewController *avc = [segue destinationViewController];
        avc.envId = self.selectedEnvironment;
        avc.environment = self.selectedEnvironmentName;
        avc.hideNavBar = FALSE;
    } else if ([[segue identifier] isEqualToString:self.segueToProc]) {
        ProcessesViewController *pvc = [segue destinationViewController];
        pvc.appId = self.appId;
        pvc.envId = self.selectedEnvironment;
        pvc.application = self.application;
        pvc.environment = self.selectedEnvironmentName;
    }
}

@end
