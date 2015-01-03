//
//  CalloutViewController.m
//  BlocSpot
//
//  Created by Sameer Totey on 12/19/14.
//  Copyright (c) 2014 Sameer Totey. All rights reserved.
//

#import "CalloutViewController.h"
#import "LocationCategory+Create.h"
#import "ModalTransitionAnimator.h"
#import "CategoryListTableViewController.h"

static NSString * const kListLocationCategory = @"listLocationCategoryFromMap";
static NSString * const kSegueAddCategoryDismiss   = @"addCategoryDismiss";


@implementation CalloutViewController

- (void)viewDidLoad {
    // To avoid touch events for annotation under the callout
    self.view.opaque = YES;
}


- (IBAction)visitedButtonTouched:(id)sender {
    if (self.annotation.pointOfInterest) {
        NSManagedObjectContext *context = [self.annotation.pointOfInterest managedObjectContext];
        [self.visitedButton setImage:[UIImage imageNamed:@"heart-full"] forState:UIControlStateNormal];
        [self.annotation.pointOfInterest setValue:[NSNumber numberWithBool:YES] forKey:@"visited"];
        NSError *error;
        if (![context save:&error]) {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }

    // We will also setup the region monitoring for this POI
    [self setupRegionMonitoring];
    
}

- (void)setupRegionMonitoring {
    [[NSNotificationCenter defaultCenter] postNotificationName:kAddRegionMonitoringForAnnotation object:self.annotation];
}

- (IBAction)categoryTouched:(UIBarButtonItem *)sender {
    [self performSegueWithIdentifier:kListLocationCategory sender:self.annotation.pointOfInterest.locationCategory.name];
}

- (IBAction)deleteTouched:(UIBarButtonItem *)sender {
    if (self.annotation.pointOfInterest) {
        NSManagedObjectContext *context = [self.annotation.pointOfInterest managedObjectContext];
        [context deleteObject:self.annotation.pointOfInterest];
        NSError *error;
        if (![context save:&error]) {
            /*
             Replace this implementation with code to handle the error appropriately.
         
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kRemovedAnnotation object:self.annotation];
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
    
        UIAlertController* actionSheet = [UIAlertController alertControllerWithTitle:@"Select a App to share"
                                                                       message:@"Please select the appropriate app to share this POI."
                                                                preferredStyle:UIAlertControllerStyleActionSheet];
    
        UIAlertAction* addAction = [UIAlertAction actionWithTitle:@"Message" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {
                                                                  if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"sms:"]]) {
                                                                      [[UIApplication sharedApplication] openURL: [NSURL URLWithString:@"sms:"]];
                                                                  }
                                                              }];
        [actionSheet addAction:addAction];
    
    
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        }];
    
        [actionSheet addAction:cancelAction];
    
        [self presentViewController:actionSheet animated:YES completion:nil];
    
}

- (void) setAnnotation:(BlocSpotModel *)annotation {
    _annotation = annotation;
    if (self.annotation.pointOfInterest) {
        self.titleLabel.text = self.annotation.pointOfInterest.name;
        self.noteTextView.text = self.annotation.pointOfInterest.note;
        if (self.annotation.pointOfInterest.visited) {
            [self.visitedButton setImage:[UIImage imageNamed:@"heart-full"] forState:UIControlStateNormal];
        } else {
            [self.visitedButton setImage:[UIImage imageNamed:@"heart-empty"] forState:UIControlStateNormal];
        }
        self.locationCategoryBarButtonItem.title = self.annotation.pointOfInterest.locationCategory.name;
        self.view.backgroundColor = [UIColor fromString:self.annotation.pointOfInterest.locationCategory.color];
    } else {
        self.titleLabel.text = self.annotation.title;
        self.noteTextView.text = self.annotation.subtitle;
        self.callOutToolbar.items = @[self.deleteBarButtonItem];
        [self.visitedButton setImage:[UIImage imageNamed:@"not-chosen"] forState:UIControlStateNormal];
    }
}

- (CGSize)preferredContentSize {
    return CGSizeMake(200, 125);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:kListLocationCategory]) {
        if ([segue.destinationViewController isKindOfClass:[UINavigationController class]] &&
            [((UINavigationController *)segue.destinationViewController).topViewController isKindOfClass:[CategoryListTableViewController class]]) {
            CategoryListTableViewController *cltvc = (CategoryListTableViewController *)[(UINavigationController *)segue.destinationViewController topViewController];
            if ([sender isKindOfClass:[UIBarButtonItem class]]) {
                cltvc.selectedCategory = [(UIBarButtonItem *)sender title];
            }
            cltvc.managedObjectContext = [self.annotation.pointOfInterest managedObjectContext];
            UIViewController *toVC = segue.destinationViewController;
            toVC.modalPresentationStyle = UIModalPresentationCustom;
            toVC.transitioningDelegate = self;
        }
    }
    
    [super prepareForSegue:segue sender:sender];
}

#pragma mark - UIViewControllerTransitioningDelegate

/*
 Called when presenting a view controller that has a transitioningDelegate
 */
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source
{
    id<UIViewControllerAnimatedTransitioning> animationController;
    
    // List Category
    if ([presented isKindOfClass:[UINavigationController class]] &&
        [((UINavigationController *)presented).topViewController isKindOfClass:[CategoryListTableViewController class]]) {
        ModalTransitionAnimator *animator = [[ModalTransitionAnimator alloc] init];
        animator.appearing = YES;
        animator.duration = 1.35;
        animationController = animator;
    }
    
    return animationController;
}

/*
 Called when dismissing a view controller that has a transitioningDelegate
 */
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    id<UIViewControllerAnimatedTransitioning> animationController;
    
    // Add Category
    if ([dismissed isKindOfClass:[UINavigationController class]] &&
        [((UINavigationController *)dismissed).topViewController isKindOfClass:[CategoryListTableViewController class]]) {
        
        ModalTransitionAnimator  *animator = [[ModalTransitionAnimator alloc] init];
        animator.appearing = NO;
        animator.duration = 0.35;
        animationController = animator;
    }
    
    return animationController;
}

#pragma mark - Storyboard unwinding

/*
 Normally an unwind segue will pop/dismiss the view controller but this doesn't happen
 for custom modal transitions so we have to manually call dismiss.
 */
- (IBAction)unwindFromListCategoryViewControllerPresenter:(UIStoryboardSegue *)sender
{
    if ([sender.identifier isEqualToString:kSegueAddCategoryDismiss]) {
        if ([sender.sourceViewController isKindOfClass:[CategoryListTableViewController class]]) {
            CategoryListTableViewController *source = (CategoryListTableViewController *)sender.sourceViewController;
            if (source.selectedCategory) {
                self.locationCategoryBarButtonItem.title = source.selectedCategory;
            }
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
