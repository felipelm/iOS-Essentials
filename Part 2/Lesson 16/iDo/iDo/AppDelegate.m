//
//  AppDelegate.m
//  iDo
//
//  Created by Recording on 12/11/12.
//  Copyright (c) 2012 Felipe Laso Marsetti. All rights reserved.
//

#import "AppDelegate.h"
#import "CoreListViewController.h"
#import "DetailViewController_iPad.h"

@implementation AppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

#pragma mark - App Delegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"NavigationBarTintColor"];
    UIColor *tintColor = [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
    
    [[UINavigationBar appearance] setTintColor:tintColor];
    
    [self customizeUI];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
        UINavigationController *listNavigationController = splitViewController.viewControllers[0];
        CoreListViewController *coreListViewController = (CoreListViewController *)[listNavigationController topViewController];
        UINavigationController *detailNavigationController = splitViewController.viewControllers[1];
        DetailViewController_iPad *detailViewController = (DetailViewController_iPad *)[detailNavigationController topViewController];
        
        coreListViewController.delegate = detailViewController;
        splitViewController.delegate = detailViewController;
    }
    
    return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [self saveContext];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    [self saveContext];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [self saveContext];
}

#pragma mark - Instance Methods

- (NSURL *)documentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (void)saveContext
{
    NSError *error;
    
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    
    if (managedObjectContext != nil)
    {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Save Error"
                                                                message:[error localizedDescription]
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
            [alertView show];
        }
    }
}

#pragma mark - Private Methods

- (void)customizeUI
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        UIImage *navigationBarImage = [UIImage imageNamed:@"NavBar_Background"];
        [[UINavigationBar appearance] setBackgroundImage:navigationBarImage forBarMetrics:UIBarMetricsDefault];
        
        [[UINavigationBar appearance] setTitleTextAttributes:@{ UITextAttributeTextColor : [UIColor whiteColor]}];
    }
    else
    {
        UIImage *navigationBarLandscapeImage = [UIImage imageNamed:@"NavBar_Background_Landscape"];
        UIImage *navigationBarPortraitImage = [UIImage imageNamed:@"NavBar_Background_Portrait"];
        [[UINavigationBar appearance] setBackgroundImage:navigationBarLandscapeImage forBarMetrics:UIBarMetricsLandscapePhone];
        [[UINavigationBar appearance] setBackgroundImage:navigationBarPortraitImage forBarMetrics:UIBarMetricsDefault];
    }
}

#pragma mark - Properties

- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext)
    {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *persistentStoreCoordinator = self.persistentStoreCoordinator;
    
    if (persistentStoreCoordinator)
    {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:persistentStoreCoordinator];
    }
    
    return _managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel)
    {
        return _managedObjectModel;
    }
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"iDo_Model" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator)
    {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self documentsDirectory] URLByAppendingPathComponent:@"iDo.sqlite"];
    
    NSError *error;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
    
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                   configuration:nil
                                                             URL:storeURL
                                                         options:nil
                                                           error:&error])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Store Error"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
    
    return _persistentStoreCoordinator;
}

@end
