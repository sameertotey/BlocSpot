//
//  SearchTableViewController.m
//  BlocSpot
//
//  Created by Sameer Totey on 12/29/14.
//  Copyright (c) 2014 Sameer Totey. All rights reserved.
//

#import "SearchTableViewController.h"
#import "MapViewController.h"
#import "LocationCategory.h"
#import "SearchedObjectDetailViewController.h"
#import "POITableViewCell.h"
#import "UserLocation.h"

static NSString *const kShowSingleSearchObject = @"ShowSingleSearchObject";

@interface SearchTableViewController ()<POITableViewCellDelegate>
@property (nonatomic, strong) UISearchBar *searchBar;

@property (nonatomic, assign) MKCoordinateRegion boundingRegion;

@property (nonatomic, strong) MKLocalSearch *localSearch;

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *rightBarButtonItem;

@property (nonatomic, strong) MapViewController *mapViewController;

@property (nonatomic, strong) NSString *searchText;

@property (nonatomic, strong) UserLocation *userLocation;
@end

@implementation SearchTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    //     self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // setup the seach bar as the navigationItem title
    self.searchBar = [[UISearchBar alloc] init];
    self.searchBar.delegate = self;
    self.navigationItem.titleView = self.searchBar;
    self.navigationItem.rightBarButtonItems = @[self.rightBarButtonItem];
    self.userLocation = [UserLocation sharedInstance];
    self.searchText = @"";
        
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
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"PointOfInterest" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Create the sort descriptors array.
    NSSortDescriptor *locationCategoryDescriptor = [[NSSortDescriptor alloc] initWithKey:@"locationCategory.name" ascending:YES];
    NSSortDescriptor *nameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *sortDescriptors = @[locationCategoryDescriptor, nameDescriptor];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Create the predicate
    NSString *prefix = @"*";
    NSString *suffix = @"*";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name like[c] %@",
                              [[prefix stringByAppendingString:self.searchText] stringByAppendingString:suffix]];
    [fetchRequest setPredicate:predicate];
    
    // Create and initialize the fetch results controller.
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:@"locationCategory.name" cacheName:nil];
    _fetchedResultsController.delegate = self;
    
    return _fetchedResultsController;
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
}

#pragma mark - Table view data source methods

// The data source methods are handled primarily by the fetch results controller
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger numsections = [[self.fetchedResultsController sections] count];
    // Have an additional section for the search results
    numsections += 1;
    return numsections;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // the number of sections is increased by one and hence has to be offset by 1
    if (section == 0) {
        // Return the number of rows in the section.
        return [self.places count];
    } else {
        // we reduce the section number by the offset
        section--;
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
        return [sectionInfo numberOfObjects];
    }
}

// Customize the appearance of table view cells.
- (void)configureCell:(POITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    // Configure the cell...
    if (indexPath.section == 0) {
        BlocSpotModel *searchResultObjectAnnotation = [self.places objectAtIndex:indexPath.row];
        cell.textLabel.text = searchResultObjectAnnotation.title;
        cell.object = searchResultObjectAnnotation;
    } else {
        NSIndexPath *newIndex = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section - 1];
        // Configure the cell to show the poi's title
        PointOfInterest  *pointOfInterest = [self.fetchedResultsController objectAtIndexPath:newIndex];
        cell.textLabel.text = pointOfInterest.name;
        cell.object = [[BlocSpotModel alloc] initWithPointOfInterest:pointOfInterest];
    }
    cell.delegate = self;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Point of interest";
    POITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell.
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    // Display the LocationCategory name as section headings.
    if (section) {
        section--;
        return  [[[self.fetchedResultsController sections] objectAtIndex:section] name];
    } else {
        return  @"Search Results";
    }
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


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    if (indexPath.section) {
        return YES;
    } else {
        return NO;
    }
}


