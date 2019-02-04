//
//  ServerInfo.h
//  sda-mobile-app
//
//  Created by Anthony D'Ambrosio on 4/16/15.
//  Copyright (c) 2015 Serena. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NetworkService.h"

@interface ServerInfo : NetworkService

/**
 * returns dictionary containing keys:
 *      [buildNumber, fullVersion, releaseVersion]
 */
- (NSDictionary *)getServerInfo;

@end
