//
//  SearchResultObjectAnnotation.m
//  BlocSpot
//
//  Created by Sameer Totey on 12/5/14.
//  Copyright (c) 2014 Sameer Totey. All rights reserved.
//

#import "BlocSpotModel.h"
#import "UserLocation.h"

@interface BlocSpotModel ()
@property(nonatomic, readwrite, copy) NSString *title;
@property(nonatomic, readwrite, copy) NSString *subtitle;
@property(nonatomic,strong) UserLocation *userLocation;
@end

@implementation BlocSpotModel

NSString *const kRemovedAnnotation = @"AnnotationRemoved";
NSString *const kAddRegionMonitoringForAnnotation = @"MonitorRegionForThisAnnotation";
NSString *const kUpdatedBlocSpotModel = @"UpdatedBlocSpotModel";


- (instancetype)initWithMapItem:(MKMapItem *)mapItem {
    self = [super init];
    // initialize the item for annotation with properties from MKMapItem
    if (self) {
        self.coordinate = mapItem.placemark.location.coordinate;
        self.title = mapItem.name;
        self.subtitle = mapItem.phoneNumber;
        self.url = mapItem.url;
        self.pointOfInterest = nil;
    }
    return self;
}

- (instancetype)initWithPointOfInterest:(PointOfInterest *)pointOfInterest {
    self = [super init];
    if (self) {
        // initialize the item for annotation with properties from PointOfInterest
        self.mapItem = nil;
        self.pointOfInterest = pointOfInterest;
        self.title = pointOfInterest.name;
        self.subtitle = pointOfInterest.note;
        self.coordinate = CLLocationCoordinate2DMake([pointOfInterest.latitude doubleValue], [pointOfInterest.longitude doubleValue]);
        self.userLocation = [UserLocation sharedInstance];
        [self updateCurrentDistance];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLocationUpdate:) name:kUserLocationUpdated object:nil];
    }
    return self;
}

- (void)userLocationUpdate:(NSNotification *)notification {
    [self updateCurrentDistance];
}

- (void)updateCurrentDistance {
    CLLocation *poiLocation = [[CLLocation alloc] initWithLatitude:[self.pointOfInterest.latitude doubleValue] longitude:[self.pointOfInterest.longitude doubleValue]];
    self.currentDistanceFromUser = [poiLocation distanceFromLocation:self.userLocation.location];
    [[NSNotificationCenter defaultCenter] postNotificationName:kUpdatedBlocSpotModel object:self];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
