//
//  RequestNewProcessViewController.h
//  sda-mobile-app
//
//  Created by Vishakha Goel on 3/12/15.
//  Copyright (c) 2015 Serena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

#define APP 0
#define ENV 1
#define PRO 2
#define SNP 3

@interface RequestNewProcessViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource> {
    UITableView *apptableView;
    UITableView *envtableView;
    UITableView *appProtableView;
    UITableView *snptableView;
    UITableView *comtableView;
    
    NSArray *appArray;
    NSArray *envArray;
    NSArray *appProArray;
    NSArray *snpArray;
    NSArray *comArray;
    NSArray *comVArray;
}



//labels
@property (nonatomic, retain) UILabel *appLabel;
@property (nonatomic, retain) UILabel *envLabel;
@property (nonatomic, retain) UILabel *appProLabel;
@property (nonatomic, retain) UILabel *snpLabel;
@property (nonatomic, retain) UILabel *comLabel;

//buttons
@property (nonatomic, retain) UIButton *appButton;
@property (nonatomic, retain) UIButton *envButton;
@property (nonatomic, retain) UIButton *appProButton;
@property (nonatomic, retain) UIButton *snpButton;

//textfields
@property (nonatomic, retain) IBOutlet UITextField *appTextField;
@property (nonatomic, retain) IBOutlet UITextField *envTextField;
@property (nonatomic, retain) IBOutlet UITextField *appProTextField;
@property (nonatomic, retain) IBOutlet UITextField *snpTextField;
@property (nonatomic, retain) IBOutlet UITextField *comTextField;
@property (nonatomic, retain) IBOutlet UITextField *comVTextField;

@end


