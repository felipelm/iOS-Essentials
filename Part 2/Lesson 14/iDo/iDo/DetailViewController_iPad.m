//
//  DetailViewController_iPad.m
//  iDo
//
//  Created by Recording on 4/30/13.
//  Copyright (c) 2013 Felipe Laso Marsetti. All rights reserved.
//

#import "DetailViewController_iPad.h"

@interface DetailViewController_iPad () <UITextFieldDelegate>

@property (strong, nonatomic) id detailObject;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;

@end

@implementation DetailViewController_iPad

#pragma mark - Core List View Controller Delegate

- (void)selectedObject:(id)object
{
    self.detailObject = object;
    
    self.titleTextField.text = [object valueForKey:@"title"];
}

#pragma mark - Private Methods

- (void)viewTapped
{
    if ([self.titleTextField isFirstResponder])
    {
        [self.titleTextField resignFirstResponder];
    }
}

#pragma mark - Text Field Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                           action:@selector(viewTapped)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

@end
