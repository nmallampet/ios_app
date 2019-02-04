//
//  ProcessesViewController.h
//  sda-mobile-app
//
//  Created by Anthony D'Ambrosio on 2/13/15.
//  Copyright (c) 2015 Serena. All rights reserved.
//
/**
 * Header file for ProcessesViewController
 * @author Evan Hughes
 */

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface ProcessesViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource>

/**
 * String to indicate ID of which Application we came from.
 */
@property (strong, nonatomic) NSString *appId;

/**
 * String to indicate ID of which Environment we came from.
 */
@property (strong, nonatomic) NSString *envId;

/**
 * String to indicate name of which Application we came from.
 */
@property (strong, nonatomic) NSString *application;

/**
 * String to indicate name of which Environment we came from.
 */
@property (strong, nonatomic) NSString *environment;

/**
 * Reference to this view's tableView, connected to Main Storyboard.
 */
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
