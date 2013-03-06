//
//  SettingsViewController.m
//  iDo
//
//  Created by Recording on 1/4/13.
//  Copyright (c) 2013 Felipe Laso Marsetti. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@property (weak, nonatomic) IBOutlet UIButton *facebookButton;
@property (weak, nonatomic) IBOutlet UIView *tintColorView;
@property (weak, nonatomic) IBOutlet UIButton *twitterButton;

@end

@implementation SettingsViewController

#pragma mark - IBActions

- (IBAction)doneTapped
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)facebookTapped
{
    NSLog(@"Facebook Tapped");
}

- (IBAction)twitterTapped
{
    NSLog(@"Twitter Tapped");
}

#pragma mark - View Lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.navigationController.navigationBar.tintColor)
    {
        self.tintColorView.backgroundColor = self.navigationController.navigationBar.tintColor;
    }
}

@end
