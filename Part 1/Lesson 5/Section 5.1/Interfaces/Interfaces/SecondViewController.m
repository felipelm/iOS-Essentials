//
//  SecondViewController.m
//  Interfaces
//
//  Created by Felipe on 11/25/12.
//  Copyright (c) 2012 Felipe Laso Marsetti. All rights reserved.
//

#import "CustomCell.h"
#import "SecondViewController.h"

@interface SecondViewController ()

@property (strong, nonatomic) UINib *cellNib;

@end

@implementation SecondViewController

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomCell *customCell = [self.tableView dequeueReusableCellWithIdentifier:@"CustomCell"];
    
    customCell.titleLabel.text = [NSString stringWithFormat:@"Row #%d", indexPath.row + 1];
    customCell.subtitleLabel.text = [NSString stringWithFormat:@"Index Path Row #%d", indexPath.row];
    
    return customCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self performSegueWithIdentifier:@"PushSegue" sender:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.cellNib = [UINib nibWithNibName:@"CustomCell" bundle:nil];
    
    [self.tableView registerNib:self.cellNib forCellReuseIdentifier:@"CustomCell"];
}

@end
