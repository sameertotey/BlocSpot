//
//  PointOfInterest.h
//  BlocSpot
//
//  Created by Sameer Totey on 12/22/14.
//  Copyright (c) 2014 Sameer Totey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class LocationCategory;

@interface PointOfInterest : NSManagedObject

@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * note;
@property (nonatomic, retain) NSNumber * visited;
@property (nonatomic, retain) LocationCategory *locationCategory;

@end
