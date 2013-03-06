//
//  DetailViewController.m
//  iDo
//
//  Created by Recording on 1/4/13.
//  Copyright (c) 2013 Felipe Laso Marsetti. All rights reserved.
//

#import "DetailViewController.h"

@implementation DetailViewController

#pragma mark - IBActions

- (IBAction)cancelTapped
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)doneTapped
{
    // DONE LOGIC GOES HERE
    
    [self cancelTapped];
}

#pragma mark - View Lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.titleTextField.text = self.objectTitle;
}

@end
