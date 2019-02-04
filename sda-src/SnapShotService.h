//
//  SnapShotService.h
//  sda-mobile-app
//
//  Created by Anthony D'Ambrosio on 2/26/15.
//  Copyright (c) 2015 Serena. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NetworkService.h"

@interface SnapShotService : NetworkService

- (instancetype)initWithAppId:(NSString *)appId;

- (NSArray *)getSnapShot;

@end
