//
//  ProcessesModel.h
//  sda-mobile-app
//
//  Created by Anthony D'Ambrosio on 2/10/15.
//  Copyright (c) 2015 Serena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDADataModel.h"

@interface ProcessesModel : NSObject<SDADataModel>

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *createdOn;
@property (strong, nonatomic) NSString *createdBy;
@property (strong, nonatomic) NSString *status;
@property (strong, nonatomic) NSString *error;
@property (strong, nonatomic) NSString *state;
@property (strong, nonatomic) NSString *result;
@property (strong, nonatomic) NSString *entry;
@property (strong, nonatomic) NSString *rootTrace;
@property (strong, nonatomic) NSString *paused;
@property (strong, nonatomic) NSString *failed;
@property (strong, nonatomic) NSString *metadata;
@property (strong, nonatomic) NSString *notNeeded;
@property (strong, nonatomic) NSString *approval;
@property (strong, nonatomic) NSString *approvalFailed;
@property (strong, nonatomic) NSString *approvalFinished;
@property (strong, nonatomic) NSString *approvalCancelled;

- (instancetype)initWithEntry:(NSDictionary *)entry;

@end
