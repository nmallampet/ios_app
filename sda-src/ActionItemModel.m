//
//  ActionItemModel.m
//  sda-mobile-app
//
//  Created by Rachelle Tanase on 2/10/15.
//  Copyright (c) 2015 Serena. All rights reserved.
//

#import "ActionItemModel.h"
#import "Helpers.h"

@interface ActionItemModel ()

@end

@implementation ActionItemModel

- (instancetype)initWithEntry:(NSDictionary *)entry {
    self.startDate = [entry valueForKeyPath:@"startDate"];
    self.name = [entry valueForKeyPath:@"name"];
    self.id = [entry valueForKeyPath:@"id"];
    self.environment = MAYBE_NIL([entry valueForKeyPath:@"environment"], @"N/A");
    self.createdOn = [Helpers formatStringToDateString:
                      [entry valueForKeyPath:@"startDate"]];
    self.type = [entry valueForKeyPath:@"type"];
    self.createdBy = MAYBE_NIL([entry valueForKeyPath:@"user"], @"Generic Process");
    self.version = MAYBE_NIL([entry valueForKeyPath:@"version"], @"N/A");
    self.snapshot = MAYBE_NIL([entry valueForKeyPath:@"snapshot"], @"N/A");
    self.target = MAYBE_NIL([entry valueForKeyPath:@"target"], @"N/A");
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<ActionItemsModel: id:'%@', name:'%@', createdBy:'%@', createdOn'%@', env:'%@', target:'%@'>",
            self.id, self.name, self.createdBy, self.createdOn, self.environment, self.target];
}

@end
