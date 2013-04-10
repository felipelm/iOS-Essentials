//
//  ItemCell.m
//  iDo
//
//  Created by Recording on 1/8/13.
//  Copyright (c) 2013 Felipe Laso Marsetti. All rights reserved.
//

#import "ItemCell.h"

@implementation ItemCell

- (NSString *)accessibilityHint
{
    if (self.editing)
    {
        return @"Edit item title";
    }
    
    return @"";
}

- (NSString *)accessibilityValue
{
    return self.nameLabel.text;
}

@end
