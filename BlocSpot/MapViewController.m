//
//  MapViewController.m
//  BlocSpot
//
//  Created by Sameer Totey on 12/4/14.
//  Copyright (c) 2014 Sameer Totey. All rights reserved.
//

#import "MapViewController.h"
#import "PointOfInterest+Annotation.h"
#import "BlocSpotModel.h"
#import "SearchedObjectDetailViewController.h"
#import "BlocAnnotationView.h"


@interface MapViewController ()
@property (nonatomic, weak) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) BlocSpotModel *annotation;
@end

@implementation MapViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    
    // adjust the map to zoom/center to the annotations we want to show
//    [self.mapView setRegion:self.boundingRegion];
    
    if (self.blocSpotObjects.count == 1)
    {
        BlocSpotModel *blocSpotObject = [self.blocSpotObjects objectAtIndex:0];
        
        self.title = blocSpotObject.title;
        
        // add the single annotation to our map
        [self.mapView addAnnotation:blocSpotObject];
        
        // we have only one annotation, select it's callout
        [self.mapView selectAnnotation:[self.mapView.annotations objectAtIndex:0] animated:YES];
        
        // center the region around this map item's coordinate
        self.mapView.centerCoordinate = blocSpotObject.coordinate;
    }
    else
    {
        self.title = @"All Places";
        
        // add all the found annotations to the map
        for (BlocSpotModel *annotation in self.blocSpotObjects)
        {
            [self.mapView addAnnotation:annotation];
        }
    }
    [self.mapView showAnnotations:self.blocSpotObjects animated:YES];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteAnnotation:) name:kRemovedAnnotation object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(displayOverlay:) name:kDisplayOverlay object:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.mapView removeAnnotations:self.mapView.annotations];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)deleteAnnotation:(NSNotification *)notification {
    [self.mapView removeAnnotation:notification.object];
}

- (void)displayOverlay:(NSNotification *)notification {
    if ([notification.object isKindOfClass:[MKRoute class]]) {
        MKRoute *route = notification.object;
        // Create a region centered on the starting point with a span equal to the route distance
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(route.polyline.coordinate, route.distance, route.distance);
        [self.mapView setRegion:region];
        
        [self.mapView addOverlay:route.polyline level:MKOverlayLevelAboveRoads];
    }
  }

#pragma mark - MKMapViewDelegate

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        MKPolylineRenderer *overlayRenderer = [[MKPolylineRenderer alloc] initWithPolyline:overlay];
        overlayRenderer.strokeColor = [UIColor blueColor];
        return overlayRenderer;
    }
    return nil;
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    // If the annotation is the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    MKAnnotationView *annotationView = nil;
    if ([annotation isKindOfClass:[BlocSpotModel class]])
    {
        annotationView = (BlocAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:@"Heart"];
        if (annotationView == nil)
        {
            annotationView = [[BlocAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Heart"];
//            annotationView.canShowCallout = YES;
//            annotationView.animatesDrop = YES;
            annotationView.canShowCallout = NO;
            
            // assign the annotation to the annotation view
            annotationView.annotation = annotation;
        }
    }
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView
 annotationView:(MKAnnotationView *)view
calloutAccessoryControlTapped:(UIControl *)control {
    
    [self performSegueWithIdentifier:@"Show Searched Object Detail" sender:view.annotation];
    
}

/*
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    POICalloutView *calloutView = [[POICalloutView alloc] initWithFrame:CGRectMake(0.0, 0.0, 280.0, 87.0)];
    
    calloutView.annotation = view.annotation;
    
    calloutView.center = CGPointMake(CGRectGetWidth(view.bounds) / 2.0, 0.0);
    [view addSubview:calloutView];
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    for (UIView *subview in view.subviews) {
        if (![subview isKindOfClass:[POICalloutView class]]) {
            continue;
        }
        
        [subview removeFromSuperview];
    }
}
*/

#pragma mark - Segue 

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([sender isKindOfClass:[BlocSpotModel class]]) {
        if ([segue.destinationViewController isKindOfClass:[SearchedObjectDetailViewController class]]) {
            // setup the detail object as well as pass the database context for saving changes to the object
            SearchedObjectDetailViewController *sodvc = (SearchedObjectDetailViewController *)segue.destinationViewController;
            if ([sender isKindOfClass:[BlocSpotModel class]]) {
                sodvc.detailObject = sender;
            }
            sodvc.managedObjectContext  = self.managedObjectContext;
        }
    }
}

@end
