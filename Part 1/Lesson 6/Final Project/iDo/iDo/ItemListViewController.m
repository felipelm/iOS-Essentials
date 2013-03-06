//
//  ItemListViewController.m
//  iDo
//
//  Created by Recording on 1/4/13.
//  Copyright (c) 2013 Felipe Laso Marsetti. All rights reserved.
//

#import "ItemCell.h"
#import "ItemListViewController.h"

@implementation ItemListViewController

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
                         }
                         else
                         {
                             [sender setTitle:@"Done"];
                             [sender setStyle:UIBarButtonItemStyleDone];
                         }
                     }
                     completion:nil];
    
    [self.tableView setEditing:!self.tableView.editing animated:YES];
}

#pragma mark - Table View Data Source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ItemCell *itemCell = [tableView dequeueReusableCellWithIdentifier:@"ItemCell"];
    
    itemCell.nameLabel.text = [NSString stringWithFormat:@"%@", self.itemsArray[indexPath.row]];
    
    return itemCell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.itemsArray.count;
}

#pragma mark - View Lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.title = self.categoryNameString;
}

@end
