//
//  PointsOfInterestTableViewController.m
//  BlocSpot
//
//  Created by Sameer Totey on 12/4/14.
//  Copyright (c) 2014 Sameer Totey. All rights reserved.
//

#import "PointsOfInterestTableViewController.h"
#import "MapViewController.h"
#import "LocationCategory.h"
#import "SearchedObjectDetailViewController.h"
#import "POIDetailTableViewCell.h"
#import "CategoryListTableViewController.h"
#import "ModalTransitionAnimator.h"
#import "SearchTableViewController.h"
#import "UserLocation.h"

static NSString * const kSegueAddCategoryDismiss   = @"addCategoryDismiss";
static NSString * const kShowMapsViewController    = @"Show Maps ViewController";
static NSString * const kShowSearchViewController  = @"Show Search ViewController";
static NSString * const kPresentCategoryFilter     = @"Select Category Filter";
static NSString * const kShowObjectDetail          = @"BlocSpot Object Detail View Controller";

@interface PointsOfInterestTableViewController () <UIViewControllerTransitioningDelegate>
@property (nonatomic, strong) UIBarButtonItem *rightBarButtonItem;
@property (nonatomic, strong) MapViewController *mapViewController;
@property (nonatomic, strong) NSString *locationCategory;

@property (nonatomic, strong) UIBarButtonItem *mapButton;
@property (nonatomic, strong) UIBarButtonItem *searchButton;
@property (nonatomic, strong) UIBarButtonItem *filterButton;

@property (nonatomic, strong) UserLocation *userLocation;

@end

@implementation PointsOfInterestTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
     self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
//     self.navigationItem.rightBarButtonItem = self.editButtonItem;
    

//    self.navigationItem.rightBarButtonItems = nil;
    
    
//    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    self.locationCategory = @"";
    self.title = @"POI List";
    
    self.mapButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"map"] style:UIBarButtonItemStylePlain target:self action:@selector(mapTapped)];
    self.searchButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchTapped)];
    self.filterButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"filter"] style:UIBarButtonItemStylePlain target:self action:@selector(filterTapped)];
    
    self.navigationItem.leftBarButtonItems = @[self.mapButton, self.searchButton];
    self.navigationItem.rightBarButtonItems = @[self.filterButton];
    [self setupFetchedResultsController];
    self.userLocation = [UserLocation sharedInstance];
    
    NSError *error;
    if (![self.fetchedResultsController performFetch:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }

}

- (void) mapTapped {
    [self performSegueWithIdentifier:kShowMapsViewController sender:self];

}

- (void) searchTapped {
    [self performSegueWithIdentifier:kShowSearchViewController sender:self];

}

- (void) filterTapped{
    [self performSegueWithIdentifier:kPresentCategoryFilter sender:self];
    // reset the filter
    self.locationCategory = @"";
}

#pragma mark - Fetched results controller

/*
 Returns the fetched results controller. Creates and configures the controller if necessary.
 */
- (void)setupFetchedResultsController {
    
    // Create and configure a fetch request with the Book entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"PointOfInterest" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Create the sort descriptors array.
    NSSortDescriptor *locationCategoryDescriptor = [[NSSortDescriptor alloc] initWithKey:@"locationCategory.name" ascending:YES];
    NSSortDescriptor *nameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *sortDescriptors = @[locationCategoryDescriptor, nameDescriptor];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Create the predicate
    if ([self.locationCategory length]) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"locationCategory.name like[c] %@", self.locationCategory];
        [fetchRequest setPredicate:predicate];
    }
    
    // Create and initialize the fetch results controller.
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:@"locationCategory.name" cacheName:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view editing

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // The table view should not be re-orderable.
    return NO;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    
    [super setEditing:editing animated:animated];
    
    if (editing) {
        self.rightBarButtonItem = self.navigationItem.rightBarButtonItem;
        self.navigationItem.rightBarButtonItem = nil;
    }
    else {
        self.navigationItem.rightBarButtonItem = self.rightBarButtonItem;
        self.rightBarButtonItem = nil;
    }
}

#pragma mark - Table view delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Table view did select....");
    [self performSegueWithIdentifier:kShowObjectDetail sender:[tableView cellForRowAtIndexPath:indexPath]];
}

#pragma mark - Table view data source methods

// Customize the appearance of table view cells.
- (void)configureCell:(POIDetailTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    // Configure the cell to show the poi's title
    PointOfInterest  *pointOfInterest = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.poiTitle.text = pointOfInterest.name;
    cell.poiNotes.text = pointOfInterest.note;
    cell.object = [[BlocSpotModel alloc] initWithPointOfInterest:pointOfInterest];

    cell.poiDistanceLabel.text = [NSString stringWithFormat:@"%.1f mi", cell.object.currentDistanceFromUser * 0.000621371];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"DetailPOICell";
    POIDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell.
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        if (indexPath.section == 0) {
            NSLog(@"Cannot delete search results");
        } else {
            NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section - 1];
            // Delete the managed object.
            NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
            [context deleteObject:[self.fetchedResultsController objectAtIndexPath:newIndexPath]];
        
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
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:kShowMapsViewController]) {
        if ([segue.destinationViewController isKindOfClass:[MapViewController class]]) {
            MapViewController *mapvc = (MapViewController *)segue.destinationViewController;
            
            NSMutableArray *allLocations = [NSMutableArray array];
            for (PointOfInterest *poi in [self.fetchedResultsController fetchedObjects]) {
                [allLocations addObject:[[BlocSpotModel alloc] initWithPointOfInterest:poi]];
            }
            mapvc.blocSpotObjects = allLocations;

            // pass the database context
            self.mapViewController.managedObjectContext = self.managedObjectContext;

        }
    } else if ([segue.identifier isEqualToString:kShowSearchViewController]) {
        if ([segue.destinationViewController isKindOfClass:[SearchTableViewController class]]) {
            SearchTableViewController *searchtvc = (SearchTableViewController *)segue.destinationViewController;
            // pass the database context
            searchtvc.managedObjectContext = self.managedObjectContext;
        }

    } else if ([segue.identifier isEqualToString:kShowObjectDetail]) {
        if ([segue.destinationViewController isKindOfClass:[SearchedObjectDetailViewController class]]) {
            // setup the detail object as well as pass the database context for saving changes to the object
            SearchedObjectDetailViewController *sodvc = (SearchedObjectDetailViewController *)segue.destinationViewController;
            if ([sender isKindOfClass:[POITableViewCell class]]) {
                sodvc.detailObject = [sender object];
            } else {
                NSLog(@"Sender is %@", sender);
            }
            sodvc.managedObjectContext  = self.managedObjectContext;
        }
    } else if ([segue.identifier isEqualToString:kPresentCategoryFilter]) {
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
                self.locationCategory = source.selectedCategory;
            }
        }
        [self dismissViewControllerAnimated:YES completion:nil];
        [self setupFetchedResultsController];
    }
}

@end
