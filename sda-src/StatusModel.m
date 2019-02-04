//
//  StatusModel.m
//  sda-mobile-app
//
//  Created by Rachelle Tanase on 2/10/15.
//  Copyright (c) 2015 Serena. All rights reserved.
//

#import "StatusModel.h"
#import "Helpers.h"

@interface StatusModel ()

@end

@implementation StatusModel

- (instancetype)initWithEntry:(NSDictionary *)entry {
    self.name = [entry valueForKeyPath:@"genericProcess.name"];
    self.subtype = [entry valueForKeyPath:@"subtype"];
    self.type = [entry valueForKeyPath:@"type"];
    self.process = [entry valueForKeyPath:@"genericProcessRequest.process.name"];
    self.resource = [entry valueForKeyPath:@"resource.name"];
    self.createdOn = [Helpers formatStringToDateString:[entry valueForKeyPath:@"startDate"]];
    self.buttonCancel = [entry valueForKeyPath:@"buttonCancel"];
    self.processId = [entry valueForKeyPath:@"workflowTraceId"]; //processId?
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<status: name: '%@', processId:'%@', process:'%@'>",
            self.name, self.processId, self.process]; //processId?
}

@end