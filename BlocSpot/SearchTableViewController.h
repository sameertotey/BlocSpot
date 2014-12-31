//
//  SearchTableViewController.h
//  BlocSpot
//
//  Created by Sameer Totey on 12/29/14.
//  Copyright (c) 2014 Sameer Totey. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "BlocSpotModel.h"


@interface SearchTableViewController : UITableViewController <UISearchBarDelegate, NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, strong) NSArray *places;  //of SearchResultObjectAnnotation

@end
