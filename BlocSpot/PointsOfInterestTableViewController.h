//
//  PointsOfInterestTableViewController.h
//  BlocSpot
//
//  Created by Sameer Totey on 12/4/14.
//  Copyright (c) 2014 Sameer Totey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BlocSpotModel.h"
#import "CoreDataTableViewController.h"


@interface PointsOfInterestTableViewController : CoreDataTableViewController <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;


@end
