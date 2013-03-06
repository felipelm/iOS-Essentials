//
//  ItemListViewController.h
//  iDo
//
//  Created by Recording on 1/4/13.
//  Copyright (c) 2013 Felipe Laso Marsetti. All rights reserved.
//

@class Category;

@interface ItemListViewController : UITableViewController

@property (strong, nonatomic) Category *category;
@property (copy, nonatomic) NSString *categoryNameString;

@end
