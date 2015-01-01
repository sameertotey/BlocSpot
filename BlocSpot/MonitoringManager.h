//
//  MonitoringManager.h
//  BlocSpot
//
//  Created by Sameer Totey on 12/31/14.
//  Copyright (c) 2014 Sameer Totey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserLocation.h"

@interface MonitoringManager : NSObject

- (void)resetRegionMonitoring;
@property(nonatomic, strong)UserLocation *userLocation;

@end
