//
//  CategoryListViewController.m
//  iDo
//
//  Created by Recording on 1/4/13.
//  Copyright (c) 2013 Felipe Laso Marsetti. All rights reserved.
//

#import "CategoryCell.h"
#import "CategoryListViewController.h"
#import "ItemListViewController.h"

NSString *const categoryListSortAscendingKey = @"categoryListSortAscending";

@interface CategoryListViewController ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *settingsButton;

@end

@implementation CategoryListViewController

@synthesize fetchedResultsController = _fetchedResultsController;

#pragma mark - IBActions

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

#pragma mark - Instance Methods

- (void)changeSortOrder
{
    _fetchedResultsController = nil;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    BOOL sortAscending = [userDefaults boolForKey:categoryListSortAscendingKey];
    
    [userDefaults setBool:!sortAscending forKey:categoryListSortAscendingKey];
    [userDefaults synchronize];
    
    [self performSelector:@selector(updateTable) withObject:nil afterDelay:1.0];
}

- (CGFloat)labelHeightForText:(NSString *)text withFont:(UIFont *)font
{
    CGFloat widthPadding = 103;
    
    CGSize constrainSize = CGSizeMake(self.tableView.frame.size.width - widthPadding, 100);
    CGSize labelSize = [text sizeWithFont:font constrainedToSize:constrainSize];
    
    return labelSize.height;
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

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    BOOL sortAscending = [userDefaults boolForKey:categoryListSortAscendingKey];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:sortAscending];
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

#pragma mark - Table View Data Source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CategoryCell *categoryCell = [tableView dequeueReusableCellWithIdentifier:@"CategoryCell"];

    [self configureCell:categoryCell atIndexPath:indexPath];

    return categoryCell;
}

#pragma mark - Table View Delegate

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