/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 NSFetchedResultsController delegate methods to respond to additions, removals and so on.
 */
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    
    // The fetch controller is about to start sending change notifications, so prepare the table view for updates.
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.tableView;
    
    // let us offset the indexes by 1 section to account for the search results
    if (indexPath) {
        indexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section + 1];
    }
    
    if (newIndexPath) {
        newIndexPath = [NSIndexPath indexPathForRow:newIndexPath.row inSection:newIndexPath.section + 1];
    }
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:(POITableViewCell *)[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
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

#pragma mark - POITableViewCellDelegate

- (void)didRequestZoomTo:(BlocSpotModel *)object {
    [self performSegueWithIdentifier:kShowSingleSearchObject sender:object];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"Show All Points of Interest"]) {
        if ([segue.destinationViewController isKindOfClass:[MapViewController class]]) {
            // We want to hang on the reference to the MapViewController so that it is not dealloced after we return
            self.mapViewController = [segue destinationViewController];
            // pass the new bounding region to the map destination view controller
            self.mapViewController.boundingRegion = self.boundingRegion;
            // pass the places list to the map destination view controller
            NSMutableArray *allLocations = [NSMutableArray arrayWithArray:self.places];
            for (PointOfInterest *poi in [self.fetchedResultsController fetchedObjects]) {
                [allLocations addObject:[[BlocSpotModel alloc] initWithPointOfInterest:poi]];
            }
            self.mapViewController.blocSpotObjects = allLocations;
            
            // pass the database context
            self.mapViewController.managedObjectContext = self.managedObjectContext;
            
        }
    } else if ([segue.identifier isEqualToString:kShowSingleSearchObject]) {
        if ([segue.destinationViewController isKindOfClass:[MapViewController class]]) {
            // We want to hang on the reference to the MapViewController so that it is not dealloced after we return
            self.mapViewController = [segue destinationViewController];
            // pass the new bounding region to the map destination view controller
            self.mapViewController.boundingRegion = self.boundingRegion;
            // pass the places list to the map destination view controller
            if ([sender isKindOfClass:[BlocSpotModel class]]) {
                self.mapViewController.blocSpotObjects = @[sender];
            }
            // pass the database context
            self.mapViewController.managedObjectContext = self.managedObjectContext;
            
        }
    } else if ([segue.identifier isEqualToString:@"Show Searched Object Detail"]) {
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
    }
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    //    NSLog(@"text did change to %@", searchText);
    self.searchText = searchText;
    //Maybe fire a new search here
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    [searchBar resignFirstResponder];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
    // remove all the previous search results
    self.places = nil;
    [self.tableView reloadData];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:NO animated:YES];
}

- (void)startSearch:(NSString *)searchString
{
    if (self.localSearch.searching)
    {
        [self.localSearch cancel];
    }
    
    // confine the map search area to the user's current location
    MKCoordinateRegion newRegion;
    newRegion.center.latitude = self.userLocation.location.coordinate.latitude;
    newRegion.center.longitude = self.userLocation.location.coordinate.longitude;
    
    // setup the area spanned by the map region:
    // we use the delta values to indicate the desired zoom level of the map,
    //      (smaller delta values corresponding to a higher zoom level)
    //
    newRegion.span.latitudeDelta = 0.112872;
    newRegion.span.longitudeDelta = 0.109863;
    
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    
    request.naturalLanguageQuery = searchString;
    request.region = newRegion;
    
    MKLocalSearchCompletionHandler completionHandler = ^(MKLocalSearchResponse *response, NSError *error)
    {
        if (error != nil)
        {
            NSString *errorStr = [[error userInfo] valueForKey:NSLocalizedDescriptionKey];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Could not find places"
                                                            message:errorStr
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
        else
        {
            [self loadPlacesFromResponse:response.mapItems];
            //            self.places = [response mapItems];
            
            // used for later when setting the map's region in "prepareForSegue"
            self.boundingRegion = response.boundingRegion;
            
            //after a successful search, we refetech the core data with the modidied predicate value
            
            self.fetchedResultsController = nil;
            NSError *error;
            if (![[self fetchedResultsController] performFetch:&error]) {
                /*
                 Replace this implementation with code to handle the error appropriately.
                 
                 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 */
                NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                abort();
            }
            
            
            [self.tableView reloadData];
        }
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    };
    
    if (self.localSearch != nil)
    {
        self.localSearch = nil;
    }
    self.localSearch = [[MKLocalSearch alloc] initWithRequest:request];
    
    [self.localSearch startWithCompletionHandler:completionHandler];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void) loadPlacesFromResponse:(NSArray *)response {
    NSMutableArray *responseArray = [NSMutableArray array];
    for (MKMapItem *mapItem in response) {
        [responseArray addObject:[[BlocSpotModel alloc] initWithMapItem:mapItem]];
    }
    self.places = responseArray;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    
    // check to see if Location Services is enabled, there are two state possibilities:
    // 1) disabled for entire device, 2) disabled just for this app
    //
    NSString *causeStr = nil;
    
    // check whether location services are enabled on the device
    if ([CLLocationManager locationServicesEnabled] == NO)
    {
        causeStr = @"device";
    }
    // check the application’s explicit authorization status:
    else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied)
    {
        causeStr = @"app";
    }
    else
    {
        // we are good to go, start the search
        [self startSearch:searchBar.text];
    }
    
    if (causeStr != nil)
    {
        NSString *alertMessage = [NSString stringWithFormat:@"You currently have location services disabled for this %@. Please refer to \"Settings\" app to turn on Location Services.", causeStr];
        
        UIAlertView *servicesDisabledAlert = [[UIAlertView alloc] initWithTitle:@"Location Services Disabled"
                                                                        message:alertMessage
                                                                       delegate:nil
                                                              cancelButtonTitle:@"OK"
                                                              otherButtonTitles:nil];
        [servicesDisabledAlert show];
    }
}

@end
