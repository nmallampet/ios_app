//
//  ApplicationsViewController.m
//  sda-mobile-app
//
//  Created by Anthony D'Ambrosio on 2/11/15.
//  Copyright (c) 2015 Serena. All rights reserved.
//
/**
 * View Controller implementation for Applications screen.
 *
 * @author Evan Hughes
 */
#import "ApplicationsViewController.h"
#import "NetworkManager.h"
#import "ApplicationsCellView.h"
#import "ApplicationsModel.h"

#import "EnvironmentsViewController.h"
#import "ProcessesViewController.h"


@interface ApplicationsViewController ()

/**
 * apps is an array containing applications and info to be displayed
 * in the view's tableview.
 */
@property (strong, nonatomic) NSArray *apps;

/**
 * Indicates which app is selected by it's appID, passed
 * to next screen so it knows which Application to
 * display data under.
 */
@property (strong, nonatomic) NSString *selectedApplication;

/**
 * Indicates which app is selected by it's name, passed
 * to next screen so it knows which Application to
 * display data under.
 */
@property (strong, nonatomic) NSString *selectedApplicationName;

/**
 * Segue name for segue to Environments screen.
 */
@property (strong, nonatomic) NSString *segueToEnv;

/**
 * Segue name for segue to Processes screen.
 */
@property (strong, nonatomic) NSString *segueToProc;

/**
 * UIView for displaying the Environment under which
 * we are displaying Applications. (Only used when
 * navigating from Environments)
 */
@property (strong, nonatomic) UIView *topBar;

@property (strong, nonatomic) UIRefreshControl *refreshControl;

@end

@implementation ApplicationsViewController


- (void)reloadData {
    NSString *envId = self.envId == nil ? @"" : self.envId;
    self.apps = [[NetworkManager getDataFor:applications
                                withOptions:@{@"envId" : envId}]
                 valueForKey:STRINGIFY(applications)];
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
    if([self cameFromEnvironments] && !self.hideNavBar){
        [self displayNavBar];
    }
    self.segueToEnv = @"AppToEnv";
    self.segueToProc = @"AppToProc";

    NSString *envId = self.envId == nil ? @"" : self.envId;
    self.apps = [[NetworkManager getDataFor:applications
                                withOptions:@{@"envId" : envId}]
                 valueForKey:STRINGIFY(applications)];
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
    // TODO: 22 is a magic number, and im not sure what i should use for screenWidth
    CGFloat screenWidth = self.view.bounds.size.width;
    self.refreshControl.bounds = CGRectMake(22 - (screenWidth / 2),
                                            self.refreshControl.bounds.origin.y,
                                            self.refreshControl.bounds.size.width,
                                            self.refreshControl.bounds.size.height);
    [self.refreshControl beginRefreshing];
    [self.refreshControl endRefreshing];
}

/**
 * Displays the bar at the top indicating which Environment was selected on 
 * the previous screen. This method will not be called if we did not
 * navigate to the Applications screen from the Environments screen.
 */
- (void) displayNavBar {
    CGFloat screenWidth = self.view.frame.size.width;
    self.topBar = [[UIView alloc] init];
    self.topBar.backgroundColor = [UIColor colorWithRed:0.522 green:0.816 blue:0.925 alpha:1];
    CGRect frame = self.tableView.frame;
    frame.size.height = 44;
    frame.origin.y = 64;
    self.topBar.frame = frame;
    UILabel *environment = [[UILabel alloc] init];
    UILabel *environmentName = [[UILabel alloc] init];

    environment.text = @"Environment";
    environment.textColor = [UIColor colorWithRed:0.035 green:0.325 blue:0.478 alpha:1]; /*#09537a*/
    environment.font = [UIFont boldSystemFontOfSize:12];
    
    environmentName.text = self.environment;
    environmentName.textColor = [UIColor whiteColor];
    environmentName.font = [UIFont systemFontOfSize:12];

    [self.topBar addSubview:environment];
    [self.topBar addSubview:environmentName];
    
    CGRect labelFrame = CGRectMake(5, 2, screenWidth/2, 20);
    environment.frame = labelFrame;
    labelFrame.origin.y += 18;
    environmentName.frame = labelFrame;
    
    CGRect tableFrame = self.tableView.frame;
    tableFrame.origin.y = self.tableView.frame.origin.y + frame.size.height;
    [self.tableView setTranslatesAutoresizingMaskIntoConstraints:YES];
    self.tableView.frame = tableFrame;
    [self.view addSubview: self.topBar];
    [self.view bringSubviewToFront:self.overflowTable];


}

/**
 * Returns a boolean indicating whether or not we came from the Environments screen,
 * by checking the navigationController's viewController stack.
 */
- (BOOL) cameFromEnvironments
{
    NSArray *vcstack = self.navigationController.viewControllers;
    if([[vcstack objectAtIndex:([vcstack count] - 2)] isKindOfClass:[EnvironmentsViewController class]]){
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
    NSUInteger count = [self.apps count];
    if(count > 0)
        return count;
    CGRect noDataFrame = CGRectMake(0, 0, 300, 100);
    if(self.cameFromEnvironments){
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
    return count;
}

/**
 * Refer to Apple Documentation for more in-depth explanation.
 * Populates tableView's cell at indexPath with appropriate information.
 */
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView == super.overflowTable){
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
    NSString *cellId = @"ApplicationTableCell";
    ApplicationsCellView *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellId owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }

    // INITIALIZING LABELS
    ApplicationsModel *model = ((ApplicationsModel *)self.apps[indexPath.row]);
    cell.nameLabel.text = model.name;
    cell.createdOnLabel.text = [NSString stringWithFormat:@"Created On: %@",
                                model.createdOn];
    cell.createdByLabel.text = [@"Created By: " stringByAppendingFormat:@"%@",
                                model.createdBy];
    
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
 * Here, it segues to the next screen (Environments or Processes),
 * passing along data appropriately in prepareForSegue.
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView == super.overflowTable){
        [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    } else {
        ApplicationsModel *model = ((ApplicationsModel *)self.apps[indexPath.row]);
        self.selectedApplication = model.appId;
        self.selectedApplicationName = model.name;
        [self performSegueWithIdentifier:(self.envId == nil ? self.segueToEnv : self.segueToProc)
                                  sender:self];
    }
}

/**
 * Refer to Apple Documentation for more in-depth explanation.
 * Dictates the height of each cell in provided tableView at provided indexPath.
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == super.overflowTable){
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
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
    if ([[segue identifier] isEqualToString:self.segueToEnv]) {
        EnvironmentsViewController *evc = [segue destinationViewController];
        evc.appId = self.selectedApplication;
        evc.application = self.selectedApplicationName;
        evc.hideNavBar = FALSE;
    } else if ([[segue identifier] isEqualToString:self.segueToProc]) {
        ProcessesViewController *pvc = [segue destinationViewController];
        pvc.appId = self.selectedApplication;
        pvc.envId = self.envId;
        pvc.application = self.environment;
        pvc.environment = self.selectedApplicationName;
    }
}

@end
