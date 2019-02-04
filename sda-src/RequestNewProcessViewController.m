//
//  RequestNewProcessViewController.m
//  sda-mobile-app
//
//  Created by Vishakha Goel on 3/12/15.
//  Copyright (c) 2015 Serena. All rights reserved.
//

#import "RequestNewProcessViewController.h"

#import "ProcessesViewController.h"
#import "ProcessesModel.h"

#import "ApplicationsViewController.h"
#import "ApplicationsCellView.h"

#import "EnvironmentsViewController.h"
#import "EnvironmentsCellView.h"

@interface RequestNewProcessViewController ()

@end



@implementation RequestNewProcessViewController

@synthesize appLabel;
@synthesize envLabel;
@synthesize appProLabel;
@synthesize snpLabel;
@synthesize comLabel;

@synthesize appButton;
@synthesize envButton;
@synthesize appProButton;
@synthesize snpButton;

@synthesize appTextField;
@synthesize envTextField;
@synthesize appProTextField;
@synthesize snpTextField;
@synthesize comTextField;
@synthesize comVTextField;

UITableView *myTableView;
UIButton *myButton;
UITextField *myTextField;

NSArray *myArray;
bool buttonClicked;
int stage;

NSString *appString = @"appCell";
NSString *envString = @"envCell";
NSString *appProString = @"proCell";
NSString *snpString = @"snpCell";
NSString *myString;


/*
 not completed
 Idea: 
    create a new drop down menu (table with table cell) after selecting a value from the previous 
    drop down menu 
    Ex: Initially creat a drop down for Application, then after seleciting, create a drop down for env.
*/
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    buttonClicked = false;
    
    appArray = [[NSArray alloc] initWithObjects:@"Application 1", @"Application 2", @"Application 3", nil];
    myArray = appArray;
    
    //create application label and textfield
    appLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 120, 200, 30)];
    [appLabel setBackgroundColor:[UIColor clearColor]];
    [appLabel setText:@"Application"];
    [appLabel setFont:[UIFont boldSystemFontOfSize:17]];
    [[self view] addSubview:appLabel];
    
    appTextField = [[UITextField alloc] initWithFrame:CGRectMake(25, 150, 250, 30)];
    [appTextField setBackgroundColor:[UIColor clearColor]];
    appTextField.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    appTextField.layer.borderWidth=1.0;
    [[self view] addSubview:appTextField];
    myTextField = appTextField;
    
    apptableView=[[UITableView alloc]init];
    apptableView.frame = CGRectMake(25,180,250,90);
    apptableView.dataSource=self;
    apptableView.delegate=self;
    apptableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [apptableView registerClass:[UITableViewCell class] forCellReuseIdentifier:appString];
    [apptableView reloadData];
    [apptableView.layer setBorderWidth: 1.0];
    [apptableView.layer setBorderColor:[[UIColor lightGrayColor]CGColor]];
    [self.view addSubview:apptableView];
    myTableView = apptableView;
    myString = appString;
    apptableView.hidden = YES;
    
    appButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [appButton addTarget:self
               action:@selector(buttonExpand:)
     forControlEvents:UIControlEventTouchUpInside];
    [appButton setImage:[UIImage imageNamed:@"ic_action_expand"] forState:UIControlStateNormal];
    appButton.frame = CGRectMake(225, 150, 60, 30.0);
    [[self view] addSubview:appButton];
    myButton = appButton;
    
    stage = APP;
    [self.view bringSubviewToFront:super.overflowTable];
    /*
    //create environment label and textfield
    envLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 180, 200, 30)];
    [envLabel setBackgroundColor:[UIColor clearColor]];
    [envLabel setText:@"Environment"];
    [envLabel setFont:[UIFont boldSystemFontOfSize:17]];
    [[self view] addSubview:envLabel];
    
    envTextField = [[UITextField alloc] initWithFrame:CGRectMake(25, 210, 250, 30)];
    [envTextField setBackgroundColor:[UIColor clearColor]];
    envTextField.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    envTextField.layer.borderWidth=1.0;
    [[self view] addSubview:envTextField];

    //create environment label and textfield
    appProLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 240, 200, 30)];
    [appProLabel setBackgroundColor:[UIColor clearColor]];
    [appProLabel setText:@"Application Process"];
    [appProLabel setFont:[UIFont boldSystemFontOfSize:17]];
    [[self view] addSubview:appProLabel];
    
    appProTextField = [[UITextField alloc] initWithFrame:CGRectMake(25, 270, 250, 30)];
    [appProTextField setBackgroundColor:[UIColor clearColor]];
    appProTextField.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    appProTextField.layer.borderWidth=1.0;
    [[self view] addSubview:appProTextField];
    
    //create environment label and textfield
    snpLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 300, 200, 30)];
    [snpLabel setBackgroundColor:[UIColor clearColor]];
    [snpLabel setText:@"Snap Shot"];
    [snpLabel setFont:[UIFont boldSystemFontOfSize:17]];
    [[self view] addSubview:snpLabel];
    
    snpTextField = [[UITextField alloc] initWithFrame:CGRectMake(25, 330, 250, 30)];
    [snpTextField setBackgroundColor:[UIColor clearColor]];
    snpTextField.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    snpTextField.layer.borderWidth=1.0;
    [[self view] addSubview:snpTextField];
    
    //create component label and textfield
    comLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 360, 200, 30)];
    [comLabel setBackgroundColor:[UIColor clearColor]];
    [comLabel setText:@"Component Version"];
    [comLabel setFont:[UIFont boldSystemFontOfSize:17]];
    [[self view] addSubview:comLabel];
    
    comTextField = [[UITextField alloc] initWithFrame:CGRectMake(25, 390, 140, 30)];
    [comTextField setBackgroundColor:[UIColor clearColor]];
    comTextField.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    comTextField.layer.borderWidth=1.0;
    [[self view] addSubview:comTextField];
    comVTextField = [[UITextField alloc] initWithFrame:CGRectMake(170, 390, 105, 30)];
    [comVTextField setBackgroundColor:[UIColor clearColor]];
    comVTextField.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    comVTextField.layer.borderWidth=1.0;
    [[self view] addSubview:comVTextField];
    */
    
   // _switchbutton.transform = CGAffineTransformMakeScale(0.75, 0.65);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == super.overflowTable){
        return [super tableView:tableView numberOfRowsInSection:section];
    }
    tableView = myTableView;
    return [appArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == super.overflowTable){
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
    tableView = myTableView;
     NSString *CellIdentifier = myString;
    UITableViewCell *cell = [apptableView dequeueReusableCellWithIdentifier:CellIdentifier   forIndexPath:indexPath] ;
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@", [myArray objectAtIndex:indexPath.row]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == super.overflowTable){
        [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    } else {
        tableView = myTableView;
        myTextField.text = [NSString stringWithFormat:@"%@", [myArray objectAtIndex:indexPath.row]];
        
        myTableView.hidden = YES;
        [myButton setImage:[UIImage imageNamed:@"ic_action_expand"] forState:UIControlStateNormal];
        buttonClicked = false;

        ALog(@"CLICKED AND AT STAGE %d", stage);
        switch(stage) {
            case APP:
                [self envStage];
                break;
            case ENV:
                [self proStage];
                break;
            case PRO:
                [self snpStage];
                break;
            default:
                ALog(@"DEFAULT LOG");
                break;
        }
    }
}


