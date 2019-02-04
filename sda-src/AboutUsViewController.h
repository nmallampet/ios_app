//
//  AboutUsViewController.h
//  sda-mobile-app
//
//  Created by Vishakha Goel on 4/10/15.
//  Copyright (c) 2015 Serena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface AboutUsViewController : BaseViewController<NSURLConnectionDelegate>

//@property (weak, nonatomic) IBOutlet UIView *copyrightLine;
//@property (weak, nonatomic) IBOutlet UILabel *copyrightLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) IBOutlet UIButton *fbButton;
@property (strong, nonatomic) IBOutlet UIButton *sdaButton;
@property (weak, nonatomic) IBOutlet UIButton *fbTextButton;
@property (weak, nonatomic) IBOutlet UIButton *sdaTextButton;

- (IBAction)fbButtonClick:(id)sender;
- (IBAction)sdaButtonClick:(id)sender;
- (IBAction)fbTextClick:(id)sender;
- (IBAction)sdaTextClick:(id)sender;

@end