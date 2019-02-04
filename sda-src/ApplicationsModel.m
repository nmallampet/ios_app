//
//  ApplicationsModel.m
//  sda-mobile-app
//
//  Created by Anthony D'Ambrosio on 2/10/15.
//  Copyright (c) 2015 Serena. All rights reserved.
//

#import "ApplicationsModel.h"
#import "Helpers.h"

@interface ApplicationsModel ()

@end

@implementation ApplicationsModel

- (instancetype)initWithEntry:(NSDictionary *)entry {
    self.name = [entry valueForKeyPath:@"name"];
    self.createdOn = [Helpers formatStringToDateString:[entry valueForKeyPath:@"created"]];
    self.createdBy = [entry valueForKeyPath:@"user"];
    self.appId = [entry valueForKeyPath:@"id"];
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<name: '%@', createdOn: '%@', createdBy: '%@', appId: '%@'>",
            self.name, self.createdOn, self.createdBy, self.appId];
}

@end
