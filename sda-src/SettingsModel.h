//
//  SettingsModel.h
//  sda-mobile-app
//
//  Created by Vishakha Goel on 4/23/15.
//  Copyright (c) 2015 Serena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDADataModel.h"

@interface SettingsModel : NSObject<SDADataModel>

@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) NSString *buttonRemove;

- (instancetype)initWithEntry:(NSDictionary *)entry;

@end