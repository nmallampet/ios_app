//
//  ActionItemModel.h
//  sda-mobile-app
//
//  Created by Anthony D'Ambrosio on 5/31/15.
//  Copyright (c) 2015 Serena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDADataModel.h"

@interface ActionItemModel : NSObject<SDADataModel>

@property (strong, nonatomic) NSString *id;
@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSString *startDate;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *environment;
@property (strong, nonatomic) NSString *createdOn;
@property (strong, nonatomic) NSString *createdBy;
@property (strong, nonatomic) NSString *version;
@property (strong, nonatomic) NSString *snapshot;
@property (strong, nonatomic) NSString *target;

- (instancetype)initWithEntry:(NSDictionary *)entry;

@end
