//
//  CategoryCell.m
//  iDo
//
//  Created by Recording on 1/8/13.
//  Copyright (c) 2013 Felipe Laso Marsetti. All rights reserved.
//

#import "CategoryCell.h"

@implementation CategoryCell

- (NSString *)accessibilityHint
{
    if (self.editing)
    {
        return @"Edit category title";
    }
    
    return @"View category items";
}

- (NSString *)accessibilityValue
{
    return [NSString stringWithFormat:@"%@, %@ items in this category", self.nameLabel.text, self.itemCountLabel.text];
}

@end
