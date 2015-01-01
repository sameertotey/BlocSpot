//
//  MapViewController.h
//  BlocSpot
//
//  Created by Sameer Totey on 12/4/14.
//  Copyright (c) 2014 Sameer Totey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MapViewController : UIViewController
@property (nonatomic, strong) NSArray *blocSpotObjects;           // of BlocSpotModel
@property (nonatomic, assign) MKCoordinateRegion boundingRegion;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end
