//
//  CalloutViewController.m
//  BlocSpot
//
//  Created by Sameer Totey on 12/19/14.
//  Copyright (c) 2014 Sameer Totey. All rights reserved.
//

#import "CalloutViewController.h"
#import "LocationCategory+Create.h"

@implementation CalloutViewController

- (void)viewDidLoad {
    // To avoid touch events for annotation under the callout
    self.view.opaque = YES;
}


- (IBAction)visitedButtonTouched:(id)sender {
    NSLog(@"Visited button touched");
}

- (IBAction)categoryTouched:(UIBarButtonItem *)sender {
    
}

- (IBAction)deleteTouched:(UIBarButtonItem *)sender {
    
}

- (IBAction)navigateTouched:(id)sender {
    MKMapItem *from = [MKMapItem mapItemForCurrentLocation];

    CLLocation* fromLocation = from.placemark.location;
    
    // Create a region centered on the starting point with a 10km span
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(fromLocation.coordinate, 10000, 10000);
    
    MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:self.annotation.coordinate addressDictionary:@{}];
    self.annotation.mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
    
    // Open the item in Maps, specifying the map region to display as well as driving directions to this point from current point.
    [MKMapItem openMapsWithItems:[NSArray arrayWithObjects:from, self.annotation.mapItem, nil]
                   launchOptions:[NSDictionary dictionaryWithObjectsAndKeys:
                                  [NSValue valueWithMKCoordinate:region.center], MKLaunchOptionsMapCenterKey,
                                  [NSValue valueWithMKCoordinateSpan:region.span], MKLaunchOptionsMapSpanKey,
                                  MKLaunchOptionsDirectionsModeDriving, MKLaunchOptionsDirectionsModeKey,
                                  nil]];
    
}

- (IBAction)shareTouched:(UIBarButtonItem *)sender {
    
}

- (void) setAnnotation:(SearchResultObjectAnnotation *)annotation {
    _annotation = annotation;
    if (self.annotation.pointOfInterest) {
        self.titleLabel.text = self.annotation.pointOfInterest.name;
        self.noteTextView.text = self.annotation.pointOfInterest.note;
        self.locationCategoryBarButtonItem.title = self.annotation.pointOfInterest.locationCategory.name;
        self.view.backgroundColor = [UIColor fromString:self.annotation.pointOfInterest.locationCategory.color];
    } else {
        self.titleLabel.text = self.annotation.title;
        self.noteTextView.text = self.annotation.subtitle;
        self.callOutToolbar.items = nil;
    }
}
- (CGSize)preferredContentSize {
    return CGSizeMake(200, 125);
}
@end
