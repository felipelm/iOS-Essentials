//
//  ContentSuperCell.m
//  iDo
//
//  Created by Recording on 1/8/13.
//  Copyright (c) 2013 Felipe Laso Marsetti. All rights reserved.
//

#import "ContentSuperCell.h"

@implementation ContentSuperCell

#pragma mark - View Lifecycle

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    for (NSLayoutConstraint *cellConstraint in self.constraints)
    {
        [self removeConstraint:cellConstraint];
        
        id firstItem = cellConstraint.firstItem == self ? self.contentView : cellConstraint.firstItem;
        id secondItem = cellConstraint.secondItem == self ? self.contentView : cellConstraint.secondItem;
        
        NSLayoutConstraint *contentViewConstraint = [NSLayoutConstraint constraintWithItem:firstItem
                                                                                 attribute:cellConstraint.firstAttribute
                                                                                 relatedBy:cellConstraint.relation
                                                                                    toItem:secondItem
                                                                                 attribute:cellConstraint.secondAttribute
                                                                                multiplier:cellConstraint.multiplier
                                                                                  constant:cellConstraint.constant];
        [self.contentView addConstraint:contentViewConstraint];
    }
}

@end
