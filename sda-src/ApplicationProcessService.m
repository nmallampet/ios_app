//
//  ApplicationProcessService.m
//  sda-mobile-app
//
//  Created by Anthony D'Ambrosio on 2/26/15.
//  Copyright (c) 2015 Serena. All rights reserved.
//

#import "ApplicationProcessService.h"

#import "Helpers.h"
#import "RestUrls.h"

@implementation ApplicationProcessService

- (instancetype)initWithAppId:(NSString *)appId {
    NSString *url = [RestUrls urlForApplicationProcesses:appId];
    return [self initWithURL:url
           withShouldGetAuth:YES
                  withMethod:@"GET"];
}

- (NSArray *)getApplicationProcess {
    NSError *error = nil;
    id json = [self makeJsonRequestWithHeaders:nil
                                     withError:&error];
    if (!json) { ALog(@"%@", error); return nil; }

    NSArray *results = json;
    ALog(@"results: %@", results);

    return results;
}

@end
