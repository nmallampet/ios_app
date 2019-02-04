//
//  NetworkService.h
//  sda-mobile-app
//
//  Created by Anthony D'Ambrosio on 2/5/15.
//  Copyright (c) 2015 Serena. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RestUrls.h"

/**
 * @author Anthony D'Ambrosio
 * @brief Create an instance of this class to make network request to the current SDA server
 */
@interface NetworkService : NSObject

@property (strong, nonatomic) NSString *authorization;
@property (strong, nonatomic) NSMutableURLRequest *request;

/**
 * @author Anthony D'Ambrosio
 * @brief Preferred init method, appends URL to the current server url, and will try to auth using cached user info if it 'shouldGetAuth'
 * @discussion Uses Storage#CURRENT_SERVER_KEY as the base url,
 *      and will call authUserWithUsername:password: using
 *      app.username and app.password if shouldGetAuth is truthy
 * @param URL Appended to Storage#CURRENT_SERVER_KEY and the result is used as the end url to make the request against
 * @param shouldGetAuth If truthy, it will authenticate the user
 * @return A NetworkService object
 */
- (instancetype)initWithURL:(NSString *)URL
          withShouldGetAuth:(BOOL)shouldGetAuth
                 withMethod:(NSString *)method;

/**
 * @author Anthony D'Ambrosio
 * @brief Base function for making a request
 * @param method
 * @param headers Additional headers that will be sent in the request, WARNING: will override previous headers
 * @param timeout Number of seconds before the request will timeout
 * @param error Will be set on error
 */
- (NSData *)makeRequestWithMethod:(NSString *)method
                          headers:(NSDictionary *)headers
                          timeout:(int)timeout
                            error:(NSError **)error;

/**
 * @author Anthony D'Ambrosio
 * @brief Used to make a json request against self.URL@self.method using the headers param
 * @param headers A dictionary containing headers
 * @param error A reference to an NSError object that will be set if there was an error
 * @return A json object
 */
- (id)makeJsonRequestWithHeaders:(NSDictionary *)headers
                       withError:(NSError **)error;

/**
 * @author Anthony D'Ambrosio
 * @brief Base64 encrypts the username and password params, and puts them into a header using AUTH_HEADER as the key
 * @param username The user's username
 * @param password The user's password
 */
- (void)authUserWithUsername:(NSString *)username
                    password:(NSString *)password;

/**
 * @author Anthony D'Ambrosio
 * @brief Decrypts and returns the data contained in the json param
 * @param json The data to decrypt
 * @param error NSError reference that will be set on error
 * @return The decrypted json value as an objective-c value
 */
- (id)fromJson:(NSData *)json error:(NSError **)error;

@end
