//
//  AllPointsOfInterest.m
//  BlocSpot
//
//  Created by Sameer Totey on 12/31/14.
//  Copyright (c) 2014 Sameer Totey. All rights reserved.
//

#import "AllPointsOfInterest.h"

@implementation AllPointsOfInterest
- (instancetype)initWithContext:(NSManagedObjectContext *)managedObjectContext {
    self = [super init];
    if (self) {
        // Create and configure a fetch request with the Book entity.
        self.managedObjectContext = managedObjectContext;
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"PointOfInterest" inManagedObjectContext:self.managedObjectContext];
        [fetchRequest setEntity:entity];
        
        // initialize the user location
        NSError *error;
        self.allObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
        if (!self.allObjects ) {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
    return self;
}

+ (instancetype) sharedInstanceWithContext:(NSManagedObjectContext *)managedObjectContext {
    static dispatch_once_t once;
    static id sharedInstance;
    
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] initWithContext:managedObjectContext];
    });
    return sharedInstance;
}

@end
