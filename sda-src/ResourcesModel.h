//
//  ResourcesModel.h
//  sda-mobile-app
//
//  Created by Anthony D'Ambrosio on 2/10/15.
//  Copyright (c) 2015 Serena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDADataModel.h"

@interface ResourcesModel : NSObject<SDADataModel>

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *parent;
@property (strong, nonatomic) NSString *pstatus;
@property (strong, nonatomic) NSArray *children;

- (instancetype)initWithEntry:(NSDictionary *)entry;

@end
