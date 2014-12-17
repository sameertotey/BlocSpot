//
//  LocationCategory.h
//  BlocSpot
//
//  Created by Sameer Totey on 12/12/14.
//  Copyright (c) 2014 Sameer Totey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PointOfInterest;

@interface LocationCategory : NSManagedObject

@property (nonatomic, retain) NSString * color;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *pointsOfInterest;
@end

@interface LocationCategory (CoreDataGeneratedAccessors)

- (void)addPointsOfInterestObject:(PointOfInterest *)value;
- (void)removePointsOfInterestObject:(PointOfInterest *)value;
- (void)addPointsOfInterest:(NSSet *)values;
- (void)removePointsOfInterest:(NSSet *)values;

@end
