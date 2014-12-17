//
//  SearchedObjectDetailViewController.h
//  BlocSpot
//
//  Created by Sameer Totey on 12/6/14.
//  Copyright (c) 2014 Sameer Totey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchResultObjectAnnotation.h"

@interface SearchedObjectDetailViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate>
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong)SearchResultObjectAnnotation *detailObject;

@end
