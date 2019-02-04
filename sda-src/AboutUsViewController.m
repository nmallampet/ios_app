//
//  AboutUsViewController.m
//  sda-mobile-app
//
//  Created by Vishakha Goel on 4/10/15.
//  Copyright (c) 2015 Serena. All rights reserved.
//

#import "AboutUsViewController.h"
#import "User.h"
#import "ServerInfo.h"
#import "ServerUrlStorage.h"

@interface AboutUsViewController ()

@property (strong, nonatomic) User *myUser;
@property (strong, nonatomic) NSDictionary *serverVer;
@property (strong, nonatomic) NSString *serverURL;

@end

@implementation AboutUsViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImageView *logo =[[UIImageView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/3.5, 10, 120, 55)];
    logo.image=[UIImage imageNamed:@"ic_sda_logo.png"];
    logo.contentMode = UIViewContentModeScaleAspectFill;
    [self.scrollView addSubview:logo];
    
}


//This function sets the images of the buttons, each for accessing the Facebook and the SDA community web pages
- (void) setButtonImages
{
    UIImage *fbButtonImage = [[UIImage imageNamed:@"facebook"] resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeStretch];
    UIImage *sdaButtonImage = [[UIImage imageNamed:@"sda_community"] resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeStretch];
    
    [self.fbButton setImage:fbButtonImage forState:UIControlStateNormal];
    [self.sdaButton setImage:sdaButtonImage forState:UIControlStateNormal];
}


//Sets the dimensions of the buttons
-(void) setButtonConstraints
{
    CGFloat superheight = 512;
    CGFloat bwidth = 42;
    CGFloat bheight = 52;
    CGFloat x = 10;
    CGFloat y1 = superheight*.55;
    CGFloat y2 = superheight*.65;
    
    [self.fbButton setTranslatesAutoresizingMaskIntoConstraints:YES];
    [self.sdaButton setTranslatesAutoresizingMaskIntoConstraints:YES];
    [self.fbTextButton setTranslatesAutoresizingMaskIntoConstraints:YES];
    [self.sdaTextButton setTranslatesAutoresizingMaskIntoConstraints:YES];
    
    [self.fbButton setFrame:CGRectMake(x, y1, bwidth, bheight)];
    [self.sdaButton setFrame:CGRectMake(x, y2, bwidth, bheight)];
    [self.fbTextButton setFrame:CGRectMake(bwidth/4, y1 + 2, 300 - bwidth, 50)];
    [self.sdaTextButton setFrame:CGRectMake(bwidth/2, y2 + 2, 300 - bwidth, 50)];
}


