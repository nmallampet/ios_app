//
//  EnvironmentsModel.m
//  sda-mobile-app
//
//  Created by Rachelle Tanase on 2/10/15.
//  Copyright (c) 2015 Serena. All rights reserved.
//

#import "EnvironmentsModel.h"
#import "Helpers.h"

@interface EnvironmentsModel ()

@end

@implementation EnvironmentsModel

- (instancetype)initWithEntry:(NSDictionary *)entry {
    self.name = [entry valueForKeyPath:@"name"];;
    self.createdOn = [Helpers formatStringToDateString:[entry valueForKeyPath:@"created"]];
    self.createdBy = [entry valueForKeyPath:@"user"];
    self.appId = [entry valueForKeyPath:@"id"];
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<EnvironmentsModel: '%@', createdOn: '%@', createdBy: '%@', appId: '%@'",
            self.name, self.createdOn, self.createdBy, self.appId];
}

@end