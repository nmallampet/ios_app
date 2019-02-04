//
//  ServerInfo.m
//  sda-mobile-app
//
//  Created by Anthony D'Ambrosio on 4/16/15.
//  Copyright (c) 2015 Serena. All rights reserved.
//

#import "ServerInfo.h"

#import "Helpers.h"
#import "RestUrls.h"

@implementation ServerInfo

- (instancetype)init {
    NSString *url = SERVER_BUILD;
    return [self initWithURL:url
           withShouldGetAuth:YES
                  withMethod:@"GET"];
}

- (NSDictionary *)getServerInfo {
    NSError *error = nil;
    id json = [self makeJsonRequestWithHeaders:nil
                                     withError:&error];
    if (!json) { ALog(@"%@", error); return nil; }

    id result = json;
    ALog(@"result: %@", result);

    return result;
}

@end
