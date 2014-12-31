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
@property (weak, nonatomic) IBOutlet UISlider *redSlider;
@property (weak, nonatomic) IBOutlet UISlider *greenSlider;
@property (weak, nonatomic) IBOutlet UISlider *blueSlider;
@property (weak, nonatomic) IBOutlet UISlider *alphaSlider;

@property (strong, nonatomic) UIColor *color;
@property (strong, nonatomic) NSString *colorString;
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
        [self setSlidersWithColorString:self.locationCategory.color];
        self.color = [UIColor fromString:self.locationCategory.color];
        self.title = @"Edit Category";
    }
    // Background gradient
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.view.bounds;
    gradientLayer.colors = @[(id)[UIColor whiteColor].CGColor,
                             (id)[UIColor colorWithRed:0.561 green:0.839 blue:0.922 alpha:1].CGColor];
    gradientLayer.cornerRadius = 4;
    gradientLayer.masksToBounds = YES;
    [self.view.layer insertSublayer:gradientLayer atIndex:0];

}

- (void)setSlidersWithColorString:(NSString *)colorString {
    NSArray *components = [colorString componentsSeparatedByString:@","];
    CGFloat r = [[components objectAtIndex:0] floatValue];
    CGFloat g = [[components objectAtIndex:1] floatValue];
    CGFloat b = [[components objectAtIndex:2] floatValue];
    CGFloat a = [[components objectAtIndex:3] floatValue];
    self.redSlider.value = r;
    self.greenSlider.value = g;
    self.blueSlider.value = b;
    self.alphaSlider.value = a;
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
    [self.locationCategory setValue:self.colorString forKey:@"color"];
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
    if ([self.categoryNameTextField.text length]) {
        self.saveButton.enabled = YES;
    }
}

- (IBAction)sliderValueChanged {
    self.colorString = [NSString stringWithFormat:@"%.3f,%.3f,%.3f,%.3f", self.redSlider.value, self.greenSlider.value, self.blueSlider.value, self.alphaSlider.value];
}

@synthesize colorString = _colorString;

- (void)setColorString:(NSString *)colorString {
    _colorString = colorString;
    self.colorNameTextField.text = colorString;
    self.color = [UIColor fromString:colorString];
}

- (NSString *)colorString {
    if (!_colorString) {
        _colorString = [NSString stringWithFormat:@"%.3f,%.3f,%.3f,%.3f", self.redSlider.value, self.greenSlider.value, self.blueSlider.value, self.alphaSlider.value];
    }
    return _colorString;
}

- (void)setColor:(UIColor *)color {
    _color = color;
    self.categoryNameTextField.backgroundColor = color;
    [self.categoryNameTextField setNeedsDisplay];
}

@end
