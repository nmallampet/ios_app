//
//  ResourcesViewController.m
//  sda-mobile-app
//
//  Created by Anthony D'Ambrosio on 2/19/15.
//  Copyright (c) 2015 Serena. All rights reserved.
//

#import "ResourcesViewController.h"
#import "NetworkManager.h"
#import "ResourcesModel.h"
#import "ResourcesCellView.h"

@interface ResourcesViewController ()

@property (strong, nonatomic) NSArray *resources;
@property (strong, nonatomic) UIRefreshControl *refreshControl;

@end

bool hasChildren = false;
bool clicked = false;

CGFloat normalHeight = 85;
CGFloat expandedHeight = 85;

@implementation ResourcesViewController

- (void)reloadData {
    self.resources = [[NetworkManager getDataFor:resources
                                    withOptions:nil]
                     objectForKey:STRINGIFY(resources)];
    [self.tableView reloadData];

    [self.refreshControl endRefreshing];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.resources = [[NetworkManager getDataFor:resources
                                     withOptions:nil]
                      valueForKey:STRINGIFY(resources)];
    ALog(@"self.resources %@", self.resources);
    
    selectedIndex = -1;
    
   // self.tableView.backgroundColor = [UIColor colorWithRed:0.957 green:0.957 blue:0.957 alpha:1];
   // self.tableView.backgroundView.backgroundColor = [UIColor colorWithRed:0.957 green:0.957 blue:0.957 alpha:1];

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

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    if(tableView == super.overflowTable){
        return [super tableView:tableView numberOfRowsInSection:section];
    }
    NSInteger count = [self.resources count];
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
    return count;}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView == super.overflowTable){
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
//    NSString *cellId = @"SimpleTableItem";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
//
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
//                                      reuseIdentifier:cellId];
//    }
    
    NSString *cellId = @"ResourceTableCell";
    ResourcesCellView *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellId owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }

    cell.backgroundColor = gray1;

    // INITIALIZING LABELS
    ResourcesModel *model = ((ResourcesModel *)self.resources[indexPath.row]);
    cell.nameLabel.text = model.name;
    cell.parentLabel.text = model.parent;
    
    NSArray *childs = model.children;
    
    if(childs.count) {
        hasChildren = true;
        NSArray *resID = [childs valueForKey: @"id"];
//        NSArray *resNames = [childs valueForKey: @"name"];
//        NSArray *resActives = [childs valueForKey: @"active"];
//        NSArray *resStatuses = [childs valueForKey: @"status"];
        expandedHeight += resID.count * 30;
    }
    else {
        cell.expandButton.hidden = YES;
    }
    
    NSString *pstatus = model.pstatus;
    if([pstatus isEqualToString:@"ONLINE"]) {
        cell.statusLabel.text = @"Online";
        cell.statusLabel.textColor = resOnlineForeground;
        cell.statusLabel.backgroundColor = resOnlineBackground;
    }
    else if ([pstatus isEqualToString:@"OFFINE"]) {
        cell.statusLabel.text=@"Offline";
        cell.statusLabel.textColor=resOfflineForeground;
        cell.statusLabel.backgroundColor=resOfflineBackground;
    }
    else {
        cell.statusLabel.text=@"Unknown";
        cell.statusLabel.textColor = gray4;
        cell.statusLabel.backgroundColor = gray3;
    }
    
    if(hasChildren) {
        cell.statusLabel.center = CGPointMake(8,41 + 30);
    }
    [tableView setSeparatorInset:UIEdgeInsetsZero];
    [tableView setLayoutMargins:UIEdgeInsetsZero];
    [cell setSeparatorInset:UIEdgeInsetsZero];
    [cell setLayoutMargins:UIEdgeInsetsZero];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == super.overflowTable){
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }
    
    if(hasChildren && clicked) {
        CGFloat t = expandedHeight;
        expandedHeight = normalHeight;
        return t;
    }
    
    
    return normalHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView == super.overflowTable){
        [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    } else {
        
        if(hasChildren) {
            clicked = true;
        
            // Deselect cell
            [tableView deselectRowAtIndexPath:indexPath animated:TRUE];
        
            //animation stuff
            [tableView beginUpdates];
            [tableView endUpdates];
        
        
            //user taps expanded row
            if(selectedIndex == indexPath.row) {
                if(clicked) clicked = false;
                [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
                selectedIndex = -1;
                return;
            }
        
            //user taps different row
            if(selectedIndex != -1) {
                NSIndexPath *prevPath = [NSIndexPath indexPathForItem:selectedIndex inSection:0];
                selectedIndex = indexPath.row;
                [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:prevPath] withRowAnimation:UITableViewRowAnimationNone];
                return;
            }
        
            selectedIndex = indexPath.row;
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
    }
}
@end
