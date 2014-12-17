//
//  LocationCategory+Create.m
//  BlocSpot
//
//  Created by Sameer Totey on 12/13/14.
//  Copyright (c) 2014 Sameer Totey. All rights reserved.
//

#import "LocationCategory+Create.h"

@implementation LocationCategory (Create)

+ (LocationCategory *)locationCategoryWithName:(NSString *)name inManagedObjectContext:(NSManagedObjectContext *)context{
    LocationCategory *locationCategory = nil;
    
    if ([name length]) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"LocationCategory"];
        request.predicate = [NSPredicate predicateWithFormat:@"name = %@", name];
        
        NSError *error;
        NSArray *matches = [context executeFetchRequest:request error:&error];
        
        if (!matches || ([matches count] > 1)) {
            // handle error
            NSLog(@"error with the location category %@", name);
        } else if (![matches count]) {
            locationCategory = [NSEntityDescription insertNewObjectForEntityForName:@"LocationCategory"
                                                         inManagedObjectContext:context];
            locationCategory.name = name;
            locationCategory.color = @"UIColorDarkGray";
        } else {
            locationCategory = [matches lastObject];
        }
    }

    return locationCategory;
}

@end
