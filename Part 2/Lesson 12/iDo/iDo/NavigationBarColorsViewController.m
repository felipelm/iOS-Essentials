//
//  NavigationBarColorsViewController.m
//  iDo
//
//  Created by Recording on 1/4/13.
//  Copyright (c) 2013 Felipe Laso Marsetti. All rights reserved.
//

#import "NavigationBarColorsViewController.h"

#define kGreenColor     [UIColor colorWithRed:86.0/255.0  green:196.0/255.0 blue:54.0/255.0  alpha:1.0]
#define kYellowColor    [UIColor colorWithRed:245.0/255.0 green:218.0/255.0 blue:56.0/255.0  alpha:1.0]
#define kOrangeColor    [UIColor colorWithRed:255.0/255.0 green:128.0/255.0 blue:0.0/255.0   alpha:1.0]
#define kRedColor       [UIColor colorWithRed:255.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0]
#define kPinkColor      [UIColor colorWithRed:255.0/255.0 green:111.0/255.0 blue:207.0/255.0 alpha:1.0]
#define kPurpleColor    [UIColor colorWithRed:204.0/255.0 green:102.0/255.0 blue:255.0/255.0 alpha:1.0]
#define kBlueColor      [UIColor colorWithRed:102.0/255.0 green:204.0/255.0 blue:255.0/255.0 alpha:1.0]
#define kBlackColor     [UIColor blackColor]
#define kGrayColor      [UIColor colorWithRed:170.0/255.0 green:170.0/255.0 blue:170.0/255.0 alpha:1.0]

@implementation NavigationBarColorsViewController

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIColor *tintColor;
    
    switch (indexPath.row)
    {
        case NavigationBarColorGreen:
            tintColor = kGreenColor;
            break;
            
        case NavigationBarColorYellow:
            tintColor = kYellowColor;
            break;
            
        case NavigationBarColorOrange:
            tintColor = kOrangeColor;
            break;
            
        case NavigationBarColorRed:
            tintColor = kRedColor;
            break;
            
        case NavigationBarColorPink:
            tintColor = kPinkColor;
            break;
            
        case NavigationBarColorPurple:
            tintColor = kPurpleColor;
            break;
            
        case NavigationBarColorBlue:
            tintColor = kBlueColor;
            break;
            
        case NavigationBarColorBlack:
            tintColor = kBlackColor;
            break;
            
        case NavigationBarColorGray:
            tintColor = kGrayColor;
            break;
            
        default:
            tintColor = kBlackColor;
            break;
    }
    
    [[UINavigationBar appearance] setTintColor:tintColor];
    self.navigationController.navigationBar.tintColor = tintColor;
    
    NSData *colorData = [NSKeyedArchiver archivedDataWithRootObject:tintColor];
    [[NSUserDefaults standardUserDefaults] setObject:colorData forKey:@"NavigationBarTintColor"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ListBackground"]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, @"Select an option form the list to set the colors of the navigation buttons");
}

@end
