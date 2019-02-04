//
//  ViewController.h
//  sda-mobile-app
//
//  Created by Anthony D'Ambrosio on 1/27/15.
//  Copyright (c) 2015 Serena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    IBOutlet UITableView *servertable;
    NSMutableArray *serverurlarray;
}

//TODO: Change textfields from snake-case to camel-case
//textfields
@property (weak, nonatomic) IBOutlet UITextField *username_tf;
@property (weak, nonatomic) IBOutlet UITextField *password_tf;
@property (weak, nonatomic) IBOutlet UITextField *serverurl_tf;

//buttons
@property (weak, nonatomic) IBOutlet UIButton *login_button;
@property (weak, nonatomic) IBOutlet UIButton *serverurlbutton;

//rememberme label
@property (weak, nonatomic) IBOutlet UILabel *rememberMeLabel;

//Remember Me Switch
@property (weak, nonatomic) IBOutlet UISwitch *rememberMeSwitch;

//swtich on and off
@property (weak, nonatomic) IBOutlet UISwitch *switchbutton;

- (IBAction)dropDownurls:(UIButton *)sender;

- (IBAction)onClickLoginButton:(id)sender;

@end
