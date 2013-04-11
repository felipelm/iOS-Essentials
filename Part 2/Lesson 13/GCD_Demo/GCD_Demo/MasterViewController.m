//
//  MasterViewController.m
//  GCD_Demo
//
//  Created by Recording on 4/10/13.
//  Copyright (c) 2013 Felipe Laso Marsetti. All rights reserved.
//

#import "MasterViewController.h"

@interface MasterViewController ()

@property (strong, nonatomic, readonly) ACAccountStore *accountStore;
@property (strong, nonatomic) NSCache *imageCache;
@property (strong, nonatomic) NSArray *tweetsArray;
@property (strong, nonatomic) ACAccount *twitterAccount;

@end

@implementation MasterViewController

@synthesize accountStore = _accountStore;

#pragma mark - Private Methods

- (void)getTwitterAccount
{
    ACAccountType *twitterAccountType = [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    __weak MasterViewController *weakSelf = self;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [weakSelf.accountStore requestAccessToAccountsWithType:twitterAccountType options:nil completion:^(BOOL granted, NSError *error) {
            if (granted)
            {
                NSArray *twitterAccounts = [weakSelf.accountStore accountsWithAccountType:twitterAccountType];
                
                if (twitterAccounts && [twitterAccounts count] > 0)
                {
                    weakSelf.twitterAccount = twitterAccounts[0];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelf refreshPearsonFeed];
                    });
                }
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                        message:[error localizedDescription]
                                                                       delegate:nil
                                                              cancelButtonTitle:@"OK"
                                                              otherButtonTitles:nil];
                    [alertView show];
                });
            }
        }];
    });
}

- (void)refreshPearsonFeed
{
    __weak MasterViewController *weakSelf = self;
    
    SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                            requestMethod:SLRequestMethodGET
                                                      URL:[NSURL URLWithString:@"https://api.twitter.com/1.1/statuses/user_timeline.json"]
                                               parameters:@{@"count" : @"100", @"screen_name" : @"pearson", @"include_rts" : @"true"}];
    request.account = self.twitterAccount;
    
    [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        if (weakSelf.refreshControl.isRefreshing)
        {
            [weakSelf.refreshControl endRefreshing];
        }
        
        if (error)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                    message:[error localizedDescription]
                                                                   delegate:nil
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                
                [alertView show];
            });
        }
        else
        {
            NSError *jsonError;
            NSArray *responseJSON = [NSJSONSerialization JSONObjectWithData:responseData
                                                                    options:NSJSONReadingAllowFragments
                                                                      error:&jsonError];
            
            if (jsonError)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                        message:[jsonError localizedDescription]
                                                                       delegate:nil
                                                              cancelButtonTitle:@"OK"
                                                              otherButtonTitles:nil];
                    [alertView show];
                });
            }
            else
            {
                self.tweetsArray = responseJSON;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.tableView reloadData];
                });
            }
        }
    }];
}

#pragma mark - Properties

- (ACAccountStore *)accountStore
{
    if (!_accountStore)
    {
        _accountStore = [ACAccountStore new];
    }
    
    return _accountStore;
}

- (NSCache *)imageCache
{
    if (!_imageCache)
    {
        _imageCache = [[NSCache alloc] init];
    }
    
    return _imageCache;
}

#pragma mark - Table View Data Source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    NSDictionary *userDictionary = self.tweetsArray[indexPath.row][@"user"];
    
    cell.textLabel.text = userDictionary[@"name"];
    cell.detailTextLabel.text = self.tweetsArray[indexPath.row][@"text"];
    
    if ([self.imageCache objectForKey:userDictionary[@"id"]])
    {
        cell.imageView.image = [self.imageCache objectForKey:userDictionary[@"id"]];
    }
    else
    {
        cell.imageView.image = [UIImage imageNamed:@"ProfileImage_PlaceHolder"];
        
        __weak MasterViewController *weakSelf = self;
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSURL *imageURL = [NSURL URLWithString:userDictionary[@"profile_image_url"]];
            
            dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
                
                [weakSelf.imageCache setObject:[UIImage imageWithData:imageData] forKey:userDictionary[@"id"]];
                
                dispatch_sync(dispatch_get_main_queue(), ^{
                    cell.imageView.image = [weakSelf.imageCache objectForKey:userDictionary[@"id"]];
                });
            });
        });
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tweetsArray count];
}

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refreshPearsonFeed) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    
    [self getTwitterAccount];
}





@end
