//
//  BaseViewController.h
//  sda-mobile-app
//
//  Created by Evan Hughes on 4/17/15.
//  Copyright (c) 2015 Serena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Colors.h"
#import "Helpers.h"

@interface BaseViewController : UIViewController  <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) UITableView *overflowTable;
@property (strong, nonatomic) UIBarButtonItem *overflowButton;
@property (strong, nonatomic) UIBarButtonItem *backButton;
@property (strong, nonatomic) NSArray *overflowItems;
@property (strong, nonatomic) NSMutableArray *shownOverflowItems;
@property bool segueFromOverflow;
@property bool menuClicked;
@property bool needLogout;
@property bool needSegue;
@property (strong, nonatomic) NSString *segueTo;

/**
 * Refer to Apple Documentation for more in-depth explanation on the
 * following methods. They are all default UITableView methods called
 * for tableViews provided this delegate and datasource.
 *
 * They are listed here so that they can be called from subclasses,
 * via a call to [super tableViewMethod].
 *
 * This is so that the custom tableView methods defined both here
 * and in the various subclasses (almost all other view controllers derive
 * from this BaseViewController) do not fill their respective tableViews
 * with the wrong data (i.e. the Action Items table with OverflowMenu data 
 * or vice versa).
 */

/**
 * Defines the number of rows in a tableView
 */
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;

/**
 * Defines content of each cell in a tableView.
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

/**
 * Defines actions called upon selecting a cell in tableView.
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

/**
 * Defines height of each cell in a tableView.
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
@end
