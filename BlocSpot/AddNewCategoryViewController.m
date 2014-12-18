//
//  AddNewCategoryViewController.m
//  BlocSpot
//
//  Created by Sameer Totey on 12/15/14.
//  Copyright (c) 2014 Sameer Totey. All rights reserved.
//

#import "AddNewCategoryViewController.h"
#import "LocationCategory+Create.h"

static NSString * const kSegueAddCategoryDismiss   = @"addCategoryDismiss";

@interface AddNewCategoryViewController ()

@property (weak, nonatomic) IBOutlet UITextField *categoryNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *colorNameTextField;
@property (strong, nonatomic)UIBarButtonItem *doneButton;
@property (strong, nonatomic)UIBarButtonItem *cancelButton;
@property (strong, nonatomic)UIBarButtonItem *saveButton;

@end

@implementation AddNewCategoryViewController

- (void)viewDidLoad {
    self.cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelEditing)];
    self.saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(savePressed)];
    
    self.navigationItem.rightBarButtonItem = self.saveButton;
    self.navigationItem.leftBarButtonItem = self.cancelButton;
}

- (void)savePressed {
    NSLog(@"Save Pressed");
    [self saveManagedObject];
    [self performSegueWithIdentifier:kSegueAddCategoryDismiss sender:self];
}

- (void)saveManagedObject {
    NSError *error;
    NSLog(@"Going to save the managed object here.....");
    LocationCategory *locationCategory = [NSEntityDescription insertNewObjectForEntityForName:@"LocationCategory" inManagedObjectContext:self.managedObjectContext];
    [locationCategory setValue:self.categoryNameTextField.text forKey:@"name"];
    [locationCategory setValue:self.colorNameTextField.text forKey:@"color"];
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
//    [self.navigationController popViewControllerAnimated:YES];
    [self performSegueWithIdentifier:kSegueAddCategoryDismiss sender:self];
}

#pragma mark - TextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    NSLog(@"Should return textfield %@", textField.text);

    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSLog(@"Did end textfield %@", textField.text);
    self.saveButton.enabled = NO;
    if ([self.categoryNameTextField.text length] && [self.colorNameTextField.text length]) {
        self.saveButton.enabled = YES;
    }
     // now save the managed object in the save

}


@end