- (void) envStage {
    
    stage = ENV;
    
    envArray = [[NSArray alloc] initWithObjects:@"Environment 1", @"Environment 2", @"Environment 3", nil];
    myArray = envArray;
    
    //create environment label and textfield
    envLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 180, 200, 30)];
    [envLabel setBackgroundColor:[UIColor clearColor]];
    [envLabel setText:@"Environment"];
    [envLabel setFont:[UIFont boldSystemFontOfSize:17]];
    [[self view] addSubview:envLabel];
    
    envTextField = [[UITextField alloc] initWithFrame:CGRectMake(25, 210, 250, 30)];
    [envTextField setBackgroundColor:[UIColor clearColor]];
    envTextField.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    envTextField.layer.borderWidth=1.0;
    [[self view] addSubview:envTextField];
    myTextField = envTextField;
    
    apptableView = nil;
    envtableView=[[UITableView alloc]init];
    envtableView.frame = CGRectMake(25,240,250,90);
    envtableView.dataSource=self;
    envtableView.delegate=self;
    envtableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [envtableView registerClass:[UITableViewCell class] forCellReuseIdentifier:envString];
    [envtableView reloadData];
    [envtableView.layer setBorderWidth: 1.0];
    [envtableView.layer setBorderColor:[[UIColor lightGrayColor]CGColor]];
    [self.view addSubview:envtableView];
    myTableView = envtableView;
    myString = envString;
    envtableView.hidden = YES;

    envButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [envButton addTarget:self
                  action:@selector(buttonExpand:)
        forControlEvents:UIControlEventTouchUpInside];
    [envButton setImage:[UIImage imageNamed:@"ic_action_expand"] forState:UIControlStateNormal];
    envButton.frame = CGRectMake(225, 210, 60, 30.0);
    [[self view] addSubview:envButton];
    myButton = envButton;
    
}