//Sets the constraints to all the labels displayed on this screen
- (void) setLabelConstraints {
    
    CGFloat x = 10;
    CGFloat width = 300;
    CGFloat height = 50;
    
    //Gets the year from the system to be displayed in the copyright label
    NSDate *copyrightYear = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"yyyy"];
    NSString *yearString = [dateFormat stringFromDate:copyrightYear];
    
    //Created a line separating the application information from the buttons to the Facebook and the SDA community web pages
    UIBezierPath *linePath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, self.scrollView.bounds.size.width - 20, 1)];
    CAShapeLayer *line = [CAShapeLayer layer];
    line.path = [linePath CGPath];
    line.fillColor = [[UIColor lightGrayColor] CGColor];
    line.frame = CGRectMake(10, 280 , self.scrollView.bounds.size.width - 20,1);
    
    //Obtain the App Version, Server Version, the server connected to, and the logged in user
    NSString *aVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
    NSDictionary *serverVersionInfo = [[ServerInfo new] getServerInfo];
    NSString *sVersion = [serverVersionInfo objectForKey:@"releaseVersion"];
    NSString *serverURL = [ServerUrlStorage getCurrentServerUrl];
    User *myUser = [User instance];
    
    
    UILabel  *AppVersion = [[UILabel alloc] initWithFrame:CGRectMake(x, 70, width, height)];
    UILabel  *AppVersionData = [[UILabel alloc] initWithFrame:CGRectMake(x, 90, width, height)];
    UILabel  *ServerVersion = [[UILabel alloc] initWithFrame:CGRectMake(x, 110, width, height)];
    UILabel  *ServerVersionData = [[UILabel alloc] initWithFrame:CGRectMake(x, 130, width, height)];
    UILabel  *ConnServer = [[UILabel alloc] initWithFrame:CGRectMake(x, 150, width, height)];
    UILabel  *ConnServerData = [[UILabel alloc] initWithFrame:CGRectMake(x, 170, width, height)];
    UILabel  *LoggedUser = [[UILabel alloc] initWithFrame:CGRectMake(x, 190, width, height)];
    UILabel  *LoggedUserData = [[UILabel alloc] initWithFrame:CGRectMake(x, 210, width, height)];
    UILabel  *copyrightLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 240, self.scrollView.bounds.size.width, 50)];
    
    copyrightLabel.textAlignment = NSTextAlignmentCenter;
    
    UIFont *labelFont = [UIFont fontWithName:@"Helvetica-Bold" size:12.0];
    UIFont *labelDataFont = [UIFont fontWithName:@"Helvetica" size:12.0];
    AppVersion.font = labelFont;
    AppVersionData.font = labelDataFont;
    ServerVersion.font = labelFont;
    ServerVersionData.font = labelDataFont;
    ConnServer.font = labelFont;
    ConnServerData.font = labelDataFont;
    LoggedUser.font = labelFont;
    LoggedUserData.font = labelDataFont;
    copyrightLabel.font = labelFont;
    
    //Set the values of the labels
    AppVersion.text = @"App. Version:";
    AppVersionData.text = aVersion;
    ServerVersion.text = @"Server Version:";
    ServerVersionData.text = sVersion;
    ConnServer.text = @"Connected Server:";
    ConnServerData.text = serverURL;
    LoggedUser.text = @"Logged in User:";
    LoggedUserData.text = myUser.username;
    copyrightLabel.text = [NSString stringWithFormat:@"© %@ Serena Software Inc., All rights reserved.", yearString];
    
    //AppVersionData.textColor = [UIColor darkGrayColor];
    //ServerVersionData.textColor = [UIColor darkGrayColor];
    //ConnServerData.textColor = [UIColor darkGrayColor];
    //LoggedUserData.textColor = [UIColor darkGrayColor];
    
    //Display the values on the screen
    [self.scrollView addSubview:AppVersion];
    [self.scrollView addSubview:AppVersionData];
    [self.scrollView addSubview:ServerVersion];
    [self.scrollView addSubview:ServerVersionData];
    [self.scrollView addSubview:ConnServer];
    [self.scrollView addSubview:ConnServerData];
    [self.scrollView addSubview:LoggedUser];
    [self.scrollView addSubview:LoggedUserData];
    [self.scrollView addSubview:copyrightLabel];
    [self.scrollView.layer addSublayer:line];
    
}


//Sets the size constraints to the view
-(void) setViewConstraints
{
    [self disableAutoResizing];
    if(self.view.frame.size.height < 500){
        [self.scrollView setContentSize:CGSizeMake(self.view.frame.size.width, 512)];
    } else {
        [self.scrollView setContentSize:CGSizeZero];
    }
    
    self.scrollView.frame = CGRectMake(0,0, self.view.bounds.size.width, self.view.bounds.size.height);
}


//Disables Xcode's autoresizing for this screen
-(void) disableAutoResizing{
    [self.scrollView setTranslatesAutoresizingMaskIntoConstraints:YES];
}

-(void) viewWillDisappear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void) viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

-(void) viewWillAppear:(BOOL)animated{
    [self setViewConstraints];
    [super viewWillAppear:animated];
}
- (void)viewDidAppear:(BOOL)animated {
    [self setViewConstraints];
    [super viewDidAppear:animated];
}

- (void)viewDidLayoutSubviews{
    [self setButtonImages];
    [self setViewConstraints];
    [self setButtonConstraints];
    [self setLabelConstraints];
}


//Action for clicking on Facebook image or the text
- (IBAction)fbButtonClick:(id)sender {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.facebook.com/profile.php?id=100006164717394"]];
    
}

- (IBAction)fbTextClick:(id)sender {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.facebook.com/profile.php?id=100006164717394"]];
    
}


//Action for clicking on the SDA image or the text
- (IBAction)sdaButtonClick:(id)sender {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://deploy-community.serena.com/community/forums/categories/listings/sda-deployment-automation"]];
    
}

- (IBAction)sdaTextClick:(id)sender {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://deploy-community.serena.com/community/forums/categories/listings/sda-deployment-automation"]];
    
}

@end


