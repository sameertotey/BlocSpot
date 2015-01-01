//
//  MonitoringManager.m
//  BlocSpot
//
//  Created by Sameer Totey on 12/31/14.
//  Copyright (c) 2014 Sameer Totey. All rights reserved.
//

#import "MonitoringManager.h"
#import "AllPointsOfInterest.h"
#import <CoreLocation/CoreLocation.h>
#import "UserLocation.h"
#import "BlocSpotModel.h"

@interface MonitoringManager ()
@property(nonatomic, strong)AllPointsOfInterest *allPointsOfInterest;
@end

@implementation MonitoringManager

- (instancetype)init {
    self = [super init];
    if (self) {
        // pass nil for context because it is only needed the first time to create the singleton object
        // subsequently the existing singleton is returned, the app delegate already created the singelton
        self.allPointsOfInterest = [AllPointsOfInterest sharedInstanceWithContext:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(monitorAnnotationRegion:) name:kAddRegionMonitoringForAnnotation object:nil];
    }
    return self;
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)resetRegionMonitoring {
    // first stop all the monitoring regions
    NSSet *monitoredRegions = [self.userLocation.locationManager monitoredRegions];
    for (CLRegion *region in monitoredRegions) {
        [self.userLocation.locationManager stopMonitoringForRegion:region];
    }
    
    NSArray *allPois = self.allPointsOfInterest.allObjects;
    NSMutableArray *allBlocObjects = [NSMutableArray array];
    for (PointOfInterest *poi in allPois) {
        BlocSpotModel *model = [[BlocSpotModel alloc] initWithPointOfInterest:poi];
        [allBlocObjects addObject:model];
    }
    
    NSArray *sortedBlocObjects = [self sortedObjects:allBlocObjects];
    
    // now choose closest (first) five (maxRegionsToMonitor) objects and start monitoring them
    
    int i = 0;
    int maxRegionsToMonitor = 5;
    
    for (BlocSpotModel *object in sortedBlocObjects) {
        if (i < maxRegionsToMonitor) {
            [self monitorBlocSpot:object];
            i++;
        } else break;
    }
}

- (NSArray *)sortedObjects:(NSArray *)inObjects {
    NSSortDescriptor *sortDesc = [NSSortDescriptor sortDescriptorWithKey:@"currentDistanceFromUser" ascending:YES];
    return [inObjects sortedArrayUsingDescriptors:@[sortDesc]];
}

- (void)monitorBlocSpot:(BlocSpotModel *)object {
     // we will set the radius to 250 meter
    CLCircularRegion *geoRegion = [[CLCircularRegion alloc] initWithCenter:object.coordinate radius:250 identifier:object.title];
    if ([CLLocationManager isMonitoringAvailableForClass:[CLCircularRegion class]]) {
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways) {
            // Create the geographic region to be monitored.
            [self.userLocation.locationManager startMonitoringForRegion:geoRegion];
            NSLog(@"Started monitoring %@", geoRegion);
        }
    }
}

- (void)monitorAnnotationRegion:(NSNotification *)notification {
    BlocSpotModel *annotationObject;
    if ([notification.object isKindOfClass:[BlocSpotModel class]]) {
        annotationObject = notification.object;
    }
    [self monitorBlocSpot:annotationObject];
}

@end
