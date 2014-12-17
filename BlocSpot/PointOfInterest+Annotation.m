//
//  PointOfInterest+Annotation.m
//  BlocSpot
//
//  Created by Sameer Totey on 12/5/14.
//  Copyright (c) 2014 Sameer Totey. All rights reserved.
//

#import "PointOfInterest+Annotation.h"

@implementation PointOfInterest (Annotation)

- (CLLocationCoordinate2D)coordinate
{
    CLLocationCoordinate2D coordinate;
    coordinate.longitude = [self.longitude doubleValue];
    coordinate.latitude = [self.latitude doubleValue];
    
    return coordinate;
}

@end
