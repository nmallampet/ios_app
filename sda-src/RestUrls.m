//
//  RestUrls.m
//  sda-mobile-app
//
//  Created by Anthony D'Ambrosio on 2/10/15.
//  Copyright (c) 2015 Serena. All rights reserved.
//

#import "RestUrls.h"

// GET calls //
NSString * const LOGOUT_URL = @"/tasks/LoginTasks/logout";
NSString * const REST_LOGIN_URL = @"/rest/system/login";
NSString * const RUNNING_PROCESSES = @"/rest/workflow/currentActivity?rowsPerPage=250&orderField=startDate&sortType=desc";
NSString * const SCHEDULED_PROCESS = @"/rest/deploy/schedule/calendar/%@/%@";
NSString * const APPROVAL_ACTION_ITEMS = @"/rest/approval/task/tasksForUser";
NSString * const ALL_GLOBAL_ENVIRONMENTS = @"/rest/deploy/globalEnvironment";
NSString * const ALL_APPLICATIONS_UNDER_SELECTED_ENVIRONMENT = @"/rest/deploy/globalEnvironment/%@/applications";
NSString * const ALL_DEPLOYMENTS_UNDER_SELECTED_APPLICATION = @"/rest/deploy/applicationProcessRequest/table?rowsPerPage=250&filterFields=application.id&filterValue_application.id=%@&filterType_application.id=eq&filterClass_application.id=UUID";
NSString * const ALL_APPLICATIONS = @"/rest/deploy/application?rowsPerPage=250&sortType=asc";
NSString * const ALL_ENVIRONMENTS_UNDER_SELECTED_APPLICATIONS = @"/rest/deploy/application/%@/fullEnvironments";
NSString * const ALL_DEPLOYMENTS_UNDER_SELECTED_ENVIRONMENT = @".scheduledDate&sortType=desc&filterFields=environment.id&filterValue_environment.id=%@&filterType_environment.id=eq&filterClass_environment.id=UUID";
NSString * const APPLICATION_SNAPSHOTS = @"/rest/deploy/application/%@/snapshots/true";
NSString * const APPLICATION_SNAPSHOTS_FOR_ENVIRONMENTS = @"/rest/deploy/application/%@/%@/snapshotsForEnvironment/false";
NSString * const APPLICATION_PROCESSES = @"/rest/deploy/application/%@/executableProcesses";
NSString * const COMPONENT_SPECIFIC_VERSIONS = @"/rest/deploy/environment/%@/versions/%@";
NSString * const COMPONENT_WITH_STATUS = @"/rest/deploy/status/versionStatuses";
NSString * const COMPONENT_WITH_ENVIRONMENTS = @"/rest/deploy/status/inventoryStatuses";
NSString * const SERVER_BUILD = @"/rest/system/configuration/buildInfo";
NSString * const RESOURCES = @"/rest/resource/resource/tree?rowsPerPage=99999&pageNumber=1&orderField=name&sortType=asc";
NSString * const AGENTS = @"/rest/agent";

// POST calls //
NSString * const LOGIN_URL = @"/tasks/LoginTasks/login";

// PUT calls //
NSString * const DEPLOY_URL = @"/rest/deploy/application";
NSString * const RUN_PROCESS = @"/rest/deploy/application/%@/runProcess";
NSString * const CANCEL_PROCESS = @"/rest/workflow/%@/cancel";
NSString * const PAUSE_PROCESS = @"/rest/workflow/%@/pause";
NSString * const APPROVE_TASK = @"/rest/approval/task/%@/close";

// DELETE calls //
NSString * const DELETE_CALENDAR_ENTRY = @"/rest/calendar/entry/%@";
NSString * const DELETE_CALENDAR_RECURRING = @"/rest/calendar/recurring/%@";

@implementation RestUrls

// GET CALLS //
+ (NSString *)urlForScheduledProcessesWithStart:(id)start
                                        withEnd:(id)end {
    return [NSString stringWithFormat:SCHEDULED_PROCESS, start, end];
}

+ (NSString *)urlForAllApplicationsUnderSelectedEnvironment:(id)envId {
    return [NSString stringWithFormat:ALL_APPLICATIONS_UNDER_SELECTED_ENVIRONMENT, envId];
}

+ (NSString *)urlForAllDeploymentsUnderSelectedApplication:(id)appId {
    return [NSString stringWithFormat:ALL_DEPLOYMENTS_UNDER_SELECTED_APPLICATION, appId];
}

+ (NSString *)urlForAllEnvironmentsUnderSelectedApplications:(id)appId {
    return [NSString stringWithFormat:ALL_ENVIRONMENTS_UNDER_SELECTED_APPLICATIONS, appId];
}

+ (NSString *)urlForAllDeploymentsUnderSelectedEnvironment:(id)envId {
    return [NSString stringWithFormat:ALL_DEPLOYMENTS_UNDER_SELECTED_ENVIRONMENT, envId];
}

+ (NSString *)urlForApplicationSnapshots:(id)appId {
    return [NSString stringWithFormat:APPLICATION_SNAPSHOTS, appId];
}

+ (NSString *)urlForApplication:(id)appId
       SnapshotsForEnvironments:(id)envId {
    return [NSString stringWithFormat:APPLICATION_SNAPSHOTS_FOR_ENVIRONMENTS, appId, envId];
}

+ (NSString *)urlForApplicationProcesses:(id)appId {
    return [NSString stringWithFormat:APPLICATION_PROCESSES, appId];
}

+ (NSString *)urlForComponent:(id)compId SpecificVersionsWithEnvironment:(id)envId {
    return [NSString stringWithFormat:COMPONENT_SPECIFIC_VERSIONS, envId, compId];
}

// PUT CALLS //
+ (NSString *)urlForRunProcessWithApp:(id)appId {
    return [NSString stringWithFormat:RUN_PROCESS, appId];
}

+ (NSString *)urlForCancelProcess:(id)traceId {
    return [NSString stringWithFormat:CANCEL_PROCESS, traceId];
}

+ (NSString *)urlForPauseProcess:(id)traceId {
    return [NSString stringWithFormat:PAUSE_PROCESS, traceId];
}

+ (NSString *)urlForApproveTask:(id)taskId {
    return [NSString stringWithFormat:APPROVE_TASK, taskId];
}

// DELETE CALLS //
+ (NSString *)urlForDeleteCalendarEntry:(id)entryId {
    return [NSString stringWithFormat:DELETE_CALENDAR_ENTRY, entryId];
}

+ (NSString *)urlForDeleteCalendarRecurring:(id)entryId {
    return [NSString stringWithFormat:DELETE_CALENDAR_RECURRING, entryId];
}

@end
