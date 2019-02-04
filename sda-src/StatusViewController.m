//
//  StatusViewController.m
//  sda-mobile-app
//
//  Created by Anthony D'Ambrosio on 2/19/15.
//  Copyright (c) 2015 Serena. All rights reserved.
//

#import "StatusViewController.h"
#import "NetworkManager.h"
#import "StatusCellView.h"
#import "StatusModel.h"

@interface StatusViewController ()

@property (strong, nonatomic) NSArray *statuses;
@property (strong, nonatomic) UIRefreshControl *refreshControl;

@end

@implementation StatusViewController

NSArray *nameData;
NSArray *resData;
NSArray *proData;
NSArray *dData;

NSMutableArray *cellStates;
bool expcontrol;
bool expandControl;

NSInteger whatrow;

UITableView *myTableView;

- (void)reloadData {
    self.statuses = [[NetworkManager getDataFor:statuses
                                    withOptions:nil]
                     objectForKey:STRINGIFY(statuses)];
    [self.tableView reloadData];
    [self.tableView layoutIfNeeded];

    [self.refreshControl endRefreshing];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.statuses = [[NetworkManager getDataFor:statuses
                                    withOptions:nil]
                     objectForKey:STRINGIFY(statuses)];
    ALog(@"self.statuses %@", self.statuses);
    
    //booleans to control the states of table cell. Allow for multiple exapnding/collapsing
    initialClick = false;
    clickAgain = false;
    otherRow = false;
    expcontrol = false;
    expandControl = false;
    cellStates = [NSMutableArray array];
    
    //each tablecell state:
        // 0 = collapsed
        // 1 = expanded
    for (NSInteger i = 0; i < [self.statuses count]; i++)
        [cellStates addObject:[NSNumber numberWithInteger:0]];
    
    ALog(@"Initial states: %@", cellStates);
    self.tableView.backgroundColor = [UIColor colorWithRed:0.957 green:0.957 blue:0.957 alpha:1];
    self.tableView.backgroundView.backgroundColor = [UIColor colorWithRed:0.957 green:0.957 blue:0.957 alpha:1];

    selectedIndex = -1;
    whatrow = -1;
  
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

//number of rows
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    if(tableView == super.overflowTable){
        return [super tableView:tableView numberOfRowsInSection:section];
    }
    NSInteger count = [self.statuses count];
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

-(void)onCancelButton:(UIButton*)sender {
    NSIndexPath *path = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    StatusCellView *cell = (StatusCellView*)[myTableView cellForRowAtIndexPath:path];
    cell.nameLabel.backgroundColor = [UIColor redColor];
    NSString *processId = ((StatusModel *)self.statuses[path.row]).processId;
    [NetworkManager getDataFor:cancelStatusItem
                   withOptions:@{@"processId": processId}];
    self.statuses = [[NetworkManager getDataFor:statuses
                                    withOptions:nil]
                     objectForKey:STRINGIFY(statuses)];
    //TODO ACTUALLY DELETE THE ITEM
    [self.tableView beginUpdates];
    [self.tableView deleteRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
}

-(void)expandButton:(UIButton*)sender {
    NSIndexPath *path = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    StatusCellView *cell = (StatusCellView*)[myTableView cellForRowAtIndexPath:path];
    if(!expandControl) {
        expandControl = true;
       [cell.expandBtn setImage:[UIImage imageNamed:@"ic_action_expand"] forState:UIControlStateNormal];
    }
    else {
        expandControl = false;
        [cell.expandBtn setImage:[UIImage imageNamed:@"ic_action_collapse"] forState:UIControlStateNormal];
    }
}

//define properties of each table cell
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView == super.overflowTable){
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
    NSString *cellId = @"StatusTableCell";
    StatusCellView *cell = [tableView dequeueReusableCellWithIdentifier:cellId];

    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellId owner:self options:nil];
        cell = [nib objectAtIndex:0];
       // cell = [[StatusModel alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    cell.cancelBtn.tag = indexPath.row;
    [cell.cancelBtn addTarget:self
                       action:@selector(onCancelButton:)
             forControlEvents:UIControlEventTouchUpInside];
    

    // INITIALIZING LABELS
    StatusModel *model = ((StatusModel *)self.statuses[indexPath.row]);
    cell.nameLabel.text = [@"Generic: " stringByAppendingFormat:@"%@",
                           model.name];
    cell.resourceLabel.text = [@"Resource: " stringByAppendingFormat:@"%@",
                               model.resource];
    cell.processLabel.text = [@"Process: " stringByAppendingFormat:@"%@",
                              model.process];
    cell.createdOnLabel.text = [@"Created On: " stringByAppendingFormat: @"%@",
                                model.createdOn];

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
    CGFloat expandedheight = 140;
    CGFloat normalheight = 73;
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
