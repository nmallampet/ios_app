//
//  SettingsViewController.h
//  sda-mobile-app
//
//  Created by Vishakha Goel on 4/23/15.
//  Copyright (c) 2015 Serena. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "ServerUrlStorage.h"

@interface SettingsViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource> {
    
    NSIndexPath *selectedCellIndexPath;
    NSInteger selectedIndex;
    bool initialClick;
    bool clickAgain;
    bool otherRow;
    
    NSMutableArray *serverurlarray;
}

@property (strong, nonatomic) NSMutableArray *expandedCells;
@property (weak, nonatomic) IBOutlet UITextField *add_serverurl_tf;
@property (weak, nonatomic) IBOutlet UIButton *add_serverurl_button;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)onClickAddServerButton:(id)sender;

@end
