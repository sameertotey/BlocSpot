//
//  MapViewController.m
//  BlocSpot
//
//  Created by Sameer Totey on 12/4/14.
//  Copyright (c) 2014 Sameer Totey. All rights reserved.
//

#import "MapViewController.h"
#import "PointOfInterest+Annotation.h"
#import "SearchResultObjectAnnotation.h"
#import "SearchedObjectDetailViewController.h"
#import "BlocAnnotationView.h"
#import "POICalloutView.h"


@interface MapViewController ()
@property (nonatomic, weak) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) SearchResultObjectAnnotation *annotation;
@end

@implementation MapViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    
    // adjust the map to zoom/center to the annotations we want to show
    [self.mapView setRegion:self.boundingRegion];
    
    if (self.searchResultObjectAnnotations.count == 1)
    {
        SearchResultObjectAnnotation *searchResultObjectAnnotation = [self.searchResultObjectAnnotations objectAtIndex:0];
        
        self.title = searchResultObjectAnnotation.mapItem.name;
        
        // add the single annotation to our map
//        SearchResultObjectAnnotation *annotation = [[SearchResultObjectAnnotation alloc] initWithMapItem:mapItem];
              [self.mapView addAnnotation:searchResultObjectAnnotation];
        
        // we have only one annotation, select it's callout
        [self.mapView selectAnnotation:[self.mapView.annotations objectAtIndex:0] animated:YES];
        
        // center the region around this map item's coordinate
        self.mapView.centerCoordinate = searchResultObjectAnnotation.mapItem.placemark.coordinate;
    }
    else
    {
        self.title = @"All Places";
        
        // add all the found annotations to the map
        for (SearchResultObjectAnnotation *annotation in self.searchResultObjectAnnotations)
        {
            [self.mapView addAnnotation:annotation];
        }
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.mapView removeAnnotations:self.mapView.annotations];
}


#pragma mark - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    // If the annotation is the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    MKAnnotationView *annotationView = nil;
    if ([annotation isKindOfClass:[SearchResultObjectAnnotation class]])
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
            
            UIButton *rightCallout = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            annotationView.rightCalloutAccessoryView = rightCallout;
            
            UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
            leftLabel.text = @"left hand accessory";
            annotationView.leftCalloutAccessoryView = leftLabel;
        }
    }
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView
 annotationView:(MKAnnotationView *)view
calloutAccessoryControlTapped:(UIControl *)control {
    NSLog(@"mapview accessory tapped");
    
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
    if ([sender isKindOfClass:[SearchResultObjectAnnotation class]]) {
        if ([segue.destinationViewController isKindOfClass:[SearchedObjectDetailViewController class]]) {
            // setup the detail object as well as pass the database context for saving changes to the object
            SearchedObjectDetailViewController *sodvc = (SearchedObjectDetailViewController *)segue.destinationViewController;
            if ([sender isKindOfClass:[SearchResultObjectAnnotation class]]) {
                sodvc.detailObject = sender;
            }
            sodvc.managedObjectContext  = self.managedObjectContext;
        }
    }
    NSLog(@"inside prepare for segue");
}

@end
