//
//  CategoryListViewController.m
//  iDo
//
//  Created by Recording on 1/4/13.
//  Copyright (c) 2013 Felipe Laso Marsetti. All rights reserved.
//

#import "AppDelegate.h"
#import "Category.h"
#import "CategoryCell.h"
#import "CategoryListViewController.h"
#import "DetailViewController.h"
#import "ItemListViewController.h"

@interface CategoryListViewController () <NSFetchedResultsControllerDelegate, UIAlertViewDelegate>
{
    BOOL alertViewPresented;
}

@property (strong, nonatomic, readonly) NSFetchedResultsController *fetchedResultsController;
@property (weak, nonatomic, readonly) NSManagedObjectContext *managedObjectContext;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *settingsButton;

@end

@implementation CategoryListViewController

@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize managedObjectContext = _managedObjectContext;

#pragma mark - Alert View Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    alertViewPresented = NO;
}

#pragma mark - Fetched Results Controller Delegate

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    switch (type)
    {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:(CategoryCell *)[self.tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        default:
            break;
    }
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

#pragma mark - IBActions

- (IBAction)detailDoneTapped:(UIStoryboardSegue *)segue
{
    DetailViewController *detailViewController = segue.sourceViewController;
    Category *selectedCategory = [self.fetchedResultsController objectAtIndexPath:self.tableView.indexPathForSelectedRow];
    selectedCategory.title = detailViewController.titleTextField.text;
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate saveContext];
}

- (IBAction)editTapped:(UIBarButtonItem *)sender
{
    [UIView animateWithDuration:0.25
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         if (sender.style == UIBarButtonItemStyleDone)
                         {
                             [sender setTitle:@"Edit"];
                             [sender setStyle:UIBarButtonItemStyleBordered];
                             [self.settingsButton setTitle:@"Setting"];
                         }
                         else
                         {
                             [sender setTitle:@"Done"];
                             [sender setStyle:UIBarButtonItemStyleDone];
                             [self.settingsButton setTitle:@"Add"];
                         }
                     }
                     completion:nil];
    
    [self.tableView setEditing:!self.tableView.editing animated:YES];
}

- (IBAction)settingsTapped
{
    if (self.tableView.editing)
    {
        [NSEntityDescription insertNewObjectForEntityForName:@"Category" inManagedObjectContext:self.managedObjectContext];
        
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        [appDelegate saveContext];
    }
    else
    {
        [self performSegueWithIdentifier:@"SettingsSegue" sender:self];
    }
}

#pragma mark - Private Methods

- (void)configureCell:(CategoryCell *)categoryCell atIndexPath:(NSIndexPath *)indexPath
{
    Category *category = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    categoryCell.nameLabel.text = category.title;
    categoryCell.itemCountLabel.text = [NSString stringWithFormat:@"%d", category.items.count];
}

#pragma mark - Properties

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController)
    {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Category"
                                                         inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entityDescription];

    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    [fetchRequest setSortDescriptors:sortDescriptors];

    NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                                               managedObjectContext:self.managedObjectContext
                                                                                                 sectionNameKeyPath:nil
                                                                                                          cacheName:nil];
    fetchedResultsController.delegate = self;
    _fetchedResultsController = fetchedResultsController;

    NSError *error;

    if (![self.fetchedResultsController performFetch:&error])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Load Error"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
    }

    return _fetchedResultsController;
}

- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext)
    {
        return _managedObjectContext;
    }
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    _managedObjectContext = appDelegate.managedObjectContext;
    
    return _managedObjectContext;
}

#pragma mark - Table View Data Source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CategoryCell *categoryCell = [tableView dequeueReusableCellWithIdentifier:@"CategoryCell"];

    [self configureCell:categoryCell atIndexPath:indexPath];

    return categoryCell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.fetchedResultsController.fetchedObjects.count;
}

#pragma mark - Table View Delegate

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [self.managedObjectContext deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        [appDelegate saveContext];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.editing)
    {
        [self performSegueWithIdentifier:@"CategoryDetailSegue" sender:self];
    }
    else
    {
        [self performSegueWithIdentifier:@"ItemListSegue" sender:self];
    }
}

#pragma mark - View Lifecycle

- (BOOL)canPerformUnwindSegueAction:(SEL)action fromViewController:(UIViewController *)fromViewController withSender:(id)sender
{
    if (alertViewPresented)
    {
        return NO;
    }
    
    DetailViewController *detailViewController = (DetailViewController *)fromViewController;
    
    if (!detailViewController.titleTextField || detailViewController.titleTextField.text.length == 0)
    {
        alertViewPresented = YES;
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"The title can't be blank"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
        
        return NO;
    }
    
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    CategoryListViewController *categoryListViewController = segue.sourceViewController;
    NSIndexPath *selectedRowIndexPath = [categoryListViewController.tableView indexPathForSelectedRow];
    
    CategoryCell *categoryCell = (CategoryCell *)[categoryListViewController.tableView cellForRowAtIndexPath:selectedRowIndexPath];
    NSString *categoryName = categoryCell.nameLabel.text;
    
    if ([segue.identifier isEqualToString:@"ItemListSegue"])
    {
        ItemListViewController *itemListViewController = segue.destinationViewController;
        itemListViewController.categoryNameString = categoryName;
        
        Category *selectedCategory = [self.fetchedResultsController objectAtIndexPath:self.tableView.indexPathForSelectedRow];
        itemListViewController.category = selectedCategory;
    }
    else if ([segue.identifier isEqualToString:@"CategoryDetailSegue"])
    {
        UINavigationController *navigationController = segue.destinationViewController;
        DetailViewController *detailViewController = (DetailViewController *)[navigationController.viewControllers lastObject];
        detailViewController.objectTitle = categoryName;
    }
}

@end
