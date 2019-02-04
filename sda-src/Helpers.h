//
//  Helpers.h
//  sda-mobile-app
//
//  Created by Anthony D'Ambrosio on 2/18/15.
//  Copyright (c) 2015 Serena. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 @author Anthony D'Ambrosio
 @brief A collection of assorted useful functions and macros
 */
@interface Helpers : NSObject

/**
 @brief ALog is a drop-in replacement for NSLog, but prepends the fmt with the function name and line number
 @remark ALog always displays output regardless of the DEBUG setting
 */
#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

/**
 @brief Returns either x OR if x is falsey: dflt
 */
#define MAYBE_NIL(x, dflt) ((x) ? (x) : (dflt))

/**
 @brief Stringifies x
 @remark Used by NetworkManager
 */
#define STRINGIFY(x) (@#x)

/**
 @brief Formats the string param to match serena's specs, ie: "LLL d, yyyy hh:mm:ss a"
 */
+ (NSString *)formatStringToDateString:(NSString *)dateString;

/**
 @brief Shows a toast (android name), ie a non-cancelable notification that lasts for timeout number of seconds
 */
+ (void)showToastWithMessage:(NSString *)message
                     timeout:(NSInteger)timeout;
@end
