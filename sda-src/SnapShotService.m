//
//  SnapShotService.m
//  sda-mobile-app
//
//  Created by Anthony D'Ambrosio on 2/26/15.
//  Copyright (c) 2015 Serena. All rights reserved.
//

#import "SnapShotService.h"

#import "Helpers.h"
#import "RestUrls.h"

@implementation SnapShotService

- (instancetype)initWithAppId:(NSString *)appId {
    NSString *url = [RestUrls urlForApplicationSnapshots:appId];
    return [self initWithURL:url
           withShouldGetAuth:YES
                  withMethod:@"GET"];
}

- (NSArray *)getSnapShot {
    NSError *error = nil;
    id json = [self makeJsonRequestWithHeaders:nil
                                     withError:&error];
    if (!json) { ALog(@"%@", error); return nil; }

    NSArray *results = json;
    ALog(@"results: %@", results);

    return results;
}

@end
