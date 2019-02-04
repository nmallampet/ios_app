//
//  EnvironmentsViewController.h
//  sda-mobile-app
//
//  Created by Anthony D'Ambrosio on 2/12/15.
//  Copyright (c) 2015 Serena. All rights reserved.
//
/**
 * Header file for EnvironmentsViewController
 * @author Evan Hughes
 */
#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface EnvironmentsViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource>

/**
 * String to indicate ID of Application we navigated from (if navigated
 * from Applications screen).
 */
@property (strong, nonatomic) NSString *appId;

/**
 * String to indicate name of Application we navigated from (if navigated
 * from Applications screen).
 */
@property (strong, nonatomic) NSString *application;

/**
 * Reference to this view's tableView, connected to Main Storyboard.
 */
@property (weak, nonatomic) IBOutlet UITableView *tableView;

/**
 * Boolean to indicate whether or not bar displaying which Application
 * we navigated from should be shown or not. (i.e. if came from
 * Applications, this will be true, else false)
 */
@property bool hideNavBar;
@end
