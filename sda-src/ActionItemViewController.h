//
//  ActionItemViewController.h
//  sda-mobile-app
//
//  Created by Vishakha Goel on 2/6/15.
//  Copyright (c) 2015 Serena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface ActionItemViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource> {
    NSIndexPath *selectedCellIndexPath;
    NSInteger selectedIndex;
    bool initialClick;
    bool clickAgain;
    bool otherRow;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
