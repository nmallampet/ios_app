//
//  ApplicationsModel.h
//  sda-mobile-app
//
//  Created by Anthony D'Ambrosio on 2/10/15.
//  Copyright (c) 2015 Serena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDADataModel.h"

@interface ApplicationsModel : NSObject<SDADataModel>

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *createdOn;
@property (strong, nonatomic) NSString *createdBy;
@property (strong, nonatomic) NSString *appId;

- (instancetype)initWithEntry:(NSDictionary *)entry;

@end
