//
//  ScheduledModel.m
//  sda-mobile-app
//
//  Created by Anthony D'Ambrosio on 2/6/15.
//  Copyright (c) 2015 Serena. All rights reserved.
//

#import "ScheduledModel.h"

@interface ScheduledModel ()

@end

@implementation ScheduledModel

- (instancetype)initWithEntry:(NSDictionary *)entry {
    self.environment = [entry valueForKeyPath:@"environment.name"];
    self.name = [entry valueForKeyPath:@"name"];
    self.version = [entry valueForKeyPath:@"applicationProcess.version"];
    self.process = [entry valueForKeyPath:@"name"];

    NSString *scheduledDate = [entry valueForKeyPath:@"scheduledDate"];
    NSTimeInterval timestamp = (NSTimeInterval)[scheduledDate doubleValue]/1000;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    self.scheduledOn = dateString;

    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<name: '%@', environment: '%@', scheduledOn: '%@', process: '%@', version: '%@'>",
            self.name, self.environment, self.scheduledOn, self.process, self.version];
}

@end
