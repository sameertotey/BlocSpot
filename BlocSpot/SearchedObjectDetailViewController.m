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
#import "CategoryListTableViewController.h"

// Segue Id
static NSString * const kAddLocationCategory       = @"addLocationCategory";
static NSString * const kListLocationCategory       = @"listLocationCategory";
static NSString * const kSegueAddCategoryDismiss   = @"addCategoryDismiss";

@interface SearchedObjectDetailViewController () <UIViewControllerTransitioningDelegate>
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;

@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *descriptionTextViewHeightConstraint;

@property (strong, nonatomic)UIBarButtonItem *doneButton;
@property (strong, nonatomic)UIBarButtonItem *cancelButton;
@property (strong, nonatomic)UIBarButtonItem *saveButton;
@property (strong, nonatomic)UIBarButtonItem *deleteButton;

@property (strong, nonatomic)PointOfInterest *managedDetailObject;
@property (weak, nonatomic) IBOutlet UIButton *selectCategoryButton;
@end

@implementation SearchedObjectDetailViewController

- (void)viewDidLoad {
    self.titleTextField.text = self.detailObject.title;
    self.descriptionTextView.text = self.detailObject.subtitle;
    NSString *category;
    self.managedDetailObject = self.detailObject.pointOfInterest;

    if (self.managedDetailObject) {
        category = self.detailObject.pointOfInterest.locationCategory.name;
    }
    if (!category) {
        category = @"default";
    }
    [self.selectCategoryButton setTitle:category forState:UIControlStateNormal];
    
    self.doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneEditing)];
    self.cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelEditing)];
    self.saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(savePressed)];
    self.deleteButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(deletePressed)];
    
    [self setNavigationButtons];
    self.title = @"POI Detail";
    
    // Background gradient
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.view.bounds;
    gradientLayer.colors = @[(id)[UIColor whiteColor].CGColor,
                             (id)[UIColor colorWithRed:0.561 green:0.839 blue:0.922 alpha:1].CGColor];
    gradientLayer.cornerRadius = 4;
    gradientLayer.masksToBounds = YES;
    [self.view.layer insertSublayer:gradientLayer atIndex:0];

}

- (void)setNavigationButtons {
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItems = @[self.deleteButton, self.saveButton];
    
    if (self.managedDetailObject == nil) {
        self.navigationItem.rightBarButtonItems = @[self.saveButton];
    }
}

- (void)savePressed {
    NSLog(@"Save Pressed");
    if (self.managedDetailObject == nil) {
        self.managedDetailObject = [NSEntityDescription insertNewObjectForEntityForName:@"PointOfInterest" inManagedObjectContext:self.managedObjectContext];
        // set the latitude and longitude here
        [self.managedDetailObject setValue:[NSNumber numberWithDouble:self.detailObject.coordinate.latitude] forKey:@"latitude"];
        [self.managedDetailObject setValue:[NSNumber numberWithDouble:self.detailObject.coordinate.longitude] forKey:@"longitude"];
    }
    [self.managedDetailObject setValue:self.titleTextField.text forKey:@"name"];
    [self.managedDetailObject setValue:self.descriptionTextView.text forKey:@"note"];
    [self.managedDetailObject setValue:[LocationCategory locationCategoryWithName:[self.selectCategoryButton titleForState:UIControlStateNormal] inManagedObjectContext:self.managedObjectContext] forKey:@"locationCategory"];
    [self saveManagedObject];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)deletePressed {
    NSLog(@"Delete Pressed");
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)saveManagedObject {
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
    
    return YES;
}

#pragma mark - TextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    // we do not want to erase the existing contents here, but show done and cancel button to end editing
    self.navigationItem.rightBarButtonItems = @[self.doneButton];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    [self setNavigationButtons];
}

- (void)textViewDidChange:(UITextView *)textView {
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
}

- (void)doneEditing {
    [self.descriptionTextView resignFirstResponder];
}

- (void)cancelEditing {
    [self.descriptionTextView resignFirstResponder];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    // we will adjust the height of the desciption view to fit its text
    CGSize maxSize = CGSizeMake(CGRectGetWidth(self.view.bounds) - 80, CGFLOAT_MAX);
    
    CGSize descriptionTextViewSize = [self.descriptionTextView sizeThatFits:maxSize];
    self.descriptionTextViewHeightConstraint.constant = descriptionTextViewSize.height;
    [self.descriptionTextView scrollRangeToVisible:NSRangeFromString(self.descriptionTextView.text)];
}

- (IBAction)selectCategoryTouched:(id)sender {
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:kListLocationCategory]) {
        if ([segue.destinationViewController isKindOfClass:[UINavigationController class]] &&
            [((UINavigationController *)segue.destinationViewController).topViewController isKindOfClass:[CategoryListTableViewController class]]) {
            CategoryListTableViewController *cltvc = (CategoryListTableViewController *)[(UINavigationController *)segue.destinationViewController topViewController];
            if ([sender isKindOfClass:[UIButton class]]) {
                cltvc.selectedCategory = [(UIButton *)sender titleForState:UIControlStateNormal];
            }
            cltvc.managedObjectContext = self.managedObjectContext;
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
                [self.selectCategoryButton setTitle:source.selectedCategory forState:UIControlStateNormal];
            }
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
