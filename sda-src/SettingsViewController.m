//
//  SettingsViewController.m
//  sda-mobile-app
//
//  Created by Vishakha Goel on 4/23/15.
//  Copyright (c) 2015 Serena. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SettingsViewController.h"
#import "SettingsModel.h"
#import "SettingsCellView.h"
#import "ServerUrlStorage.h"

@interface SettingsViewController ()

@property (strong, nonatomic) NSArray *urls;
@property (strong, nonatomic) UIRefreshControl *refreshControl;

@end


@implementation SettingsViewController

bool expcontrol;
bool expandControl;

NSInteger whatrow;
NSMutableArray *cellStates;
UITableView *myTableView;

- (void)reloadData {
    NSArray *serverUrls = [ServerUrlStorage getServerUrlList];
    ALog(@"viewdidload SERVER URLS serverUrls %@", serverUrls);
    serverurlarray = [[NSMutableArray alloc] initWithArray:serverUrls];
    [self.tableView reloadData];
    
    [self.refreshControl endRefreshing];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    NSArray *serverUrls = [ServerUrlStorage getServerUrlList];
    ALog(@"viewdidload SERVER URLS serverUrls %@", serverUrls);
    serverurlarray = [[NSMutableArray alloc] initWithArray:serverUrls];
    
    initialClick = false;
    clickAgain = false;
    otherRow = false;
    expcontrol = false;
    expandControl = false;
    cellStates = [NSMutableArray array];
    
    for (NSInteger i = 0; i < [serverurlarray count]; i++)
        [cellStates addObject:[NSNumber numberWithInteger:0]];
    
    ALog(@"Initial states: %@", cellStates);
    
    selectedIndex = -1;
    whatrow = -1;
    [self.tableView sizeToFit];
    
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
    // TODO: 10 is a magic number
    self.refreshControl.bounds = CGRectMake(self.refreshControl.bounds.origin.x + 10,
                                            self.refreshControl.bounds.origin.y,
                                            self.refreshControl.bounds.size.width,
                                            self.refreshControl.bounds.size.height);
    [self.refreshControl beginRefreshing];
    [self.refreshControl endRefreshing];
}


//Function that validates the URL entered by the user
- (BOOL) validateUrl: (NSString *) candidate {
    NSString *urlRegEx =
    @"(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx];
    return [urlTest evaluateWithObject:candidate];
}


//Function that displays an error message if an invalid URL is entered by the user
- (void)showToastWithMessage:(NSString *)message
                     timeout:(NSInteger)timeout {
    UIAlertView *toast = [[UIAlertView alloc] initWithTitle:nil
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:nil
                                          otherButtonTitles:nil, nil];
    [toast show];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, timeout * NSEC_PER_SEC),
                   dispatch_get_main_queue(), ^{
                       [toast dismissWithClickedButtonIndex:0 animated:YES];
                   });
}


//Function to add a new URL to the server and to the screen
- (IBAction)onClickAddServerButton:(id)sender {
    NSString *inputurl = _add_serverurl_tf.text;
    
    BOOL validateUrl = [self validateUrl:inputurl];
    
    if (validateUrl){
        
        [ServerUrlStorage addToServerList:inputurl];
        [serverurlarray addObject:inputurl];
        ALog(@"numberofrows add fn %lu", [serverurlarray count]);
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        SettingsViewController *dest = [storyboard instantiateViewControllerWithIdentifier:@"Settings"];
        UINavigationController *navController = self.navigationController;
        [navController popViewControllerAnimated:NO];
        [navController pushViewController:dest animated:YES];
    }
    else {
        
        NSString *message = @"You have entered the server URL in an incorrect format. Please verify the URL. Example: http://server_name:server_port/serena_ra";
        [self showToastWithMessage:message
                           timeout:4];
        
    }
}

//Function to remove a URL from the server and the screen
- (void)removeButtonClicked:(UIButton*)sender {
    
    NSIndexPath *path = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    SettingsCellView *cell = ((SettingsCellView *) [myTableView cellForRowAtIndexPath:path]);
    [ServerUrlStorage removeFromList:cell.urlLabel.text];
    
    //Reloads the Settings Screen when a URL is removed
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    SettingsViewController *dest = [storyboard instantiateViewControllerWithIdentifier:@"Settings"];
    UINavigationController *navController = self.navigationController;
    [navController popViewControllerAnimated:NO];
    [navController pushViewController:dest animated:YES];
}


/*
**  Finds the number of URLs(rows) that have to be displayed in the settings screen.
**  If there are no rows in the table (it is empty) it displays the appropriate message.
*/
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    if(tableView == super.overflowTable){
        return [super tableView:tableView numberOfRowsInSection:section];
    }
    ALog(@"numberofrowsinsection %lu", [serverurlarray count]);
    NSInteger count = [serverurlarray count];
    if(count > 0)
        return count;
    CGRect noDataFrame = CGRectMake(10, 50, 300, 100);
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


- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    NSString *cellId = @"SettingsTableCell";
    SettingsCellView *cell = [myTableView dequeueReusableCellWithIdentifier:cellId];
    [self setLabelConstraints:cell];
}


//Adjusts the height of a long URL label to show the entire contents when a cell is selected
- (void) setLabelConstraints:(SettingsCellView *)cell {
    
    cell.urlLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.urlLabel.numberOfLines = 0;
    CGRect newFrame = cell.urlLabel.frame;
    NSLog(@"BEFORE new Frame width %f height %f",newFrame.size.width, newFrame.size.height);
    newFrame.size.width = 226;
    newFrame.size.height = 42;
    
    cell.urlLabel.frame = newFrame;
    NSLog(@"AFTER cell frame width %f height %f", cell.urlLabel.frame.size.width, cell.urlLabel.frame.size.height);
    
    [cell.urlLabel sizeToFit];
    [cell.urlLabel setTranslatesAutoresizingMaskIntoConstraints:YES];
    
}


/*
**  Populates the contents of each cell in the table.
**  It handles the view when the user clicks on a cell to expand it.
*/
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(tableView == super.overflowTable){
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
    
    NSString *cellId = @"SettingsTableCell";
    SettingsCellView *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellId owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    
    cell.urlLabel.text = [serverurlarray objectAtIndex:indexPath.row];
    cell.removeBtn.tag = indexPath.row;
    [cell.removeBtn addTarget:self
                       action:@selector(removeButtonClicked:)
             forControlEvents:UIControlEventTouchUpInside];
    NSInteger st =[[cellStates objectAtIndex:indexPath.row] integerValue];
    
    //expanded
    if (whatrow == indexPath.row && st == 1) {
        clickAgain = false;
        ALog(@"ic_action_collapse->row#%ld", (long)whatrow);
        cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [cell.expandBtn setImage:[UIImage imageNamed:@"ic_action_collapse"] forState:UIControlStateNormal];
        
        [self setLabelConstraints:cell];
        
        cell.removeBtn.hidden = NO;
    }
    else {
        ALog(@"ic_action_collapse->row#%ld", (long)whatrow);
        if(st == 0)
            [cell.expandBtn setImage:[UIImage imageNamed:@"ic_action_expand"] forState:UIControlStateNormal];
        cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
        cell.removeBtn.hidden = YES;
    }
    
    [tableView setSeparatorInset:UIEdgeInsetsZero];
    [tableView setLayoutMargins:UIEdgeInsetsZero];
    [cell setSeparatorInset:UIEdgeInsetsZero];
    [cell setLayoutMargins:UIEdgeInsetsZero];
    return cell;
}

//Returns the height of each cell depending on whether the user clicked on the cell (expanded cell will be displayed) or not
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(tableView == super.overflowTable){
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }
    CGFloat expandedheight = 100;
    CGFloat normalheight = 50;
    NSInteger st =[[cellStates objectAtIndex:indexPath.row] integerValue];
    
    if(!initialClick) {
        return normalheight;
    }
    if(st == 1) {
        return expandedheight;
    }
    else {
        return normalheight;
    }
}


//When user selects a row
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(tableView == super.overflowTable){
        [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    } else {
        
        if(!initialClick) initialClick = true;
        whatrow = indexPath.row;
        ALog(@"Row #%ld", (long)whatrow);
        
        NSNumber *s = [cellStates valueForKeyPath:@"@sum.self"];
        int sum = [s intValue];
        //NSInteger st =[[cellStates objectAtIndex:indexPath.row] integerValue];
        
        //Deselect cell
        [tableView deselectRowAtIndexPath:indexPath animated:TRUE];
        
        //For animation
        [tableView beginUpdates];
        [tableView endUpdates];
        
        if(expcontrol) {
            ALog(@"ExpControl");
            selectedIndex = indexPath.row;
            expcontrol = false;
        }
        NSInteger st =[[cellStates objectAtIndex:indexPath.row] integerValue];
        
        //user taps expanded row
        if(selectedIndex == indexPath.row && st ==1) {
            [cellStates replaceObjectAtIndex:selectedIndex withObject:@0];
            if(!clickAgain) clickAgain = true;
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
            if(sum > 0) {
                expcontrol = true;
            }
            selectedIndex = -1;
            return;
            
        }
        
        //user taps different row
        if(selectedIndex != -1) {
            NSIndexPath *prevPath = [NSIndexPath indexPathForItem:selectedIndex inSection:0];
            selectedIndex = indexPath.row;
            //if(!otherRow) otherRow = true;
            [cellStates replaceObjectAtIndex:selectedIndex withObject:@1];
            //ALog(@"Selected another row");
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:prevPath] withRowAnimation:UITableViewRowAnimationNone];
            return;
        }
        
        selectedIndex = indexPath.row;
        [cellStates replaceObjectAtIndex:selectedIndex withObject:@1];
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
        
    }
}

@end