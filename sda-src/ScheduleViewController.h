//
//  ScheduleViewController.h
//  sda-mobile-app
//
//  Created by Evan Hughes on 2/4/15.
//  Copyright (c) 2015 Serena. All rights reserved.
//
/**
 * Header file for ScheduleViewController
 * @author Evan Hughes
 */

#import <UIKit/UIKit.h>
#import "JTCalendar.h"
#import "BaseViewController.h"

@interface ScheduleViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource, JTCalendarDataSource>

/**
 * The calendarMenuView is the top portion of the calendar, which displays the current month
 * we are viewing.
 */
@property (weak, nonatomic) IBOutlet JTCalendarMenuView *calendarMenuView;

/** 
 * The calendarContentView is the bottom portion of the calendar that displays the actual
 * days.
 */
@property (weak, nonatomic) IBOutlet JTCalendarContentView *calendarContentView;

/**
 * A reference to the calendar as a whole. Most calendar method calls are
 * done through this object.
 */
@property (strong, nonatomic) JTCalendar *calendar;

/**
 * Reference to this view's tableView, connected to Main Storyboard.
 */
@property (weak, nonatomic) IBOutlet UITableView *tableView;



@end