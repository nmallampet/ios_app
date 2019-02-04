//
//  ApplicationsCellView.h
//  sda-mobile-app
//
//  Created by Anthony D'Ambrosio on 2/10/15.
//  Copyright (c) 2015 Serena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ApplicationsCellView : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *createdOnLabel;
@property (weak, nonatomic) IBOutlet UILabel *createdByLabel;

@end
