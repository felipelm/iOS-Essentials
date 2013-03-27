//
//  Item.h
//  iDo
//
//  Created by Recording on 2/5/13.
//  Copyright (c) 2013 Felipe Laso Marsetti. All rights reserved.
//

@class Category;

@interface Item : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) Category *category;

@end
