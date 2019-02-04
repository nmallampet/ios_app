//
//  SettingsModel.m
//  sda-mobile-app
//
//  Created by Vishakha Goel on 4/23/15.
//  Copyright (c) 2015 Serena. All rights reserved.
//

#import "SettingsModel.h"

@interface SettingsModel ()

@end

@implementation SettingsModel

- (instancetype)initWithEntry:(NSDictionary *)entry {
    self.url = [entry valueForKeyPath:@"server.url"];
    self.buttonRemove = [entry valueForKeyPath:@"buttonRemove"];
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<url: '%@'>", self.url];
}

@end
