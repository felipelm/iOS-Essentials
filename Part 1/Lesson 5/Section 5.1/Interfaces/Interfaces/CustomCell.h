//
//  CustomCell.h
//  Interfaces
//
//  Created by Felipe on 11/25/12.
//  Copyright (c) 2012 Felipe Laso Marsetti. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
