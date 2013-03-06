//
//  ItemListViewController.h
//  iDo
//
//  Created by Recording on 1/4/13.
//  Copyright (c) 2013 Felipe Laso Marsetti. All rights reserved.
//

@interface ItemListViewController : UITableViewController

@property (copy, nonatomic) NSString *categoryNameString;
@property (strong, nonatomic) NSArray *itemsArray;

@end
