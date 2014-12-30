//
//  SearchResultObjectAnnotation.m
//  BlocSpot
//
//  Created by Sameer Totey on 12/5/14.
//  Copyright (c) 2014 Sameer Totey. All rights reserved.
//

#import "SearchResultObjectAnnotation.h"

@interface SearchResultObjectAnnotation ()
@property(nonatomic, readwrite, copy) NSString *title;
@property(nonatomic, readwrite, copy) NSString *subtitle;
@end

@implementation SearchResultObjectAnnotation

NSString *const kRemovedAnnotation = @"AnnotationRemoved";
NSString *const kAddRegionMonitoringForAnnotation = @"MonitorRegionForThisAnnotation";

- (instancetype)initWithMapItem:(MKMapItem *)mapItem {
    // initialize the item for annotation with properties from MKMapItem
    self.coordinate = mapItem.placemark.location.coordinate;
    self.title = mapItem.name;
    self.subtitle = mapItem.phoneNumber;
    self.url = mapItem.url;
    self.pointOfInterest = nil;
    return self;
}

- (instancetype)initWithPointOfInterest:(PointOfInterest *)pointOfInterest {
    // initialize the item for annotation with properties from PointOfInterest
    self.mapItem = nil;
    self.pointOfInterest = pointOfInterest;
    self.title = pointOfInterest.name;
    self.subtitle = pointOfInterest.note;
    self.coordinate = CLLocationCoordinate2DMake([pointOfInterest.latitude doubleValue], [pointOfInterest.longitude doubleValue]);
    return self;
}
@end
