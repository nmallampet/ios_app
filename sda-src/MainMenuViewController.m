//
//  MainMenuViewController.m
//  sda-mobile-app
//
//  Created by Anthony D'Ambrosio on 1/29/15.
//  Copyright (c) 2015 Serena. All rights reserved.
//

#import "MainMenuViewController.h"

@interface MainMenuViewController ()
@end

/**
 * MainMenuViewController - View controller for the
 * main menu screen.
 *
 * @author Evan Hughes
 */
@implementation MainMenuViewController

/**
 * A method that sets the images of appropriate UIButtons defined in the header file.
 * Sets the titles to empty strings since they initially have titles via IB.
 */
- (void) setButtonImages
{
    UIImage *actionItemsimage = [[UIImage imageNamed:@"ic_actionapprovals"] resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeStretch];
    UIImage *scheduledImage = [[UIImage imageNamed:@"ic_scheduleddeployments"] resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeStretch];
    UIImage *applicationsImage = [[UIImage imageNamed:@"ic_applications"] resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeStretch];
    UIImage *resourcesImage = [[UIImage imageNamed:@"ic_resources"] resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeStretch];
    UIImage *statusImage = [[UIImage imageNamed:@"ic_processesstatus"] resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeStretch];
    UIImage *requestImage = [[UIImage imageNamed:@"ic_reqnewprocess"] resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeStretch];
    UIImage *environmentsImage = [[UIImage imageNamed:@"ic_environments"] resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeStretch];
    
    [self.actionItemsButton setImage:actionItemsimage forState:UIControlStateNormal];
    [self.scheduledButton setImage:scheduledImage forState:UIControlStateNormal];
    [self.applicationsButton setImage:applicationsImage forState:UIControlStateNormal];
    [self.resourcesButton setImage:resourcesImage forState:UIControlStateNormal];
    [self.statusButton setImage:statusImage forState:UIControlStateNormal];
    [self.requestNewProcessButton setImage:requestImage forState:UIControlStateNormal];
    [self.environmentsButton setImage:environmentsImage forState:UIControlStateNormal];

    [self.actionItemsButton setTitle:@"" forState:UIControlStateNormal];
    [self.scheduledButton setTitle:@"" forState:UIControlStateNormal];
    [self.applicationsButton setTitle:@"" forState:UIControlStateNormal];
    [self.scheduledButton setTitle:@"" forState:UIControlStateNormal];
    [self.statusButton setTitle:@"" forState:UIControlStateNormal];
    [self.requestNewProcessButton setTitle:@"" forState:UIControlStateNormal];
    [self.environmentsButton setTitle:@"" forState:UIControlStateNormal];
}

/**
 * Method that sets the frames of all the buttons.
 */
-(void) setButtonConstraints
{
    CGFloat superheight = 512;
    CGFloat bwidth = 62;
    CGFloat bheight = 72;
    CGFloat x = self.leftView.frame.size.width / 2;
    CGFloat rx = self.rightView.frame.size.width / 2;
    CGFloat y1 = superheight*.225;
    CGFloat y2 = superheight*.425;
    CGFloat y3 = superheight*.625;
    CGFloat y4 = superheight*.825;
    CGRect frame = CGRectZero;
    frame.size = CGSizeMake(bwidth, bheight);
    
    [self.actionItemsButton setTranslatesAutoresizingMaskIntoConstraints:YES];
    [self.scheduledButton setTranslatesAutoresizingMaskIntoConstraints:YES];
    [self.applicationsButton setTranslatesAutoresizingMaskIntoConstraints:YES];
    [self.resourcesButton setTranslatesAutoresizingMaskIntoConstraints:YES];
    [self.statusButton setTranslatesAutoresizingMaskIntoConstraints:YES];
    [self.requestNewProcessButton setTranslatesAutoresizingMaskIntoConstraints:YES];
    [self.environmentsButton setTranslatesAutoresizingMaskIntoConstraints:YES];
    
    [self.actionItemsButton setFrame:frame];
    [self.scheduledButton setFrame:frame];
    [self.applicationsButton setFrame:frame];
    [self.resourcesButton setFrame:frame];
    [self.statusButton setFrame:frame];
    [self.environmentsButton setFrame:frame];
    [self.requestNewProcessButton setFrame:frame];

    [self.actionItemsButton setCenter:CGPointMake(x, y1)];
    [self.scheduledButton setCenter:CGPointMake(x, y2)];
    [self.applicationsButton setCenter:CGPointMake(x, y3)];
    [self.resourcesButton setCenter:CGPointMake(x, y4)];
    [self.statusButton setCenter:CGPointMake(rx, y1)];
    [self.requestNewProcessButton setCenter:CGPointMake(rx, y2)];
    [self.environmentsButton setCenter:CGPointMake(rx, y3)];
}

/**
 * Method that sets the frames of all the button labels.
 */
