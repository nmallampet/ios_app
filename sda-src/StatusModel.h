//
//  StatusModel.h
//  sda-mobile-app
//
//  Created by Rachelle Tanase on 2/10/15.
//  Copyright (c) 2015 Serena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDADataModel.h"

@interface StatusModel : NSObject<SDADataModel>

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSString *subtype;
@property (strong, nonatomic) NSString *process;
@property (strong, nonatomic) NSString *resource;
@property (strong, nonatomic) NSString *createdOn;
@property (strong, nonatomic) NSString *buttonCancel;
@property (strong, nonatomic) NSString *processId;

- (instancetype)initWithEntry:(NSDictionary *)entry;

@end