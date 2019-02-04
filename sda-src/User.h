//
//  User.h
//  sda-mobile-app
//
//  Created by Anthony D'Ambrosio on 2/19/15.
//  Copyright (c) 2015 Serena. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 @author Anthony D'Ambrosio
 @brief Use this class to cache the user's credentials & whether the app should remember the user's username
 @discussion Get a User instance using [User instance], and access either the username and password fields
    or call the rememberMe accessor functions
 @remark This class uses NSUserDefaults for caching/storage,
    see it for further details (eg: on persistance)
 */
@interface User : NSObject

@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *password;

/**
 @brief Use this to get a User instance
 */
+ (User *)instance;
/**
 @brief Use this to set whether the app should remember the user's username
 */
+ (void)setRememberMe:(BOOL)b;
/**
 @brief Use this to check if the app should remember the user's username
 */
+ (BOOL)isRememberMe;

@end
