//
//  ResourcesViewController.h
//  sda-mobile-app
//
//  Created by Anthony D'Ambrosio on 2/19/15.
//  Copyright (c) 2015 Serena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface ResourcesViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource> {
    NSIndexPath *selectedCellIndexPath;
    NSInteger selectedIndex;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

