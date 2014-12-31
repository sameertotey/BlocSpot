//
//  UserLocation.h
//  BlocSpot
//
//  Created by Sameer Totey on 12/30/14.
//  Copyright (c) 2014 Sameer Totey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


@interface UserLocation : NSObject <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, strong) CLLocationManager *locationManager;

+ (instancetype) sharedInstance;

extern NSString *const kUserLocationUpdated;
@end
