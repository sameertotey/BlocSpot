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
- (NSFetchedResultsController *)fetchedResultsController {
    
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    // Create and configure a fetch request with the Book entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"LocationCategory" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Create the sort descriptors array.
    NSSortDescriptor *locationCategoryDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *sortDescriptors = @[locationCategoryDescriptor];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Create and initialize the fetch results controller.
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    _fetchedResultsController.delegate = self;
    
    return _fetchedResultsController;
}


/*
 NSFetchedResultsController delegate methods to respond to additions, removals and so on.
 */
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    
    // The fetch controller is about to start sending change notifications, so prepare the table view for updates.
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.tableView;
    
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:(LocationCategoryTableViewCell *)[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    
    // offset the sectionIndex by 1 for search results
    sectionIndex++;
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
            
        case NSFetchedResultsChangeUpdate:
            break;
            
        case NSFetchedResultsChangeMove:
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller has sent all current change notifications, so tell the table view to process all updates.

    [self.tableView endUpdates];
}


#pragma mark - Table view data source methods


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

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
    NSLog(@"did receive long press %@", locationCategory);
    self.selectedCategory = cell.object.name;
    [self.tableView reloadData];
}

@end
