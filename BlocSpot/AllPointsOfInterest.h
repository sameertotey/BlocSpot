//
//  AllPointsOfInterest.h
//  BlocSpot
//
//  Created by Sameer Totey on 12/31/14.
//  Copyright (c) 2014 Sameer Totey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface AllPointsOfInterest : NSObject

+ (instancetype)sharedInstanceWithContext:(NSManagedObjectContext *)managedObjectContext;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSArray *allObjects;

@end
