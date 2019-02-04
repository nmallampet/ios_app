//
//  BaseViewController.m
//  sda-mobile-app
//
//  Created by Evan Hughes on 4/17/15.
//  Copyright (c) 2015 Serena. All rights reserved.
//

#import "BaseViewController.h"
#import "User.h"
#import "NetworkManager.h"
#import "ApplicationsViewController.h"
#import "EnvironmentsViewController.h"
#import "ProcessesViewController.h"
#import "MainMenuViewController.h"

@interface BaseViewController ()
//@property bool menuClicked;
@end


/**
 * BaseViewController is a parent class of all view controllers used,
 * in order to implement the overflow menu on each screen.
 * @author Evan Hughes
 */

@implementation BaseViewController

/**
 * Add the back button icon and functionality to navigation bar. 
 * This uses the navigationItem's leftBarButtonItem as opposed to
 * using the backBarButtonItem, to implement custom functionality
 * of always popping to the root view controller, and only popping
 * a single view controller when appropriate.
 */
- (void) addBackButton {
    UIImage *backButtonImage;
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    if([self.navigationItem.title isEqualToString:@"Deployment Automation"]){
        backButtonImage = [[UIImage imageNamed:@"ic_home"] resizableImageWithCapInsets:UIEdgeInsetsZero];
        [back setTintColor:[UIColor whiteColor]];
    } else {
        backButtonImage = [[UIImage imageNamed:@"ic_back_home"] resizableImageWithCapInsets:UIEdgeInsetsZero];
    }
    back.bounds = CGRectMake( 0, 0, backButtonImage.size.width, backButtonImage.size.height );
    [back setImage:backButtonImage forState:UIControlStateNormal];
    [back addTarget:self action:@selector(backToMain) forControlEvents:UIControlEventTouchUpInside];
    self.backButton = [[UIBarButtonItem alloc] initWithCustomView:back];
    self.navigationItem.leftBarButtonItem = self.backButton;
    [[UIBarButtonItem appearance] setTintColor:[UIColor whiteColor]];
}

/**
 * The action called by the back button implemented in the addBackButton
 * function.
 */
- (void) backToMain {
    NSArray *vcstack = self.navigationController.viewControllers;
    // if segue'd from overflow pop to root
    // else if on Apps/Envs/Procs AND Came from Apps/Envs/Processes, pop vc.
    // else if on main menu do nothing
    // else pop to root
    
    if(([self.navigationItem.title isEqualToString:@"Applications"] ||
        [self.navigationItem.title isEqualToString:@"Environments"] ||
        [self.navigationItem.title isEqualToString:@"Processes"]) &&
       ([[vcstack objectAtIndex:([vcstack count] - 2)] isKindOfClass:[EnvironmentsViewController class]] ||
        [[vcstack objectAtIndex:([vcstack count] - 2)] isKindOfClass:[ApplicationsViewController class]] ||
        [[vcstack objectAtIndex:([vcstack count] - 2)] isKindOfClass:[ProcessesViewController class]])){
        [self.navigationController popViewControllerAnimated:YES];
    } else if([self.navigationItem.title isEqualToString:@"Deployment Automation"]){
    } else {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

/**
 * Add the overflow menu icon and button functionality to the navigation bar.
 */
- (void) addOverflowMenu {
    UIImage *overflowMenuButtonImage = [[UIImage imageNamed:@"ic_tab_menu"] resizableImageWithCapInsets:UIEdgeInsetsZero];
    UIButton *overflow = [UIButton buttonWithType:UIButtonTypeCustom];
    overflow.bounds = CGRectMake( 0, 0, overflowMenuButtonImage.size.width, overflowMenuButtonImage.size.height );
    [overflow setImage:overflowMenuButtonImage forState:UIControlStateNormal];
    [overflow addTarget:self
                 action:@selector(overFlowMenuClick:)
       forControlEvents:UIControlEventTouchUpInside];
    self.overflowButton = [[UIBarButtonItem alloc] initWithCustomView:overflow];
    self.navigationItem.rightBarButtonItem = self.overflowButton;
    [[UIBarButtonItem appearance] setTintColor:[UIColor whiteColor]];
}

/**
 * Sets up overflow menu to be filled with data (links to other screens).
 */
- (void) setupOverflowMenu {
    self.overflowTable = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame] style:UITableViewStylePlain];
    self.overflowTable.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    self.overflowTable.delegate = self;
    self.overflowTable.dataSource = self;
    self.overflowTable.hidden = YES;
    [self setOverflowMenuOrientation];
    self.overflowTable.backgroundView = nil;
    self.overflowTable.backgroundView = [[UIView alloc] init];
    self.overflowTable.backgroundColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1];
    [self.view addSubview:self.overflowTable];
    [self.overflowTable reloadData];
}

/**
 * Fills array to be used for populating overflow menu
 * with appropriate items.
 */
- (NSMutableArray *) setShownOverflowItems{
    NSString *currentvc = self.navigationItem.title;
    if(![currentvc isEqualToString:@"Deployment Automation"]){
        self.shownOverflowItems = [NSMutableArray arrayWithObjects:@"Action Items", @"Status", @"Scheduled",
                                   @"Request New Process", @"Applications",
                                   @"Environments", @"Resources",
                                   @"About Us", @"Settings", @"Logout", nil];
        [self.shownOverflowItems removeObject:currentvc];
    } else {
        self.shownOverflowItems = [NSMutableArray arrayWithObjects:@"About Us", @"Settings", @"Logout", nil];
    }
    return self.shownOverflowItems;
}


