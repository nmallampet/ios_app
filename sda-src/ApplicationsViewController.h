//
//  ApplicationsViewController.h
//  sda-mobile-app
//
//  Created by Anthony D'Ambrosio on 2/11/15.
//  Copyright (c) 2015 Serena. All rights reserved.
//
/**
 * Header file for ApplicationsViewController
 * @author Evan Hughes
 */

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface ApplicationsViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource>

/**
 * String to indicate ID of environment we navigated from (if navigated
 * from Environments screen).
 */
@property (strong, nonatomic) NSString *envId;

/**
 * String to indicate name of environment we navigated from (if navigated
 * from Environments screen).
 */
@property (strong, nonatomic) NSString *environment;

/**
 * Reference to this view's tableView, connected to Main Storyboard.
 */
@property (weak, nonatomic) IBOutlet UITableView *tableView;

/**
 * Boolean to indicate whether or not bar displaying which Environment
 * we navigated from should be shown or not. (i.e. if came from 
 * Environments, this will be true, else false)
 */
@property bool hideNavBar;
@end