- (void) setLabelConstraints {

    CGFloat superheight = 512;
    CGFloat bheight = 72;
    CGFloat x = self.leftView.frame.size.width / 2;
    CGFloat rx = self.rightView.frame.size.width / 2;
    CGFloat y1 = superheight*.225 + bheight/2;
    CGFloat y2 = superheight*.425 + bheight/2;
    CGFloat y3 = superheight*.625 + bheight/2;
    CGFloat y4 = superheight*.825 + bheight/2;
    
    [self.actionItemsLabel setTranslatesAutoresizingMaskIntoConstraints:YES];
    [self.scheduledLabel setTranslatesAutoresizingMaskIntoConstraints:YES];
    [self.applicationsLabel setTranslatesAutoresizingMaskIntoConstraints:YES];
    [self.resourcesLabel setTranslatesAutoresizingMaskIntoConstraints:YES];
    [self.statusLabel setTranslatesAutoresizingMaskIntoConstraints:YES];
    [self.requestNewProcessLabel setTranslatesAutoresizingMaskIntoConstraints:YES];
    [self.environmentsLabel setTranslatesAutoresizingMaskIntoConstraints:YES];
    
    [self.actionItemsLabel setCenter:CGPointMake(x, y1)];
    [self.scheduledLabel setCenter:CGPointMake(x, y2)];
    [self.applicationsLabel setCenter:CGPointMake(x, y3)];
    [self.resourcesLabel setCenter:CGPointMake(x, y4)];
    [self.statusLabel setCenter:CGPointMake(rx - 5, y1)];
    [self.requestNewProcessLabel setCenter:CGPointMake(rx, y2)];
    [self.environmentsLabel setCenter:CGPointMake(rx, y3)];

}

/**
 * Sets frames for scrollView, leftView, and rightView.
 */
-(void) setViewConstraints
{
    [self.scrollView setTranslatesAutoresizingMaskIntoConstraints:YES];
    [self.leftView setTranslatesAutoresizingMaskIntoConstraints:YES];
    [self.rightView setTranslatesAutoresizingMaskIntoConstraints:YES];

    if(self.view.frame.size.height < 500){
        [self.scrollView setContentSize:CGSizeMake(self.view.frame.size.width, 512)];
    } else {
        [self.scrollView setContentSize:CGSizeZero];
    }
    CGFloat rx = self.view.bounds.size.width/2.;
    CGFloat width = self.view.bounds.size.width/2.;
    CGFloat height = (self.view.bounds.size.height)*(.9);
    self.scrollView.frame = CGRectMake(0,0, self.view.bounds.size.width, height);
    self.leftView.frame = CGRectMake(0, 0, width, height);
    self.rightView.frame = CGRectMake(rx, 0, width, height);

    [self.leftView setCenter:CGPointMake(self.scrollView.bounds.size.width/4,height/2.)];
    [self.rightView setCenter:CGPointMake(self.scrollView.bounds.size.width*(.75),height/2.)];
    UIInterfaceOrientation orientation = (UIInterfaceOrientation)[[UIDevice currentDevice] orientation];
    if(orientation == 1){
        [self.rightView setCenter:CGPointMake(240,height/2.)];
    }
}
/**
 * Dynamically calculates current year for copyrightLabel,
 * and sets frames of copyrightLabel and copyrightLine appropriately.
 */
- (void) setCopyrightView {
    CGFloat width = self.view.bounds.size.width/2.;
    CGFloat height = (self.view.bounds.size.height)*(.9);
    NSDate *copyrightYear = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"Y"];
    NSString *yearString = [dateFormat stringFromDate:copyrightYear];
    [self.copyrightLabel setFont:[UIFont systemFontOfSize:10]];
    self.copyrightLabel.textAlignment = NSTextAlignmentCenter;
    self.copyrightLabel.text = [NSString stringWithFormat:@"© %@ Serena Software Inc., All rights reserved.", yearString];
    self.copyrightLine.frame = CGRectMake(0, height, self.view.bounds.size.width, 1);
    CGRect copyrightFrame = self.copyrightLine.frame;
    copyrightFrame.size.width = self.view.bounds.size.width;
    copyrightFrame.size.height = 15;
    copyrightFrame.origin.x = self.view.frame.origin.x;
    copyrightFrame.origin.y += 10;
    self.copyrightLabel.frame = copyrightFrame;
}

/**
 * Refer to Apple Documentation for more in-depth explanation.
 * Lays out subviews of super view.
 */
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self setButtonImages];
    [self setViewConstraints];
    [self setButtonConstraints];
    [self setLabelConstraints];
    [self setCopyrightView];
}

/**
 * The following are just some helper functions to log when
 * main menu actions are clicked.
 * Very useful in debugging. Feel free to comment out if you feel they
 * are crowding the debug console.
 */

- (IBAction)onClickAction {
    ALog(@"onClickAction");
}

- (IBAction)onClickStatus {
    ALog(@"onClickStatus");
}

- (IBAction)onClickScheduled {
    ALog(@"onClickScheduled");
}

- (IBAction)onClickRequestProcess {
    ALog(@"onClickRequestProcess");
}

- (IBAction)onClickApplications {
    ALog(@"onClickApplications");
}

- (IBAction)onClickEnvironments {
    ALog(@"onClickEnvironments");
}

@end