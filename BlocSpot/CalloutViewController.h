//
//  CalloutViewController.h
//  BlocSpot
//
//  Created by Sameer Totey on 12/19/14.
//  Copyright (c) 2014 Sameer Totey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchedObjectDetailViewController.h"

@interface CalloutViewController : UIViewController <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (weak, nonatomic) IBOutlet UIButton *visitedButton;
@property (weak, nonatomic) IBOutlet UITextView *noteTextView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *locationCategoryBarButtonItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *deleteBarButtonItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *navigateBarButtonItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *shareBarButtonItem;
@property (nonatomic, strong) BlocSpotModel *annotation;
@property (weak, nonatomic) IBOutlet UIToolbar *callOutToolbar;
@property (nonatomic) id<UIViewControllerTransitioningDelegate> modalTransitioningDelegate;

extern  NSString * const kDisplayOverlay;

@end