/**
 * Hides or displays overflowMenu based on user interaction.
 * This method is attached to the overflow icon/button, and is
 * called when it is pressed.
 */
- (void)overFlowMenuClick:(UIButton *)sender {
    if(self.menuClicked) {
        self.overflowTable.hidden = NO;
        self.menuClicked = false;
    } else {
        self.overflowTable.hidden = YES;
        self.menuClicked = true;
    }
}

/**
 * Changes the frame of the overflow menu table based on orientation.
 */
- (void) setOverflowMenuOrientation {
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if ((orientation == UIInterfaceOrientationLandscapeLeft) || (orientation == UIInterfaceOrientationLandscapeRight)) {
        //Landscape mode
        self.overflowTable.frame = CGRectMake(self.view.frame.size.width - 200, 32, 200, self.shownOverflowItems.count*44);
    } else if ((orientation == UIInterfaceOrientationPortrait) || (orientation == UIInterfaceOrientationPortraitUpsideDown)) {
        //Portrait mode
        self.overflowTable.frame = CGRectMake(self.view.frame.size.width - 200, 64, 200, self.shownOverflowItems.count*44);
    }
}

/**
 * Refer to Apple Documentation for more in-depth explanation.
 * Sets overflow menu frame when orientation change is detected.
 */
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)orientation duration:(NSTimeInterval)duration {
    [self setOverflowMenuOrientation];
}

/**
 * Custom segue method that calls default segue method performSegueWithIdentifier.
 * 
 * @params screen - NSString indicating what screen the user is trying to segue to.
 */
- (void) segue:(NSString *)screen{
    //main menu is always root view controller on the navigation controller's vc stack
    MainMenuViewController *mmvc = self.navigationController.viewControllers[0];
    //get current vc
    NSString *currentvc = self.navigationItem.title;
    //if we need to log out and we're not already on the main menu
    if([screen isEqualToString:@"Logout"] && ![currentvc isEqualToString:@"Deployment Automation"]){
        mmvc.needLogout = true;
        [self.navigationController popToRootViewControllerAnimated:NO];
    //using overflow from main menu
    } else if([currentvc isEqualToString:@"Deployment Automation"]){
        [self performSegueWithIdentifier:screen sender:self];
    //using overflow from not the main menu
    } else {
        mmvc.needSegue = true;
        mmvc.segueTo = screen;
        [self.navigationController popToRootViewControllerAnimated:NO];
    }
}

/**
 * Refer to Apple Documentation for more in-depth explanation.
 * Sets number of rows in provided tableview, here specifically,
 * the overflow menu's tableview.
 */
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.shownOverflowItems.count;
}



/**
 * Refer to Apple Documentation for more in-depth explanation.
 * Populates tableView's cell at indexPath with appropriate information.
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.backgroundView = [[UIView alloc] init];
    [cell.backgroundView setBackgroundColor:[UIColor clearColor]];
    [[[cell contentView] subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self setShownOverflowItems];
    cell.textLabel.text = [self.shownOverflowItems objectAtIndex:indexPath.row];
    cell.contentView.backgroundColor = [UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1];
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
 * Here, it gets the current view controller (whatever screen the user is on)
 * and passes the title as a string to the segue method (titles used as segue names).
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *vcswitch = [NSString stringWithFormat:@"%@", [self.shownOverflowItems objectAtIndex:indexPath.row]];
    if ([vcswitch isEqualToString:@"Logout"]) {
        [self logout];
    } else if(![vcswitch isEqualToString: self.navigationItem.title]){
        self.overflowTable.hidden = YES;
        [self segue:(vcswitch)];
    }
}

/**
 * Refer to Apple Documentation for more in-depth explanation.
 * Dictates the height of each cell in provided tableView at provided indexPath.
 * Default height is 44px.
 * This is only called here so that it can be called by subclasses using UITableViews,
 * to differentiate the subclass's tableview from the overflow menu tableview.
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

/**
 * Refer to Apple Documentation for more in-depth explanation.
 * Called when view has loaded. We do initial setup here, 
 * calling appropriate methods.
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setShownOverflowItems];
    [self addOverflowMenu];
    [self setupOverflowMenu];
    [self addBackButton];
    self.overflowTable.hidden = YES;
    self.menuClicked = true;
}

/**
 * Refer to Apple Documentation for more in-depth explanation.
 * Called after view has appeared. 
 *
 * Doing some logic here that would not work if called prior to
 * the view appearing.
 *
 * It checks the booleans needLogout and needSegue.
 * If someone has used the overflow menu, to avoid having a massive combination
 * of segues from every screen to every screen, we pop to the root view controller,
 * which is always the main menu, and then segue to the desired screen.
 *
 * The same logic is applied to the Logout functionality, as the only segue to the
 * login screen is accessible only via the main menu view controller.
 */
- (void)viewDidAppear:(BOOL)animated {
    if(self.needLogout){
        [self performSegueWithIdentifier:@"Logout" sender:self];
        self.needLogout = FALSE;
    } else if(self.needSegue && self.segueTo != nil && ![self.segueTo isEqualToString:@""]){
        [self performSegueWithIdentifier:self.segueTo sender:self];
        self.needSegue = FALSE;
        self.segueTo = @"";
    }
}

/**
 * Called prior to calling Logout segue when Logout is selected
 * on the overflow menu.
 */
- (void)logout {
    User *user = [User instance];
    if (![User isRememberMe]) {
        user.username = nil;
    }
    user.password = nil;
    [NetworkManager getDataFor:logout
                   withOptions:nil];
    [self segue:@"Logout"];
}

@end
