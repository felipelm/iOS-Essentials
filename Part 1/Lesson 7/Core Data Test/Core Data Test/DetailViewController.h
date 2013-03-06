//
//  DetailViewController.h
//  Core Data Test
//
//  Created by Felipe on 1/14/13.
//  Copyright (c) 2013 Felipe Laso Marsetti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EventData.h"

@interface DetailViewController : UIViewController

@property (strong, nonatomic) EventData *detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
