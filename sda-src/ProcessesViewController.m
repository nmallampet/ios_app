//
//  ProcessesViewController.m
//  sda-mobile-app
//
//  Created by Anthony D'Ambrosio on 2/13/15.
//  Copyright (c) 2015 Serena. All rights reserved.
//
/**
 * View Controller implementation for Processes screen.
 *
 * @author Evan Hughes
 */
#import "ProcessesViewController.h"
#import "NetworkManager.h"
#import "ProcessesModel.h"
#import "ProcessesCellView.h"
#import "EnvironmentsViewController.h"
#import "ApplicationsViewController.h"

@interface ProcessesViewController ()

/**
 * Array of Processes and relevant information.
 */
@property (strong, nonatomic) NSArray *processes;

/**
 * UIView to indicate which Application and Environment we are under.
 */
@property (strong, nonatomic) UIView *topBar;

@property (strong, nonatomic) UIRefreshControl *refreshControl;

@end

@implementation ProcessesViewController

- (void)reloadData {
    self.processes = [[NetworkManager getDataFor:processes
                                     withOptions:@{@"appId": self.appId}]
                      valueForKey:STRINGIFY(processes)];
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
    [self checkViewControllerStack];

    self.processes = [[NetworkManager getDataFor:processes
                                    withOptions:@{@"appId": self.appId}]
                      valueForKey:STRINGIFY(processes)];

    self.tableView.backgroundColor = [UIColor colorWithRed:0.957 green:0.957 blue:0.957 alpha:1];
    self.tableView.backgroundView.backgroundColor = [UIColor colorWithRed:0.957 green:0.957 blue:0.957 alpha:1];

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
 * Displays bar at the top indicating which Application and Environment
 * we are under.
 *
 * @param showAppFirst - Boolean indicating if we came from an Application or Environment first.
 */
- (void) displayNavBar:(BOOL) showAppFirst {
    //Constant values - halfScreenWidth for where to show the / symbol
    //                  topBarHeight set to 44 (standard/default table cell height)
    CGFloat halfScreenWidth = self.view.frame.size.width / 2;
    CGFloat topBarHeight = 44;
    self.topBar = [[UIView alloc] init];
    self.topBar.backgroundColor = appsEnvsProcsBar;
    
    //setting up frame for top bar
    CGRect frame = CGRectMake(0, 64, self.view.frame.size.width, topBarHeight);
    frame.size.height = topBarHeight;
    frame.origin.y = 64;
    self.topBar.frame = frame;
    
    //setting up displaying of application
    UILabel *application = [[UILabel alloc] init];
    UILabel *applicationName = [[UILabel alloc] init];
    application.text = @"Application";
    application.textColor = appsEnvsProcsBarTextColor;
    application.font = [UIFont boldSystemFontOfSize:12];
    applicationName.text = self.application;
    applicationName.textColor = [UIColor whiteColor];
    applicationName.font = [UIFont systemFontOfSize:12];
    
    //setting up displaying of environment
    UILabel *environment = [[UILabel alloc] init];
    UILabel *environmentName = [[UILabel alloc] init];
    environment.text = @"Environment";
    environment.textColor = appsEnvsProcsBarTextColor;
    environment.font = [UIFont boldSystemFontOfSize:12];
    environmentName.text = self.environment;
    environmentName.textColor = [UIColor whiteColor];
    environmentName.font = [UIFont systemFontOfSize:12];
    
    //invisible button over first half of bar to go back one screen
    UIButton *toPrev = [[UIButton alloc] init];
    [toPrev addTarget:self action:@selector(backToPrev:) forControlEvents:UIControlEventTouchUpInside];
    [toPrev.layer setBackgroundColor:[UIColor clearColor].CGColor];

    //diagonal line image
    UIImage *diagonal = [[UIImage imageNamed:@"ic_action_diagonal_line"] resizableImageWithCapInsets:UIEdgeInsetsZero];
    UIImageView *divider = [[UIImageView alloc] initWithImage:diagonal];
    
    //adding labels, button, image to topBar
    [self.topBar addSubview:divider];
    [self.topBar addSubview:environment];
    [self.topBar addSubview:environmentName];
    [self.topBar addSubview:application];
    [self.topBar addSubview:applicationName];
    [self.topBar addSubview:toPrev];
    
    //setting up positioning of labels within top frame
    CGRect leftLabelFrame = CGRectMake(5, 2, halfScreenWidth - 12, 20);
    CGRect rightLabelFrame = CGRectMake((halfScreenWidth + 8), 2, halfScreenWidth, 20);
    CGRect toPrevFrame = CGRectMake(5, 2, halfScreenWidth - 12, 40);
    toPrev.frame = toPrevFrame;
    if(showAppFirst){
        application.frame = leftLabelFrame;
        leftLabelFrame.origin.y += 18;
        applicationName.frame = leftLabelFrame;
        
        environment.frame = rightLabelFrame;
        rightLabelFrame.origin.y += 18;
        environmentName.frame = rightLabelFrame;
    } else {
        application.frame = rightLabelFrame;
        rightLabelFrame.origin.y += 18;
        applicationName.frame = rightLabelFrame;
        
        environment.frame = leftLabelFrame;
        leftLabelFrame.origin.y += 18;
        environmentName.frame = leftLabelFrame;
    }
    divider.frame = CGRectMake(halfScreenWidth - 32, 3, 32, topBarHeight - 5);
    
    //changing table's frame due to adding top bar in above
    CGRect tableFrame = self.tableView.frame;
    tableFrame.origin.y = self.tableView.frame.origin.y + topBarHeight;
    [self.tableView setTranslatesAutoresizingMaskIntoConstraints:YES];
    self.tableView.frame = tableFrame;
    [self.view addSubview: self.topBar];
    [self.view bringSubviewToFront:self.overflowTable];
}

/**
 * Checks the navigationController's viewController stack to see if the last
 * screen we were on was Environments or Applications, in order to see which 
 * should be displayed first on the top bar.
 */
- (void) checkViewControllerStack
{
    NSArray *vcstack = self.navigationController.viewControllers;
    if([[vcstack objectAtIndex:([vcstack count] - 2)] isKindOfClass:[EnvironmentsViewController class]]){
        [self displayNavBar:YES];
    } else if ([[vcstack objectAtIndex:([vcstack count] - 2)] isKindOfClass:[ApplicationsViewController class]]){
        [self displayNavBar:NO];
    }
}

/**
 * Action to be called by the button set in the top bar. Takes you back one screen,
 * similar to the back button on the navigation bar.
 */
- (void) backToPrev:(id) sender{
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 * Based off of parseStatus in DataGetter.java of the Android Serena Application.
 * Parses the status of a deployment in order to indicate what status should be displayed.
 *
 * @param indexPath - used to access the index in the Processes array, based on the indexPath
 *                    currently being tracked in cellForRowAtIndexPath
 */
- (NSString*) parseStatus:(NSIndexPath *)indexPath{
    
    ProcessesModel *pm = ((ProcessesModel *)self.processes[indexPath.row]);
    
    if(pm.failed != nil){
        return @"Failed";
    }
    
    if(pm.rootTrace != nil){
        if([pm.state isEqualToString:@"CLOSED"] && [pm.result isEqualToString:@"SUCCEEDED"]){
            if(pm.metadata != nil && pm.notNeeded!= nil)
                return @"Not Needed";
            else
                return @"Success";
        }
        
        if([pm.state isEqualToString:@"CLOSED"] && [pm.result isEqualToString:@"CANCELED"])
            return @"Canceled";
        
        if([pm.state isEqualToString:@"EXECUTING"]){
            if(pm.paused != nil && [pm.paused isEqualToString:@"true"])
                return @"Paused";
            else
                return @"Running";
        }
        
        if(([pm.state isEqualToString:@"CLOSED"] && [pm.result isEqualToString:@"FAULTED"]) || [pm.state isEqualToString:@"FAULTING"])
            return @"Failed";
    }
    
    if(pm.approval != nil){
        if(pm.approvalFailed != nil && [pm.approvalFailed isEqualToString:@"true"])
            return @"Approval Failed";
        
        if(pm.approvalFinished != nil && [pm.approvalFinished isEqualToString:@"true"])
            return @"Approved";
        
        if(pm.approvalCancelled != nil && [pm.approvalCancelled isEqualToString:@"true"])
            return @"Approval Cancelled";
        
        return @"Approval In Progress";
    }
    
    if(pm.error != nil)
        return @"Could Not Start";

    if(pm.entry != nil)
        return @"Scheduled";
    
    return nil;
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
    NSInteger count = [self.processes count];
    if (count > 0) {
        return count;
    }
    CGRect noDataFrame = CGRectMake(0, 44, 300, 100);
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
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView == super.overflowTable){
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
    static NSString *cellIdentifier = @"ProcessesTableCell";
    ProcessesCellView *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    NSString *dateString =[NSString stringWithFormat:@"%@", ((ProcessesModel *)self.processes[indexPath.row]).createdOn];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"LLL d, yyyy hh:mm:ss a"];
    long long int num = [dateString longLongValue];
    NSDate *d = [NSDate dateWithTimeIntervalSince1970:num/1000.0];
    NSString *createdOnDate = [NSString stringWithFormat:@"%@",[df stringFromDate:d]];

    ProcessesModel *model = ((ProcessesModel *)self.processes[indexPath.row]);
    cell.nameLabel.text = model.name;
    cell.createdByLabel.text = [NSString stringWithFormat:@"Created On: %@", createdOnDate];
    cell.createdOnLabel.text = [@"Created By: " stringByAppendingFormat:@"%@", model.createdBy];
    
    cell.statusLabel.layer.borderWidth = 1.5;
    NSString *statusLabelCheck = [self parseStatus:indexPath];
    cell.statusLabel.text = statusLabelCheck;
    if([statusLabelCheck isEqualToString:@"Failed"] || [statusLabelCheck isEqualToString:@"Could Not Start"]
       || [statusLabelCheck isEqualToString:@"Approval Failed"]){
        cell.statusLabel.backgroundColor = resOfflineBackground;
        cell.statusLabel.layer.borderColor = resOfflineForeground.CGColor;
        cell.statusLabel.textColor = resOfflineForeground;
    } else if ([statusLabelCheck isEqualToString:@"Success"] || [statusLabelCheck isEqualToString:@"Approved"]){
        cell.statusLabel.backgroundColor = resOnlineBackground;
        cell.statusLabel.layer.borderColor = resOnlineForeground.CGColor;
        cell.statusLabel.textColor = resOnlineForeground;
    } else if ([statusLabelCheck isEqualToString:@"Paused"] || [statusLabelCheck isEqualToString:@"Not Needed"]
               || [statusLabelCheck isEqualToString:@"Scheduled"] || [statusLabelCheck isEqualToString:@"Approval Cancelled"]){
        cell.statusLabel.backgroundColor = resScheduledBackground;
        cell.statusLabel.layer.borderColor = resScheduledForeground.CGColor;
        cell.statusLabel.textColor = resScheduledForeground;
    } else if ([statusLabelCheck isEqualToString:@"Running"] || [statusLabelCheck isEqualToString:@"Approval In Progress"]){
        cell.statusLabel.backgroundColor = resRunningBackground;
        cell.statusLabel.layer.borderColor = resRunningForeground.CGColor;
        cell.statusLabel.textColor = resRunningForeground;
    } else {
        cell.statusLabel.backgroundColor = [UIColor grayColor];
        cell.statusLabel.layer.borderColor = [UIColor blackColor].CGColor;
        cell.statusLabel.textColor = [UIColor blackColor];
    }
    //set label width based on status text
    [cell.statusLabel setTranslatesAutoresizingMaskIntoConstraints:YES];
    CGFloat statusLabelWidth = [cell.statusLabel.text boundingRectWithSize:cell.statusLabel.frame.size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName:cell.statusLabel.font } context:nil].size.width;
    CGRect statusLabelFrame = cell.statusLabel.frame;
    statusLabelFrame.size.width = statusLabelWidth * 1.25;
    cell.statusLabel.frame = statusLabelFrame;
    
    cell.contentView.backgroundColor = [UIColor colorWithRed:0.957 green:0.957 blue:0.957 alpha:1];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
 * Here, it actually doesn't do anything but make a check to see if we
 * are calling this on the overflow menu or the view's tableview.
 *
 * If it weren't implemented, it would perform the action associated with 
 * that index of the overflow menu (i.e. tapping on the first Process would
 * take you to Action Items, or whatever the first item on the overflow menu
 * is on this screen).
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView == super.overflowTable){
        [super tableView:tableView didSelectRowAtIndexPath:indexPath];
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
    return 90;
}

@end
