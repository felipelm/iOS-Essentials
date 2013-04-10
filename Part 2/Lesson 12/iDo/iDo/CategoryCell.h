//
//  CategoryCell.h
//  iDo
//
//  Created by Recording on 1/8/13.
//  Copyright (c) 2013 Felipe Laso Marsetti. All rights reserved.
//

#import "ContentSuperCell.h"

@interface CategoryCell : ContentSuperCell

@property (weak, nonatomic) IBOutlet UILabel *itemCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end
