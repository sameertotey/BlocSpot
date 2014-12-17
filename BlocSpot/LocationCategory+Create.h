//
//  LocationCategory+Create.h
//  BlocSpot
//
//  Created by Sameer Totey on 12/13/14.
//  Copyright (c) 2014 Sameer Totey. All rights reserved.
//

#import "LocationCategory.h"

@interface LocationCategory (Create)

+ (LocationCategory *)locationCategoryWithName:(NSString *)name inManagedObjectContext:(NSManagedObjectContext *)context;

@end
