//
//  AddNewCategoryViewController.h
//  BlocSpot
//
//  Created by Sameer Totey on 12/15/14.
//  Copyright (c) 2014 Sameer Totey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddNewCategoryViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;


@end
