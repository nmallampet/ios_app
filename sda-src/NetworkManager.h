//
//  NetworkManager.h
//  sda-mobile-app
//
//  Created by Anthony D'Ambrosio on 2/5/15.
//  Copyright (c) 2015 Serena. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NetworkService.h"

/**
 @author Anthony D'Ambrosio
 @brief Use this class and its static method getDataFor to get data using the RequestType enum
 @discussion Depending on the requested RequestType used in getDataFor,
      the returned dictionary may or may not contain data under STRINGIFY(requestType),
      see RequestType for info on which do
 */
@interface NetworkManager : NSObject

/**
 @author Anthony D'Ambrosio
 @brief Used to differentiate between different types of request/endpoints
 @discussion Some types may not return any data, others will (see getDataFor for details on how to extract the data).
    <br><br> <b>return data</b>: actionItems, statuses, scheduled, applications, environments, processes, resources
    <br> <b>return NO data</b>: login, logout, approveActionItem, denyActionItem, cancelStatusItem
 */
typedef enum {
    /**
     @brief Takes "username":NSString and "password":NSString
     */
    login,
    /**
     @brief Takes no options
     */
    logout,
    /**
     @brief Takes no options
     */
    actionItems,
    /**
     @brief Takes no options
     */
    statuses,
    /**
     @brief Optionally takes a "monthOffset":number
     @discussion option @{"monthOffset": x} indicates how many months in the future
        (or if negative, past) to get the data from
     */
    scheduled,
    /**
     @brief Takes an "envId":NSString, which should not be nil
     */
    applications,
    /**
     @brief Takes an "appId":NSString, which should not be nil
     */
    environments,
    /**
     @brief Takes an "appId":NSString, which should not be nil
     */
    processes,
    /**
     @brief no options
     */
    resources,
    /**
     @brief Takes a "comment":NSString and an "actionItemId":NSString
     */
    approveActionItem,
    /**
     @brief Takes a "comment":NSString and an "actionItemId":NSString
     */
    denyActionItem,
    /**
     @brief Takes a "processId":NSString
     */
    cancelStatusItem
} RequestType;

/**
 @author Anthony D'Ambrosio
 @abstract Use this static method to make a request, and potentially get data back in a dictionary
 @param type Which request to make
 @param options Additional information to pass to the request
 @discussion Depending on the type, options may need to contain certain keys,
    see each RequestType for info, <br><br>
    and the returned dictionary may contain data under STRINGIFY(requestType),
      see RequestType for info on which populate the return dictionary
 @remark Make sure that the requestType param is not a variable,
      as the STRINGIFY macro will not stringify the value, but the name
      eg: x = @"foo", STRINGIFY(x) == @"x"
 */
+ (NSDictionary *)getDataFor:(RequestType)type
                 withOptions:(NSDictionary *)options;

@end
