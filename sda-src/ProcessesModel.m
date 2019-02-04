//
//  ProcessesModel.m
//  sda-mobile-app
//
//  Created by Anthony D'Ambrosio on 2/10/15.
//  Copyright (c) 2015 Serena. All rights reserved.
//

#import "ProcessesModel.h"
#import "Helpers.h"

@interface ProcessesModel ()

@end

@implementation ProcessesModel

- (instancetype)initWithEntry:(NSDictionary *)entry {
    self.name              = [self entryValue:@"entry.name" dictionary:entry];
    self.createdOn         = [self entryValue:@"submittedTime" dictionary:entry];
    self.createdBy         = [self entryValue:@"userName" dictionary:entry];
    self.failed            = [self entryValue:@"failed" dictionary:entry];
    self.status            = [self entryValue:@"result" dictionary:entry];
    self.error             = [self entryValue:@"error" dictionary:entry];
    self.rootTrace         = [self entryValue:@"rootTrace" dictionary:entry];
    self.paused            = [self entryValue:@"rootTrace.paused" dictionary:entry];
    self.state             = [self entryValue:@"rootTrace.state" dictionary:entry];
    self.result            = [self entryValue:@"rootTrace.result" dictionary:entry];
    self.metadata          = [self entryValue:@"rootTrace.metadata" dictionary:entry];
    self.notNeeded         = [self entryValue:@"rootTrace.metadata.notNeeded" dictionary:entry];
    self.entry             = [self entryValue:@"entry" dictionary:entry];
    self.approval          = [self entryValue:@"approval" dictionary:entry];
    self.approvalFailed    = [self entryValue:@"approval.failed" dictionary:entry];
    self.approvalFinished  = [self entryValue:@"approval.finished" dictionary:entry];
    self.approvalCancelled = [self entryValue:@"approval.cancelled" dictionary:entry];
    return self;
}

//asserts that object returned from dictionary will be a string
- (NSString *) entryValue: (NSString *) path
               dictionary: (NSDictionary *) entry{
    if(![entry valueForKeyPath:path] && ![[entry valueForKeyPath:path] isKindOfClass:[NSString class]]){
        return [[entry valueForKeyPath:path] stringValue];
    }
    return [entry valueForKeyPath:path];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<name: '%@' \n createdOn: '%@' \n createdBy: '%@' \n status: '%@' \n rootTrace: '%@' \n failed: '%@' \n error: '%@' \n state: '%@' \n result: '%@' >",
            self.name, self.createdOn, self.createdBy, self.status, self.rootTrace, self.failed, self.error, self.state, self.result];
}

@end
