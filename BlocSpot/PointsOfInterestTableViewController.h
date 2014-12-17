//
//  PointsOfInterestTableViewController.h
//  BlocSpot
//
//  Created by Sameer Totey on 12/4/14.
//  Copyright (c) 2014 Sameer Totey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "SearchResultObjectAnnotation.h"


@interface PointsOfInterestTableViewController : UITableViewController <UISearchBarDelegate, CLLocationManagerDelegate, NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, strong) NSArray *places;  //of SearchResultObjectAnnotation


@end
