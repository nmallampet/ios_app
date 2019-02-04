//
//  ViewController.m
//  sda-mobile-app
//
//  Created by Anthony D'Ambrosio on 1/27/15.
//  Copyright (c) 2015 Serena. All rights reserved.
//

#import "User.h"
#import "Helpers.h"
#import "ServerUrlStorage.h"
#import "LoginViewController.h"
#import "NetworkManager.h"

@interface LoginViewController ()

@end

@implementation LoginViewController


bool buttonclick = true;

//Should hide the server table,
//set remember me to the cached value
//and set the username (if rememberMe)
//and populate the current server url
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //ui configurations
    [self.rememberMeLabel setFont:[UIFont boldSystemFontOfSize:12]];
    _switchbutton.transform = CGAffineTransformMakeScale(0.55, 0.50);
    //hide the server list
    servertable.hidden = YES;

    //set the remember me ui-switch to the cached value
    [self.rememberMeSwitch setOn:[User isRememberMe]];

    //maybe set username text-field to cached value
    if ([User isRememberMe]) {
        self.username_tf.text = [User instance].username;
    } else {
        self.username_tf.text = @"";
    }

    //TODO: FOR DEV USE ONLY
    self.username_tf.text = @"serena";
    self.password_tf.text = @"serena";
    //TODO: REMOVE ME IF NOT DEV

    //get the current server url
    self.serverurl_tf.text = [ServerUrlStorage getCurrentServerUrl];
}

//Server url tableView method
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[ServerUrlStorage getServerUrlList] count];
}

//Server url tableView method
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"serverUrlCell"];
    cell.textLabel.text = [[ServerUrlStorage getServerUrlList] objectAtIndex:indexPath.row];
    return cell;
}

//Server url tableView method
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *tabletxt = [NSString stringWithFormat:@"%@", [[ServerUrlStorage getServerUrlList] objectAtIndex:indexPath.row]];
    _serverurl_tf.text = tabletxt;
    [_serverurlbutton setImage:[UIImage imageNamed:@"ic_action_expand"] forState:UIControlStateNormal];
    servertable.hidden = YES;
    
}

//On login, should attempt to login
//and verify the current server url (storing it if it's valid)
//displaying a toast on any error
- (IBAction)onClickLoginButton:(id)sender {
    NSString *inputurl = _serverurl_tf.text;

    NSString *username = self.username_tf.text;
    NSString *password = self.password_tf.text;

    NSURL *isValidUrl = [NSURL URLWithString:inputurl];
    if (isValidUrl && isValidUrl.scheme && isValidUrl.host) {
        [ServerUrlStorage addToServerList:inputurl];
        
        [self signInWithUsername:username
                        password:password];
    } else {
        NSString *message = @"You have entered the server URL in an incorrect format. Please verify the URL. Example: http://server_name:server_port/serena_ra";
        [Helpers showToastWithMessage:message
                              timeout:2];
    }
}

//Performs the sign in, navigating to the main menu if successful or it displays a toast
- (void)signInWithUsername:(NSString *)username
                  password:(NSString *)password {
    BOOL loginSuccessful = [NetworkManager getDataFor:login
                                          withOptions:@{@"username": username,
                                                        @"password": password}];
    
    if (loginSuccessful) {
        User *user = [User instance];
        user.username = username;
        user.password = password;
        [self toMainMenu];
    } else {
        [Helpers showToastWithMessage:@"Please check your login credentials and Server URL and try again."
                              timeout:2];
    }
}

- (void)toMainMenu {
    [self performSegueWithIdentifier:@"signInSuccess"
                              sender:self];
}

//Toggle the visibility of the server url list
- (IBAction)dropDownurls:(UIButton *)sender {
    if (buttonclick) {
        [_serverurlbutton setImage:[UIImage imageNamed:@"ic_action_collapse"] forState:UIControlStateNormal];
        servertable.hidden = NO;
        buttonclick = false;
    } else {
        [_serverurlbutton setImage:[UIImage imageNamed:@"ic_action_expand"] forState:UIControlStateNormal];
        servertable.hidden = YES;
        buttonclick = true;
    }
}

//Cache whether we should remember the username's password
- (IBAction)onToggleRememberMe:(UISwitch *)sender {
    [User setRememberMe:sender.isOn];
}

@end
