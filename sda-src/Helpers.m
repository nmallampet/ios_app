//
//  Helpers.m
//  sda-mobile-app
//
//  Created by Anthony D'Ambrosio on 4/9/15.
//  Copyright (c) 2015 Serena. All rights reserved.
//

#import "Helpers.h"

@implementation Helpers

+ (NSString *)formatStringToDateString:(NSString *)dateString {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"LLL d, yyyy hh:mm:ss a"];
    long long int num = [dateString longLongValue];
    NSDate *d = [NSDate dateWithTimeIntervalSince1970:num/1000.0];
    NSString *createdOnDate = [NSString stringWithFormat:@"%@",[df stringFromDate:d]];
    return createdOnDate;
}

+ (void)showToastWithMessage:(NSString *)message
                     timeout:(NSInteger)timeout {
    UIAlertView *toast = [[UIAlertView alloc] initWithTitle:nil
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:nil
                                          otherButtonTitles:nil, nil];
    [toast show];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, timeout * NSEC_PER_SEC),
                   dispatch_get_main_queue(), ^{
                       [toast dismissWithClickedButtonIndex:0 animated:YES];
                   });
}

@end
