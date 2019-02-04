//
//  NetworkManager.m
//  sda-mobile-app
//
//  Created by Anthony D'Ambrosio on 5/10/15.
//  Copyright (c) 2015 Serena. All rights reserved.
//

#import "NetworkManager.h"
#import "NetworkService.h"
#import "RestUrls.h"
#import "Helpers.h"

#import "ActionItemModel.h"
#import "StatusModel.h"
#import "ScheduledModel.h"
#import "ResourcesModel.h"
#import "ApplicationsModel.h"
#import "EnvironmentsModel.h"
#import "ProcessesModel.h"

@implementation NetworkManager

+ (NSDictionary *)getDataFor:(RequestType)type
                 withOptions:(NSDictionary *)options {
    if (type != login) {
        ALog(@"options: %@", options);
    }

    // GET THE CONFIG FOR THE REQUEST TYPE
    NSDictionary *config = [self getConfigFor:type
                                   andOptions:options];

    // INIT THE REQUEST
    NetworkService *service = [self initRequestForType:type
                                            withConfig:config
                                            andOptions:options];

    // MAKE THE REQUEST
    NSArray *items = [self makeRequestWithService:service];
    if (!items) { return nil; }

    // PROCESS THE RESPONSE DATA
    NSMutableDictionary *retDict = [NSMutableDictionary new];
    if (type == actionItems
        || type == statuses
        || type == resources
        || type == applications
        || type == environments
        || type == processes
        || type == scheduled) {
        NSArray *models = [self processResponseForType:type
                                            withConfig:config
                                              andItems:items];
        [retDict setValue:models forKey:[config valueForKey:@"key"]];
    }

    return retDict;
}

+ (NetworkService *)initRequestForType:(RequestType)type
                            withConfig:(NSDictionary *)config
                            andOptions:(NSDictionary *)options {
    NetworkService *service = [[NetworkService alloc] initWithURL:[config valueForKey:@"url"]
                                                withShouldGetAuth:[config valueForKey:@"auth"]
                                                       withMethod:[config valueForKey:@"method"]];
    if (type == login) {
        [service authUserWithUsername:[options valueForKey:@"username"]
                             password:[options valueForKey:@"password"]];
    } else if (type == approveActionItem) {
        id dict = @{@"comment": [options valueForKey:@"comment"],
                    @"passFail": @"passed"};
        [service.request setHTTPBody:[NSJSONSerialization
                                      dataWithJSONObject:dict
                                      options:0
                                      error:nil]];
    } else if (type == denyActionItem) {
        id dict = @{@"comment": [options valueForKey:@"comment"],
                    @"passFail": @"failed"};
        [service.request setHTTPBody:[NSJSONSerialization
                                      dataWithJSONObject:dict
                                      options:0
                                      error:nil]];
    }
    return service;
}

+ (NSArray *)makeRequestWithService:(NetworkService *)service {
    NSError *error;
    NSArray *items = [service makeJsonRequestWithHeaders:nil
                                               withError:&error];
    if (!items || error) {
        return nil;
    }
    return items;
}

+ (NSArray *)processResponseForType:(RequestType)type
                         withConfig:(NSDictionary *)config
                           andItems:(NSArray *)items {
    NSMutableArray *models = [NSMutableArray new];
    if (type == processes) {
        items = [items valueForKey:@"records"];
    } else if (type == scheduled) {
        items = [items valueForKey:@"entries"];
    }
    for (NSDictionary *entry in items) {
        [models addObject:[[[config valueForKey:@"ModelClass"] alloc]
                           initWithEntry:entry]];
    }
    return models;
}

