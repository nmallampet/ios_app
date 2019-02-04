//
//  ActionItemViewController.m
//  sda-mobile-app
//
//  Created by Vishakha Goel on 2/6/15.
//  Copyright (c) 2015 Serena. All rights reserved.
//

#import "ActionItemViewController.h"
#import "NetworkManager.h"
#import "ActionItemsCellView.h"
#import "ActionItemModel.h"

@interface ActionItemViewController ()

@property (strong, nonatomic) NSArray *actionItems;
@property (strong, nonatomic) UIRefreshControl *refreshControl;

@end

NSArray *nameData;
NSArray *resData;
NSArray *proData;
NSArray *dData;

//an array that keeps track of each cell state in expand/collapse:
//  1: if expanded
//  0: collapsed
NSMutableArray *cellStates;


bool expcontrol;

//if expanded
bool expandControl;

//what row index user is on
NSInteger whatrow;

UITableView *myTableView;

@implementation ActionItemViewController

- (void)reloadData {
    self.actionItems = [[NetworkManager getDataFor:actionItems
                                       withOptions:nil]
                        valueForKey:STRINGIFY(actionItems)];
    [self resetCellState];
    [self.tableView reloadData];
    [self.tableView layoutIfNeeded];

    [self.refreshControl endRefreshing];
}

- (void)resetCellState {
    initialClick = false;
    clickAgain = false;
    otherRow = false;
    expcontrol = false;
    expandControl = false;

    cellStates = [NSMutableArray array];
    
    //initiate the cell states by setting all to 0 (all collapsed)
    for (NSInteger i = 0; i < [self.actionItems count]; i++) {
        [cellStates addObject:[NSNumber numberWithInteger:0]];
    }
    ALog(@"Initial states: %@", cellStates);

    //intiate user selected row index
    selectedIndex = -1;
    whatrow = -1;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.actionItems = [[NetworkManager getDataFor:actionItems
                                       withOptions:nil]
                        valueForKey:STRINGIFY(actionItems)];
    ALog(@"actionItems %@", self.actionItems);

    [self resetCellState];

    // TODO: Move to colors class?
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

//approve button functionality
-(void)approvebutton:(UIButton*)sender {
    NSIndexPath *path = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    ActionItemModel *model = ((ActionItemModel *)self.actionItems[path.row]);
    NSString *actionItemId = model.id;
    ActionItemsCellView *view = ((ActionItemsCellView *)[self.tableView cellForRowAtIndexPath:path]);
    NSString *comment = view.commentTextField.text;
    if ([comment length] == 0) {
        [Helpers showToastWithMessage:@"please enter a comment, TODO match with android"
                              timeout:2];
        return;
    }
    [NetworkManager getDataFor:approveActionItem
                   withOptions:@{@"comment": comment,
                                 @"actionItemId": actionItemId}];
}

-(void)denybutton:(UIButton*)sender {
    NSIndexPath *path = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    ActionItemModel *model = ((ActionItemModel *)self.actionItems[path.row]);
    NSString *actionItemId = model.id;
    ActionItemsCellView *view = ((ActionItemsCellView *)[self.tableView cellForRowAtIndexPath:path]);
    NSString *comment = view.commentTextField.text;
    if ([comment length] == 0) {
        [Helpers showToastWithMessage:@"please enter a comment, TODO match with android"
                              timeout:2];
        return;
    }
    [NetworkManager getDataFor:denyActionItem
                   withOptions:@{@"comment": comment,
                                 @"actionItemId": actionItemId}];
}

//number of tablecells in table, if none generate "no records found" view
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    if(tableView == super.overflowTable){
        return [super tableView:tableView numberOfRowsInSection:section];
    }
    ALog(@"count %lu", (unsigned long)[self.actionItems count]);
    NSInteger count = [self.actionItems count];
    if(count > 0)
        return count;
    CGRect noDataFrame = CGRectMake(0, 0, 300, 100);
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

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView == super.overflowTable){
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
    NSString *cellId = @"ActionItemsTableCell";
    ActionItemsCellView *cell = [tableView dequeueReusableCellWithIdentifier:cellId];

    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellId owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }

    cell.approveBtn.tag = indexPath.row;
    [cell.approveBtn addTarget:self
                        action:@selector(approvebutton:)
              forControlEvents:UIControlEventTouchUpInside];

    cell.denyBtn.tag = indexPath.row;
    [cell.denyBtn addTarget:self
                     action:@selector(denybutton:)
           forControlEvents:UIControlEventTouchUpInside];

    // INITIALIZING LABELS
    ActionItemModel *model = ((ActionItemModel *)self.actionItems[indexPath.row]);
    cell.nameLabel.text = [@"Process: " stringByAppendingFormat:@"%@", model.name];
    cell.createdOnLabel.text = [@"Created On: " stringByAppendingFormat:@"%@", model.createdOn];
    cell.createdByLabel.text = [@"Created By: " stringByAppendingFormat:@"%@", model.createdBy];
    cell.snapshotversionLabel.text = [@"Snapshot/Version: " stringByAppendingFormat:@"%@", model.version];
    cell.environmentLabel.text = [@"Environment: " stringByAppendingFormat:@"%@", model.environment];
    cell.targetLabel.text = [@"Target: " stringByAppendingFormat:@"%@", model.target];

    cell.contentView.backgroundColor = [UIColor colorWithRed:0.957 green:0.957 blue:0.957 alpha:1];
    [tableView setSeparatorInset:UIEdgeInsetsZero];
    [tableView setLayoutMargins:UIEdgeInsetsZero];
    [cell setSeparatorInset:UIEdgeInsetsZero];
    [cell setLayoutMargins:UIEdgeInsetsZero];
    return cell;
}

//size of each table cell
// 2 sizes: (expanding and collapsing) return depending on boolean state
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView == super.overflowTable){
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }
    CGFloat expandedheight = 225;
    CGFloat normalheight = 145;
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

//when row is selected, set states and boolean variables
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
        
        // Deselect cell
        [tableView deselectRowAtIndexPath:indexPath animated:TRUE];
        
        //animation stuff
        [tableView beginUpdates];
        [tableView endUpdates];
        
        if(expcontrol) {
            ALog(@"ExpCOntrol");
            selectedIndex = indexPath.row;
            expcontrol = false;
        }
        NSInteger st =[[cellStates objectAtIndex:indexPath.row] integerValue];
        
        //user taps expanded row
        if(selectedIndex == indexPath.row && st == 1) {
            [cellStates replaceObjectAtIndex:selectedIndex withObject:@0];
            //ALog(@"States: %@", cellStates);
            if(!clickAgain) clickAgain = true;
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
            if(sum > 0) {
                expcontrol = true;
            }
            selectedIndex = -1;
            // ALog(@"Call CLICK AGAIN");
            return;
        }
        
        //user taps different row
        if(selectedIndex != -1) {
            NSIndexPath *prevPath = [NSIndexPath indexPathForItem:selectedIndex inSection:0];
            selectedIndex = indexPath.row;
            //if(!otherRow) otherRow = true;
            [cellStates replaceObjectAtIndex:selectedIndex withObject:@1];
            // ALog(@"States: %@", cellStates);
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:prevPath] withRowAnimation:UITableViewRowAnimationNone];
            return;
        }
        
        selectedIndex = indexPath.row;
        [cellStates replaceObjectAtIndex:selectedIndex withObject:@1];
        // ALog(@"States: %@", cellStates);
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
        
    }
}


@end
