//
//  CategoryListTableViewController.h
//  BlocSpot
//
//  Created by Sameer Totey on 12/23/14.
//  Copyright (c) 2014 Sameer Totey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationCategory+Create.h"
#import "LocationCategoryTableViewCell.h"

@interface CategoryListTableViewController : UITableViewController <NSFetchedResultsControllerDelegate, LocationCategoryTableViewCellDelegate>
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSString *selectedCategory;
@end
