//
//  ScheduledModel.h
//  sda-mobile-app
//
//  Created by Anthony D'Ambrosio on 2/6/15.
//  Copyright (c) 2015 Serena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDADataModel.h"

@interface ScheduledModel : NSObject<SDADataModel>

@property (strong, nonatomic) NSString *authorization;
@property (strong, nonatomic) NSString *numScheduled;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *environment;
@property (strong, nonatomic) NSString *process;
@property (strong, nonatomic) NSString *scheduledOn;
@property (strong, nonatomic) NSString *version;

- (instancetype)initWithEntry:(NSDictionary *)entry;

@end