typedef NSDictionary* (^Config)();
+ (NSDictionary *)getConfigFor:(RequestType)type
                    andOptions:(NSDictionary *)options {
    NSDictionary *config = @{
        [NSString stringWithFormat:@"%i", actionItems]: (^(){
            return @{
                @"url": APPROVAL_ACTION_ITEMS,
                @"method": @"GET",
                @"auth": @YES,
                @"ModelClass": [ActionItemModel class],
                @"key": STRINGIFY(actionItems)
                };
        }),
        [NSString stringWithFormat:@"%i", statuses]: (^() {
            return @{
                @"url": RUNNING_PROCESSES,
                @"method": @"GET",
                @"auth": @YES,
                @"ModelClass": [StatusModel class],
                @"key": STRINGIFY(statuses)
                };
        }),
        [NSString stringWithFormat:@"%i", scheduled]: (^() {
            return @{
                @"url": [self getScheduledUrlWithOptions:options],
                @"method": @"GET",
                @"auth": @YES,
                @"ModelClass": [ScheduledModel class],
                @"key": STRINGIFY(scheduled)
                };
        }),
        [NSString stringWithFormat:@"%i", resources]: (^() {
            return @{
                @"url": RESOURCES,
                @"method": @"GET",
                @"auth": @YES,
                @"ModelClass": [ResourcesModel class],
                @"key": STRINGIFY(resources)
                };
        }),
        [NSString stringWithFormat:@"%i", logout]: (^() {
            return @{
                @"url": LOGOUT_URL,
                @"method": @"GET",
                @"auth": @NO,
                };
        }),
        [NSString stringWithFormat:@"%i", login]: (^() {
            return @{
                @"url": AGENTS,
                @"method": @"GET",
                @"auth": @NO,
                };
        }),
        [NSString stringWithFormat:@"%i", applications]: (^() {
            return @{
                @"url": (![[options valueForKey:@"envId"] isEqual:@""]
                         ? [RestUrls urlForAllApplicationsUnderSelectedEnvironment:
                            [options valueForKey:@"envId"]]
                         : ALL_APPLICATIONS),
                @"method": @"GET",
                @"auth": @YES,
                @"ModelClass": [ApplicationsModel class],
                @"key": STRINGIFY(applications)
                };
        }),
        [NSString stringWithFormat:@"%i", environments]: (^() {
            return @{
                @"url": (![[options valueForKey:@"appId"] isEqual:@""]
                         ? [RestUrls urlForAllEnvironmentsUnderSelectedApplications:
                            [options valueForKey:@"appId"]]
                         : ALL_GLOBAL_ENVIRONMENTS),
                @"method": @"GET",
                @"auth": @YES,
                @"ModelClass": [EnvironmentsModel class],
                @"key": STRINGIFY(environments)
                };
        }),
        [NSString stringWithFormat:@"%i", approveActionItem]: (^() {
            return @{
                @"url": [RestUrls urlForApproveTask:[options valueForKey:@"actionItemId"]],
                @"method": @"PUT",
                @"auth": @YES,
                };
        }),
        [NSString stringWithFormat:@"%i", denyActionItem]: (^() {
            return @{
                @"url": [RestUrls urlForApproveTask:[options valueForKey:@"actionItemId"]],
                @"method": @"PUT",
                @"auth": @YES,
                };
        }),
        [NSString stringWithFormat:@"%i", cancelStatusItem]: (^() {
            return @{
                @"url": [RestUrls urlForCancelProcess:[options valueForKey:@"processId"]],
                @"method": @"PUT",
                @"auth": @YES,
                };
        }),
        [NSString stringWithFormat:@"%i", processes]: (^() {
            return @{
                @"url": [RestUrls urlForAllDeploymentsUnderSelectedApplication:
                         [options valueForKey:@"appId"]],
                @"method": @"GET",
                @"auth": @YES,
                @"ModelClass": [ProcessesModel class],
                @"key": STRINGIFY(processes)
                };
        })
    };
    return ((Config)[config valueForKey:[NSString stringWithFormat:@"%i", type]])();
}

+ (NSString *)getScheduledUrlWithOptions:(NSDictionary *)options {
    ALog(@"options: %@", options);
    // get current month
    NSDate *date = [NSDate date];
    // init calendar & components var for use in creating NSDate vars
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:
                                    (NSYearCalendarUnit | NSMonthCalendarUnit)
                                               fromDate:date];
    //add options.monthOffset to components
    NSInteger monthOffset = [[options valueForKey:@"monthOffset"] integerValue];
    // get first and last day of month
    components.day = 1;
    NSDate *dayOne = [self addMonths:monthOffset
                              toDate:[calendar dateFromComponents:components]];
    ALog(@"day1: %@", dayOne);
    [components setMonth:components.month+1];
    [components setDay:0];
    NSDate *dayLast = [self addMonths:monthOffset
                               toDate:[calendar dateFromComponents:components]];
    ALog(@"lst: %@", dayLast);
    // convert to milliseconds
    NSNumber *firstDayMillis = [NSNumber numberWithDouble:
                                ([dayOne timeIntervalSince1970]*1000)];
    NSNumber *lastDayMillis  = [NSNumber numberWithDouble:
                                ([dayLast timeIntervalSince1970]*1000)];
    
    return [RestUrls urlForScheduledProcessesWithStart:firstDayMillis
                                               withEnd:lastDayMillis];
}

+ (NSDate *)addMonths:(NSInteger)numMonths
               toDate:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];

    NSDateComponents *components = [NSDateComponents new];
    [components setMonth:numMonths];

    return [calendar dateByAddingComponents:components toDate:date options:0];
}

@end
