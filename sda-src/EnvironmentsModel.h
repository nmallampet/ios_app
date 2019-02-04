//
//  EnvironmentsModel.h
//  sda-mobile-app
//
//  Created by Rachelle Tanase on 2/10/15.
//  Copyright (c) 2015 Serena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDADataModel.h"

@interface EnvironmentsModel : NSObject<SDADataModel>

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *createdOn;
@property (strong, nonatomic) NSString *createdBy;
@property (strong, nonatomic) NSString *appId;

- (instancetype)initWithEntry:(NSDictionary *)entry;

@end