//
//  MainMenuViewController.h
//  sda-mobile-app
//
//  Created by Anthony D'Ambrosio on 1/29/15.
//  Copyright (c) 2015 Serena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

/**
 * Header file for MainMenuViewController
 * @author Evan Hughes
 */
@interface MainMenuViewController : BaseViewController

/**
 * superView is the top level view for the main menu controller.
 *
 * scrollView is the scrollView used for when all the main menu icons
 * don't fit on the screen.
 *
 * leftView and rightView are used to split up the screen into two halves
 * for ease of aligning all the icons.
 * 
 * The hierarchy is: superView
 *                      scrollView
 *                          leftView
 *                              actionItems, scheduled, applications, resources
 *                          rightView
 *                              status, requestNewProcess, environments
 *                      copyrightLine
 *                      copyrightLabel
 *
 * For each icon on the main menu, there are two UIButtons.
 * One button contains the image (i.e. actionItemsButton).
 * The other button is just the label (i.e. actionItemsLabel).
 *
 * Finally there is a UIView of height 1px for the copyrightLine,
 * and a label for displaying the copyright ([year] Serena Software Inc., All Rights Reserved)
 *
 */
@property (strong, nonatomic) IBOutlet UIView *superView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *leftView;
@property (weak, nonatomic) IBOutlet UIView *rightView;

@property (weak, nonatomic) IBOutlet UIButton *actionItemsButton;
@property (weak, nonatomic) IBOutlet UIButton *actionItemsLabel;

@property (weak, nonatomic) IBOutlet UIButton *statusButton;
@property (weak, nonatomic) IBOutlet UIButton *statusLabel;

@property (weak, nonatomic) IBOutlet UIButton *scheduledButton;
@property (weak, nonatomic) IBOutlet UIButton *scheduledLabel;

@property (weak, nonatomic) IBOutlet UIButton *requestNewProcessButton;
@property (weak, nonatomic) IBOutlet UIButton *requestNewProcessLabel;

@property (weak, nonatomic) IBOutlet UIButton *applicationsButton;
@property (weak, nonatomic) IBOutlet UIButton *applicationsLabel;

@property (weak, nonatomic) IBOutlet UIButton *environmentsButton;
@property (weak, nonatomic) IBOutlet UIButton *environmentsLabel;

@property (weak, nonatomic) IBOutlet UIButton *resourcesButton;
@property (weak, nonatomic) IBOutlet UIButton *resourcesLabel;

@property (weak, nonatomic) IBOutlet UIView *copyrightLine;
@property (weak, nonatomic) IBOutlet UILabel *copyrightLabel;




- (IBAction)onClickAction;
- (IBAction)onClickStatus;
- (IBAction)onClickScheduled;
- (IBAction)onClickRequestProcess;
- (IBAction)onClickApplications;
- (IBAction)onClickEnvironments;

@end