- (void) proStage {
    
    stage = PRO;
    
    appProArray = [[NSArray alloc] initWithObjects:@"Application Process 1", @"Application Process 2", @"Application Process 3", nil];
    myArray = appProArray;
    
    
    appProLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 240, 200, 30)];
    [appProLabel setBackgroundColor:[UIColor clearColor]];
    [appProLabel setText:@"Application Process"];
    [appProLabel setFont:[UIFont boldSystemFontOfSize:17]];
    [[self view] addSubview:appProLabel];
    
    appProTextField = [[UITextField alloc] initWithFrame:CGRectMake(25, 270, 250, 30)];
    [appProTextField setBackgroundColor:[UIColor clearColor]];
    appProTextField.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    appProTextField.layer.borderWidth=1.0;
    [[self view] addSubview:appProTextField];
    myTextField = appProTextField;
    
    envtableView = nil;
    appProtableView=[[UITableView alloc]init];
    appProtableView.frame = CGRectMake(25,300,250,90);
    appProtableView.dataSource=self;
    appProtableView.delegate=self;
    appProtableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [appProtableView registerClass:[UITableViewCell class] forCellReuseIdentifier:appProString];
    [appProtableView reloadData];
    [appProtableView.layer setBorderWidth: 1.0];
    [appProtableView.layer setBorderColor:[[UIColor lightGrayColor]CGColor]];
    [self.view addSubview:appProtableView];
    myTableView = appProtableView;
    myString = appProString;
    appProtableView.hidden = YES;
    
    appProButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [appProButton addTarget:self
                  action:@selector(buttonExpand:)
        forControlEvents:UIControlEventTouchUpInside];
    [appProButton setImage:[UIImage imageNamed:@"ic_action_expand"] forState:UIControlStateNormal];
    appProButton.frame = CGRectMake(225, 270, 60, 30.0);
    [[self view] addSubview:appProButton];
    myButton = appProButton;
    
}

- (void) snpStage {
    
    stage = SNP;
    
    snpArray = [[NSArray alloc] initWithObjects:@"1.0", @"2.0", @"3.0", nil];
    myArray = snpArray;
    
    
    snpLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 300, 200, 30)];
    [snpLabel setBackgroundColor:[UIColor clearColor]];
    [snpLabel setText:@"Snap Shot"];
    [snpLabel setFont:[UIFont boldSystemFontOfSize:17]];
    [[self view] addSubview:snpLabel];
    
    snpTextField = [[UITextField alloc] initWithFrame:CGRectMake(25, 330, 250, 30)];
    [snpTextField setBackgroundColor:[UIColor clearColor]];
    snpTextField.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    snpTextField.layer.borderWidth=1.0;
    [[self view] addSubview:snpTextField];
    myTextField = snpTextField;
    
    appProtableView = nil;
    snptableView=[[UITableView alloc]init];
    snptableView.frame = CGRectMake(25,360,250,90);
    snptableView.dataSource=self;
    snptableView.delegate=self;
    snptableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [snptableView registerClass:[UITableViewCell class] forCellReuseIdentifier:snpString];
    [snptableView reloadData];
    [snptableView.layer setBorderWidth: 1.0];
    [snptableView.layer setBorderColor:[[UIColor lightGrayColor]CGColor]];
    [self.view addSubview:snptableView];
    myTableView = snptableView;
    myString = snpString;
    snptableView.hidden = YES;
    
    snpButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [snpButton addTarget:self
                     action:@selector(buttonExpand:)
           forControlEvents:UIControlEventTouchUpInside];
    [snpButton setImage:[UIImage imageNamed:@"ic_action_expand"] forState:UIControlStateNormal];
    snpButton.frame = CGRectMake(225, 330, 60, 30.0);
    [[self view] addSubview:snpButton];
    myButton = snpButton;
    
}

-(void)buttonExpand:(UIButton*)sender {
    if(!buttonClicked) {
        [myButton setImage:[UIImage imageNamed:@"ic_action_collapse"] forState:UIControlStateNormal];
        myTableView.hidden = NO;
        buttonClicked = true;
    }
    else {
        [myButton setImage:[UIImage imageNamed:@"ic_action_expand"] forState:UIControlStateNormal];
        myTableView.hidden = YES;
        buttonClicked = false;
    }
    
}

@end
