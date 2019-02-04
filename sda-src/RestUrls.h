//
//  RestUrls.h
//  sda-mobile-app
//
//  Created by Anthony D'Ambrosio on 2/10/15.
//  Copyright (c) 2015 Serena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RestUrls : NSObject

// GET CALLS //
extern NSString * const LOGOUT_URL;
extern NSString * const REST_LOGIN_URL;
extern NSString * const RUNNING_PROCESSES;
extern NSString * const APPROVAL_ACTION_ITEMS;
extern NSString * const ALL_GLOBAL_ENVIRONMENTS;
extern NSString * const ALL_APPLICATIONS;
extern NSString * const COMPONENT_WITH_STATUS;
extern NSString * const COMPONENT_WITH_ENVIRONMENTS;
extern NSString * const SERVER_BUILD;
extern NSString * const RESOURCES;
extern NSString * const AGENTS;
+ (NSString *)urlForScheduledProcessesWithStart:(id)start withEnd:(id)end;
+ (NSString *)urlForAllApplicationsUnderSelectedEnvironment:(id)envId;
+ (NSString *)urlForAllDeploymentsUnderSelectedApplication:(id)appId;
+ (NSString *)urlForAllEnvironmentsUnderSelectedApplications:(id)appId;
+ (NSString *)urlForAllDeploymentsUnderSelectedEnvironment:(id)envId;
+ (NSString *)urlForApplicationSnapshots:(id)appId;
+ (NSString *)urlForApplication:(id)appId
       SnapshotsForEnvironments:(id)envId;
+ (NSString *)urlForApplicationProcesses:(id)appId;
+ (NSString *)urlForComponent:(id)compId SpecificVersionsWithEnvironment:(id)envId;

// POST CALLS //
extern NSString * const LOGIN_URL;

// PUT CALLS //
extern NSString * const DEPLOY_URL;
+ (NSString *)urlForRunProcessWithApp:(id)appId;
+ (NSString *)urlForCancelProcess:(id)traceId;
+ (NSString *)urlForPauseProcess:(id)traceId;
+ (NSString *)urlForApproveTask:(id)taskId;

// DELETE CALLS //
+ (NSString *)urlForDeleteCalendarEntry:(id)entryId;
+ (NSString *)urlForDeleteCalendarRecurring:(id)entryId;

@end
