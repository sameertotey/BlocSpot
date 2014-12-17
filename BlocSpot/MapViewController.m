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
    MKPinAnnotationView *annotationView = nil;
    if ([annotation isKindOfClass:[SearchResultObjectAnnotation class]])
    {
        annotationView = (MKPinAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:@"Pin"];
        if (annotationView == nil)
        {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Pin"];
            annotationView.canShowCallout = YES;
            annotationView.animatesDrop = YES;
                  
            UIButton *rightCallout = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            annotationView.rightCalloutAccessoryView = rightCallout;
            
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
