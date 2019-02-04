//
//  Storage.m
//  sda-mobile-app
//
//  Created by Anthony D'Ambrosio on 4/9/15.
//  Copyright (c) 2015 Serena. All rights reserved.
//

#import "ServerUrlStorage.h"

#import <Foundation/Foundation.h>

NSString * const SERVER_LIST_KEY = @"Server List";
NSString * const CURRENT_SERVER_KEY = @"Current Server Url";

@implementation ServerUrlStorage

+ (NSArray *)getServerUrlList {
    return [[NSUserDefaults standardUserDefaults]
            arrayForKey:SERVER_LIST_KEY];
}

+ (NSString *)getCurrentServerUrl {
    return [[NSUserDefaults standardUserDefaults]
            objectForKey:CURRENT_SERVER_KEY];
}

+ (void)setCurrentServerUrl:(NSString *)url {
    [[NSUserDefaults standardUserDefaults]
     setObject:url forKey:CURRENT_SERVER_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)updateServerList:(NSArray *(^)(NSMutableArray *))updateList {
    NSArray *serverUrlList = [ServerUrlStorage getServerUrlList];
    // Make a mutable copy
    NSMutableArray *mutableServerUrlList = (serverUrlList == nil
                                            ? [NSMutableArray new]
                                            : [serverUrlList mutableCopy]);
    // Update and sync the updated list
    NSArray *updatedServerUrlList = updateList(mutableServerUrlList);
    [[NSUserDefaults standardUserDefaults] setObject:updatedServerUrlList
                                              forKey:SERVER_LIST_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)addToServerList:(NSString *)url {
    [ServerUrlStorage updateServerList:^NSArray *(NSMutableArray *serverList) {
        // Add url and remove duplicates
        [serverList addObject:url];
        NSOrderedSet *orderedSet = [NSOrderedSet orderedSetWithArray:serverList];
        return [orderedSet array];
    }];
    [ServerUrlStorage setCurrentServerUrl:url];
}

+ (void)removeFromList:(NSString *)url {
    [ServerUrlStorage updateServerList:^NSArray *(NSMutableArray *serverList) {
        // Remove url from the list
        [serverList removeObject:url];
        return [serverList copy];
    }];
}

+ (void)clearServerList {
    [ServerUrlStorage updateServerList:^NSArray *(NSMutableArray *serverList) {
        return @[];
    }];
}

@end
