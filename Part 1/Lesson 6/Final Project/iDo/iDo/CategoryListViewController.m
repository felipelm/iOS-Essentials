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

@interface CategoryListViewController ()

@property (strong, nonatomic) NSArray *itemsArray;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *settingsButton;

@end

@implementation CategoryListViewController

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
        NSLog(@"ADD A NEW ITEM");
    }
    else
    {
        [self performSegueWithIdentifier:@"SettingsSegue" sender:self];
    }
}

#pragma mark - Table View Data Source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CategoryCell *categoryCell = [tableView dequeueReusableCellWithIdentifier:@"CategoryCell"];
    
    NSDictionary *currentItem = self.itemsArray[indexPath.row];

    categoryCell.nameLabel.text = currentItem[@"categoryName"];
    
    NSInteger itemCount = ((NSArray *)currentItem[@"categoryItems"]).count;
    categoryCell.itemCountLabel.text = [NSString stringWithFormat:@"%d", itemCount];
    
    return categoryCell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.itemsArray.count;
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
    if ([segue.identifier isEqualToString:@"ItemListSegue"])
    {
        CategoryListViewController *categoryListViewController = segue.sourceViewController;
        NSIndexPath *selectedRowIndexPath = [categoryListViewController.tableView indexPathForSelectedRow];
        
        CategoryCell *categoryCell = (CategoryCell *)[categoryListViewController.tableView cellForRowAtIndexPath:selectedRowIndexPath];
        NSString *categoryName = categoryCell.nameLabel.text;
        
        ItemListViewController *itemListViewController = segue.destinationViewController;
        itemListViewController.categoryNameString = categoryName;
        
        NSDictionary *currentItem = self.itemsArray[self.tableView.indexPathForSelectedRow.row];
        itemListViewController.itemsArray = currentItem[@"categoryItems"];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.itemsArray = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"CategoriesAndItems" ofType:@"plist"]];
    
    NSLog(@"%@", self.itemsArray);
}

@end
