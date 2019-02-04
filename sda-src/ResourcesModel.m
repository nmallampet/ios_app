//
//  ResourcesModel.m
//  sda-mobile-app
//
//  Created by Anthony D'Ambrosio on 2/10/15.
//  Copyright (c) 2015 Serena. All rights reserved.
//

#import "ResourcesModel.h"

@interface ResourcesModel ()

@end

@implementation ResourcesModel

- (instancetype)initWithEntry:(NSDictionary *)entry {
    self.name = [entry valueForKeyPath:@"name"];
    self.parent = [entry valueForKeyPath:@"agent.name"];
    self.pstatus = [entry valueForKeyPath:@"status"];
    self.children = [entry valueForKey:@"children"];
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<name: '%@', agent: '%@', pStatus: '%@', children: '%@'>",
            self.name, self.parent, self.pstatus, self.children];
}

@end
