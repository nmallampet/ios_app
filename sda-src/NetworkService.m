//
//  NetworkService.m
//  sda-mobile-app
//
//  Created by Anthony D'Ambrosio on 2/5/15.
//  Copyright (c) 2015 Serena. All rights reserved.
//

#import "User.h"
#import "NetworkService.h"
#import "NetworkConstants.h"
#import "Helpers.h"
#import "ServerUrlStorage.h"

@interface NetworkService ()

@property (strong, nonatomic) NSString *method;
@property (strong, nonatomic) NSDictionary *headers;
@property (nonatomic) int timeout;

@end

@implementation NetworkService

- (instancetype)initWithURL:(NSString *)URL
          withShouldGetAuth:(BOOL)shouldGetAuth
                 withMethod:(NSString *)method {
    //Construct request with BASE_URL + URL
    NSString *baseServerUrl = [[NSUserDefaults standardUserDefaults]
                               stringForKey:CURRENT_SERVER_KEY];
    //Remove any trailing slash
    if ([baseServerUrl hasSuffix:@"/"]) {
        baseServerUrl = [baseServerUrl substringToIndex:[baseServerUrl length]-1];
    }

    //Append URL to the current server url
    NSString *basePlusURL = [NSString stringWithFormat:@"%@%@", baseServerUrl, URL];
    NSURL *url = [NSURL URLWithString:basePlusURL];
    self.request = [NSMutableURLRequest requestWithURL:url];

    //Add Authorization (stored in User class) to self.request
    if (shouldGetAuth) {
        User *app = [User instance];
        [self authUserWithUsername:app.username
                          password:app.password];
    }

    self.method = method;
    self.timeout = 5;

    return self;
}

- (id)makeJsonRequestWithHeaders:(NSDictionary *)headers
                       withError:(NSError **)error {
    NSError *err = nil;
    NSData *data = [self makeRequestWithMethod:self.method
                                       headers:headers
                                       timeout:self.timeout
                                         error:&err];
    if (!data || err) { ALog(@"%@", err); *error=err; return nil; }
    err = nil;
    
    id json = [self fromJson:data
                       error:&err];
    if (!json || err) {
        ALog(@"err: %@", err);
        ALog(@"json: %@", json);
        *error=err;
        return nil;
    }

    return json;
}

- (NSData *)makeRequestWithMethod:(NSString *)method
                          headers:(NSDictionary *)headers
                          timeout:(int)timeout
                            error:(NSError **)error {
    [self.request setTimeoutInterval:timeout];
    [self.request setHTTPMethod:method];
    for (id key in headers) {
        [self.request setValue:key forHTTPHeaderField:[headers objectForKey:key]];
    }
    NSHTTPURLResponse *response = nil;
    NSError *err = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:self.request
                                         returningResponse:&response
                                                     error:&err];
    if (err) {
        ALog(@"statusCode: %ld", (long)[response statusCode]);
        ALog(@"request failed: %@", err);
        ALog(@"response: %@", response);
        *error = err; return nil;
    }
    return data;
}

- (id)fromJson:(NSData *)json
         error:(NSError **)error {
    return [NSJSONSerialization
            JSONObjectWithData:json
            options:0
            error:error];
}

- (void)authUserWithUsername:(NSString *)username
                    password:(NSString *)password {
    NSString *auth = [self base64EncryptUsername:username
                                        password:password];
    [self.request setValue:auth
        forHTTPHeaderField:AUTH_HEADER];
}

- (NSString *)base64EncryptUsername:(NSString *)username
                           password:(NSString *)password {
    NSString *auth = [[[NSString stringWithFormat:@"%@:%@", username, password]
                              dataUsingEncoding:NSUTF8StringEncoding]
                             base64EncodedStringWithOptions:0];
    return [NSString stringWithFormat:AUTH_FMT_BASE64, auth];
}

@end
