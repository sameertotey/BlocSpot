//
//  UserLocation.m
//  BlocSpot
//
//  Created by Sameer Totey on 12/30/14.
//  Copyright (c) 2014 Sameer Totey. All rights reserved.
//

#import "UserLocation.h"
#import "BlocSpotModel.h"
#import "MonitoringManager.h"

NSString *const kUserLocationUpdated = @"UserLocationUpdated";

@interface UserLocation ()
@property (nonatomic, strong)MonitoringManager *monitoringManager;
@property (nonatomic, assign)BOOL monitoringSignificantLocationUpdatesOnly;
@end

@implementation UserLocation

- (instancetype)init {
    self = [super init];
    if (self) {
        // initialize the user location
        self.location = [[CLLocation alloc] initWithLatitude:0 longitude:0];
        // start by locating user's current position
        [self startStandardUpdates];
        self.monitoringManager = [[MonitoringManager alloc] init];
        self.monitoringManager.userLocation = self;
    }
    return self;
}

+ (instancetype) sharedInstance {
    static dispatch_once_t once;
    static id sharedInstance;
    
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (CLLocationManager *)locationManager {
    if (!_locationManager) {
        // Create the location manager if this object does not
        // already have one.
        _locationManager = [[CLLocationManager alloc] init];
    }
    return _locationManager;
}

- (void)startStandardUpdates
{
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    
    // Set a movement threshold for new events.
    self.locationManager.distanceFilter = 500; // meters
    
    // Check for iOS 8. Without this guard the code will crash with "unknown selector" on iOS 7.
    if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [self.locationManager requestAlwaysAuthorization];
    }
    
    [self.locationManager startUpdatingLocation];
}

#pragma mark - CLLocationManagerDelegate methods

// Delegate method from the CLLocationManagerDelegate protocol.
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    // If it's a relatively recent event, turn off updates to save power.
    CLLocation* location = [locations lastObject];
    NSDate* eventDate = location.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    if (abs(howRecent) < 15.0) {
        // If the event is recent, save it as userLocation.
        NSLog(@"latitude %+.6f, longitude %+.6f\n",
              location.coordinate.latitude,
              location.coordinate.longitude);
        self.location = location;
        [[NSNotificationCenter defaultCenter] postNotificationName:kUserLocationUpdated object:location];
        [self.monitoringManager resetRegionMonitoring];
        
        if (!self.monitoringSignificantLocationUpdatesOnly) {
            [manager stopUpdatingLocation]; // we only want one update, and now switch to significant location updates
            [manager startMonitoringSignificantLocationChanges];
            self.monitoringSignificantLocationUpdatesOnly = YES;
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    // report any errors returned back from Location Services
    NSLog(@"Location Manager did fail with error %@", error);
}

- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error  {
    NSLog(@"Location manager monitoring failed for region %@ with %@ error", region, error);
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    
    NSLog(@"Entered Region");
    
    if ([[UIApplication sharedApplication] applicationState] != UIApplicationStateActive) {
        UILocalNotification *reminder = [[UILocalNotification alloc] init];
        [reminder setFireDate:[NSDate date]];
        [reminder setTimeZone:[NSTimeZone localTimeZone]];
        [reminder setHasAction:YES];
        [reminder setAlertAction:@"Show"];
        [reminder setSoundName:@"bell.mp3"];
        [reminder setAlertBody:@"Boundary crossed!"];
        [[UIApplication sharedApplication] scheduleLocalNotification:reminder];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            // Show an alert or otherwise notify the user
        });
    }
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    
}

@end
