//
//  SearchResultObjectAnnotation.h
//  BlocSpot
//
//  Created by Sameer Totey on 12/5/14.
//  Copyright (c) 2014 Sameer Totey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "PointOfInterest+Annotation.h"

@interface BlocSpotModel : NSObject <MKAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property(nonatomic, readonly, copy) NSString *title;
@property (nonatomic, readonly, copy) NSString *subtitle;
@property (nonatomic, retain) NSURL *url;
@property (nonatomic, assign) CLLocationDistance currentDistanceFromUser;
@property (nonatomic, strong) MKMapItem *mapItem;
@property (nonatomic, strong) PointOfInterest *pointOfInterest;

- (instancetype)initWithMapItem:(MKMapItem *)mapItem;
- (instancetype)initWithPointOfInterest:(PointOfInterest *)pointOfInterest;

extern NSString *const kRemovedAnnotation;
extern NSString *const kAddRegionMonitoringForAnnotation;
extern NSString *const kUpdatedBlocSpotModel;

@end
