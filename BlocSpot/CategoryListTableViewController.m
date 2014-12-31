//
//  CategoryListTableViewController.m
//  BlocSpot
//
//  Created by Sameer Totey on 12/23/14.
//  Copyright (c) 2014 Sameer Totey. All rights reserved.
//

#import "CategoryListTableViewController.h"
#import "AddNewCategoryViewController.h"

@interface CategoryListTableViewController ()
@property (strong, nonatomic)UIBarButtonItem *addButton;
@property (strong, nonatomic)UIBarButtonItem *doneButton;

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end

@implementation CategoryListTableViewController

- (void)viewDidLoad {
    self.addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewCategory)];
    self.doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneWithCategories)];
    self.navigationItem.rightBarButtonItem = self.addButton;
    self.navigationItem.leftBarButtonItem = self.doneButton;
    
    self.title = @"Location Category";
    
    [self setupFetchedResultsController];

    NSError *error;
    if (![[self fetchedResultsController] performFetch:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }

}

- (void)addNewCategory {
    [self performSegueWithIdentifier:@"Edit Location Category" sender:self];
}

- (void)doneWithCategories {
    [self performSegueWithIdentifier:@"addCategoryDismiss" sender:self];
}

#pragma mark - Fetched results controller

/*
 Returns the fetched results controller. Creates and configures the controller if necessary.
 */
- (void)setupFetchedResultsController {
    
    // Create and configure a fetch request with the Book entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"LocationCategory" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Create the sort descriptors array.
    NSSortDescriptor *locationCategoryDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *sortDescriptors = @[locationCategoryDescriptor];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Create and initialize the fetch results controller.
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
}

#pragma mark - Table view data source methods


// Customize the appearance of table view cells.
- (void)configureCell:(LocationCategoryTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    // Configure the cell to show the category's name
    LocationCategory  *locationCategory = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.object = locationCategory;
    cell.chosen =  [self.selectedCategory isEqualToString:locationCategory.name];
    cell.delegate = self;
 }

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Location Category";
    LocationCategoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell.
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        // Delete the managed object.
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
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
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


#pragma mark - Table view delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
        NSLog(@"Table view did select....");
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([sender isKindOfClass:[LocationCategoryTableViewCell class]]) {
        LocationCategoryTableViewCell *lctvc = (LocationCategoryTableViewCell *)sender;
        if ([segue.destinationViewController isKindOfClass:[AddNewCategoryViewController class]]) {
            AddNewCategoryViewController *newvc = (AddNewCategoryViewController *)segue.destinationViewController;
            newvc.locationCategory = lctvc.object;
        }
    }
    if ([segue.destinationViewController isKindOfClass:[AddNewCategoryViewController class]]) {
        AddNewCategoryViewController *newvc = (AddNewCategoryViewController *)segue.destinationViewController;
        newvc.managedObjectContext = self.managedObjectContext;
    }
}


#pragma mark - LocationCategoryTableViewCellDelegate

- (void)cell:(LocationCategoryTableViewCell *)cell didSelectLocation:(LocationCategory *)locationCategory {
    self.selectedCategory = cell.object.name;
    [self.tableView reloadData];
}

@end
