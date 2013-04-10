//
//  Category.h
//  iDo
//
//  Created by Recording on 2/5/13.
//  Copyright (c) 2013 Felipe Laso Marsetti. All rights reserved.
//

@interface Category : NSManagedObject

@property (nonatomic, retain) NSNumber *icon;
@property (nonatomic, retain) NSSet *items;
@property (nonatomic, retain) NSString *title;

@end

@interface Category (CoreDataGeneratedAccessors)

- (void)addItems:(NSSet *)values;
- (void)addItemsObject:(NSManagedObject *)value;
- (void)removeItems:(NSSet *)values;
- (void)removeItemsObject:(NSManagedObject *)value;

@end
