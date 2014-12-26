//
//  AddNewCategoryViewController.m
//  BlocSpot
//
//  Created by Sameer Totey on 12/15/14.
//  Copyright (c) 2014 Sameer Totey. All rights reserved.
//

#import "AddNewCategoryViewController.h"

static NSString * const kSegueAddCategoryDismiss   = @"addCategoryDismiss";

@interface AddNewCategoryViewController ()

@property (strong, nonatomic)UIBarButtonItem *doneButton;
@property (strong, nonatomic)UIBarButtonItem *cancelButton;
@property (strong, nonatomic)UIBarButtonItem *saveButton;
@property (weak, nonatomic) IBOutlet UITextField *categoryNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *colorNameTextField;

@end

@implementation AddNewCategoryViewController

- (void)viewDidLoad {
    self.cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelEditing)];
    self.saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(savePressed)];
    
    self.navigationItem.rightBarButtonItem = self.saveButton;
    self.title = @"Add Category";

    if (self.locationCategory) {
        self.categoryNameTextField.text = [self.locationCategory valueForKey:@"name"];
        self.colorNameTextField.text = [self.locationCategory valueForKey:@"color"];
        self.title = @"Edit Category";
    }
    // Background gradient
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.view.bounds;
    gradientLayer.colors = @[(id)[UIColor blackColor].CGColor,
                             (id)[UIColor colorWithRed:0.561 green:0.839 blue:0.922 alpha:1].CGColor];
    gradientLayer.cornerRadius = 4;
    gradientLayer.masksToBounds = YES;
    [self.view.layer insertSublayer:gradientLayer atIndex:0];

}

- (void)savePressed {
    NSLog(@"Save Pressed");
    [self saveManagedObject];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)saveManagedObject {
    NSError *error;
    NSLog(@"Going to save the managed object here.....");
    if (!self.locationCategory) {
        // This was an add new location category request
        self.locationCategory = [NSEntityDescription insertNewObjectForEntityForName:@"LocationCategory" inManagedObjectContext:self.managedObjectContext];
    }
    
    [self.locationCategory setValue:self.categoryNameTextField.text forKey:@"name"];
    [self.locationCategory setValue:self.colorNameTextField.text forKey:@"color"];
    if (![self.managedObjectContext save:&error]){
        /*
        Replace this implementation with code to handle the error appropriately.
             
        abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}


- (void)cancelEditing {
    
}

#pragma mark - TextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.saveButton.enabled = NO;
    if ([self.categoryNameTextField.text length] && [self.colorNameTextField.text length]) {
        self.saveButton.enabled = YES;
    }
}

@end
