//
//  SearchedObjectDetailViewController.m
//  BlocSpot
//
//  Created by Sameer Totey on 12/6/14.
//  Copyright (c) 2014 Sameer Totey. All rights reserved.
//

#import "SearchedObjectDetailViewController.h"
#import "PointOfInterest.h"
#import "LocationCategory+Create.h"
#import "AddNewCategoryViewController.h"
#import "ModalTransitionAnimator.h"

// Segue Id
static NSString * const kAddLocationCategory       = @"addLocationCategory";
static NSString * const kSegueAddCategoryDismiss   = @"addCategoryDismiss";

@interface SearchedObjectDetailViewController () <UIViewControllerTransitioningDelegate>
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;

@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UITextField *urlTextField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *descriptionTextViewHeightConstraint;

@property (strong, nonatomic)UIBarButtonItem *doneButton;
@property (strong, nonatomic)UIBarButtonItem *cancelButton;
@property (strong, nonatomic)UIBarButtonItem *saveButton;

@property (strong, nonatomic)PointOfInterest *managedDetailObject;
@property (weak, nonatomic) IBOutlet UIButton *selectCategoryButton;
@end

@implementation SearchedObjectDetailViewController

- (void)viewDidLoad {
    self.titleTextField.text = self.detailObject.title;
    self.descriptionTextView.text = self.detailObject.subtitle;
    self.urlTextField.text = [self.detailObject.url absoluteString];
    
    self.doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneEditing)];
    self.cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelEditing)];
    self.saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(savePressed)];
    
    self.navigationItem.rightBarButtonItem = self.saveButton;
    
    self.managedDetailObject = self.detailObject.pointOfInterest;
    
    if (self.managedDetailObject == nil) {
        self.managedDetailObject = [NSEntityDescription insertNewObjectForEntityForName:@"PointOfInterest" inManagedObjectContext:self.managedObjectContext];
        // set the latitude and longitude here
        [self.managedDetailObject setValue:[NSNumber numberWithDouble:self.detailObject.coordinate.latitude] forKey:@"latitude"];
        [self.managedDetailObject setValue:[NSNumber numberWithDouble:self.detailObject.coordinate.longitude] forKey:@"longitude"];
        [self.managedDetailObject setValue:self.detailObject.title forKey:@"name"];
        [self.managedDetailObject setValue:[LocationCategory locationCategoryWithName:@"Default" inManagedObjectContext:self.managedObjectContext] forKey:@"locationCategory"];
    }
}

- (void)savePressed {
    NSLog(@"Save Pressed");
    [self saveManagedObject];
    [self.navigationController popViewControllerAnimated:YES];

}

- (void)saveManagedObject {
    // TODO: save the managed object using core data here
    if ([self.managedObjectContext hasChanges]) {
        NSError *error;
        NSLog(@"Going to save the managed object here.....");
        if (![self.managedObjectContext save:&error]){
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }

    }
}


#pragma mark - TextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self resignFirstResponder];
    
    if (textField.tag == 1) {
        NSLog(@"This is the first field");
        [self.managedDetailObject setValue:textField.text forKey:@"name"];
        NSLog(@"The name %@ saved", textField.text);
    } else {
        NSLog(@"this is the second field");
    }
    // now save the managed object

    return YES;
}

#pragma mark - TextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    // we do not want to erase the existing contents here, but show done and cancel button to end editing
//    self.descriptionTextView.text = @"";
    self.descriptionTextView.backgroundColor = [UIColor grayColor];
    self.navigationItem.leftBarButtonItem = self.cancelButton;
    self.navigationItem.rightBarButtonItem = self.doneButton;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = self.saveButton;
}

- (void)textViewDidChange:(UITextView *)textView {
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
}


- (void)doneEditing {
    [self.descriptionTextView resignFirstResponder];
    if (self.descriptionTextView.text.length > 0) {
        // going for the saving of the contents

        [self.managedDetailObject setValue:self.descriptionTextView.text forKey:@"subtitle"];
    }
}

- (void)cancelEditing {
    [self.descriptionTextView resignFirstResponder];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    // we will adjust the height of the desciption view to fit its text
    CGSize maxSize = CGSizeMake(CGRectGetWidth(self.view.bounds) - 60, CGFLOAT_MAX);
    
    CGSize descriptionTextViewSize = [self.descriptionTextView sizeThatFits:maxSize];
    self.descriptionTextViewHeightConstraint.constant = descriptionTextViewSize.height;
    [self.descriptionTextView scrollRangeToVisible:NSRangeFromString(self.descriptionTextView.text)];
}

- (IBAction)selectCategoryTouched:(id)sender {
    UIAlertController* actionSheet = [UIAlertController alertControllerWithTitle:@"Select a Category"
                                                                   message:@"Please select the appropriate category for this POI."
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* addAction = [UIAlertAction actionWithTitle:@"Add new Category" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              NSLog(@"Add new categoy selected");
                                                              [self performSegueWithIdentifier:kAddLocationCategory sender:self];
                                                          }];
       [actionSheet addAction:addAction];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"LocationCategory"];
    
    NSError *error;
    NSArray *matches = [self.managedObjectContext executeFetchRequest:request error:&error];
    
    if ([matches count]) {
        for (LocationCategory *locationCategory in matches) {
            UIAlertAction *categoryAction = [UIAlertAction actionWithTitle:locationCategory.name style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                NSLog(@" Action %@ selected", locationCategory.name);
                self.managedDetailObject.locationCategory = locationCategory;
                action.enabled = NO;
            }];
            [actionSheet addAction:categoryAction];
        }
    }
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        NSLog(@"Cancel Selected");
    }];

    [actionSheet addAction:cancelAction];

    [self presentViewController:actionSheet animated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:kAddLocationCategory]) {
        if ([segue.destinationViewController isKindOfClass:[UINavigationController class]] &&
            [((UINavigationController *)segue.destinationViewController).topViewController isKindOfClass:[AddNewCategoryViewController class]]) {
            AddNewCategoryViewController *ancvc = (AddNewCategoryViewController *)[(UINavigationController *)segue.destinationViewController topViewController];
            ancvc.managedObjectContext = self.managedObjectContext;
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
    
    
    // Add Category
    if ([presented isKindOfClass:[UINavigationController class]] &&
        [((UINavigationController *)presented).topViewController isKindOfClass:[AddNewCategoryViewController class]]) {
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
        [((UINavigationController *)dismissed).topViewController isKindOfClass:[AddNewCategoryViewController class]]) {

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
- (IBAction)unwindToAddCategoryViewControllerPresenter:(UIStoryboardSegue *)sender
{
    if ([sender.identifier isEqualToString:kSegueAddCategoryDismiss]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


@end
