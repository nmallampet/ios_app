//
//  SettingsCellView.h
//  sda-mobile-app
//
//  Created by Vishakha Goel on 4/23/15.
//  Copyright (c) 2015 Serena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsCellView : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *urlLabel;
@property (weak, nonatomic) IBOutlet UIButton *removeBtn;
@property (weak, nonatomic) IBOutlet UIButton *expandBtn;

@end