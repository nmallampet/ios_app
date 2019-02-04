//
//  Storage.h
//  sda-mobile-app
//
//  Created by Anthony D'Ambrosio on 4/9/15.
//  Copyright (c) 2015 Serena. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 @author Anthony D'Ambrosio
 @brief Manages the server url list and the current server url
 @discussion The server url list is a Set, meaning there can be no duplicates
 */
@interface ServerUrlStorage : NSObject

extern NSString * const SERVER_LIST_KEY;
extern NSString * const CURRENT_SERVER_KEY;

/**
 @brief Gets the full server list
 */
+ (NSArray *)getServerUrlList;
/**
 @brief Gets the current server url, from when the user logged in
 */
+ (NSString *)getCurrentServerUrl;
/**
 @brief Adds the url to the server url list if it is not found
 */
+ (void)addToServerList:(NSString *)url;
/**
 @brief Removes the url from the server url list
 */
+ (void)removeFromList:(NSString *)url;
/**
 @brief Removes all servers from the server url list
 */
+ (void)clearServerList;

@end
