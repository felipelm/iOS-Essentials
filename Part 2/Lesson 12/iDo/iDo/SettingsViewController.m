//
//  SettingsViewController.m
//  iDo
//
//  Created by Recording on 1/4/13.
//  Copyright (c) 2013 Felipe Laso Marsetti. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController () <MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate, UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *actionButton;
@property (weak, nonatomic) IBOutlet UIButton *facebookButton;
@property (weak, nonatomic) IBOutlet UIButton *settingsButton;
@property (weak, nonatomic) IBOutlet UIView *tintColorView;
@property (weak, nonatomic) IBOutlet UIButton *twitterButton;

@end

@implementation SettingsViewController

#pragma mark - Action Sheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:
            [self presentEmailComposer];
            break;
            
        case 1:
            [self presentMessageComposer];
            break;
            
        default:
            break;
    }
}

#pragma mark - IBActions

- (IBAction)actionTapped:(UIBarButtonItem *)actionButton
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Share Via"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Email", @"Message", nil];
    [actionSheet showFromBarButtonItem:actionButton animated:YES];
}

- (IBAction)doneTapped
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)facebookTapped
{
    [self presentComposeViewControllerForServiceType:SLServiceTypeFacebook];
}

- (IBAction)twitterTapped
{
    [self presentComposeViewControllerForServiceType:SLServiceTypeTwitter];
}

#pragma mark - Mail Compose View Controller Delegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    if (result == MFMailComposeResultFailed)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
    else if (result == MFMailComposeResultSent)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Success"
                                                            message:@"Your email was sent successfully"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Message Compose View Controller Delegate

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    if (result == MessageComposeResultFailed)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"Your message could not be sent. Please check your settings and connection and try again."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
    else if (result == MessageComposeResultSent)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Success"
                                                            message:@"Your message was sent successfully!"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Private Methods

- (void)presentComposeViewControllerForServiceType:(NSString *)serviceType
{
    NSString *serviceName = @"the service";
    
    if ([serviceType isEqual:SLServiceTypeFacebook])
    {
        serviceName = @"Facebook";
    }
    else if ([serviceType isEqual:SLServiceTypeTwitter])
    {
        serviceName = @"Twitter";
    }
    
    if ([SLComposeViewController isAvailableForServiceType:serviceType])
    {
        SLComposeViewController *socialSheet = [SLComposeViewController composeViewControllerForServiceType:serviceType];
        [socialSheet setInitialText:@"Check out this great App to handle your to-do lists: iDo!"];
        [socialSheet addURL:[NSURL URLWithString:@"http://ife.li"]];
        [socialSheet addImage:[UIImage imageNamed:@"ShareImage"]];
        [socialSheet setCompletionHandler:^(SLComposeViewControllerResult result){
            if (result == SLComposeViewControllerResultDone)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSString *message = [NSString stringWithFormat:@"Your post has been sent to %@", serviceName];
                    
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Success"
                                                                        message:message
                                                                       delegate:nil
                                                              cancelButtonTitle:@"OK"
                                                              otherButtonTitles:nil];
                    [alertView show];
                });
            }
        }];
        
        [self presentViewController:socialSheet animated:YES completion:nil];
    }
    else
    {
        NSString *message = [NSString stringWithFormat:@"Cannot post to %@, please make sure you have add an account in the Settings app and that iDo has been given access.", serviceName];
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:message
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
}

- (void)presentEmailComposer
{
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailComposerViewController = [[MFMailComposeViewController alloc] init];
        mailComposerViewController.mailComposeDelegate = self;
        [mailComposerViewController setSubject:@"Check out the iDo App!"];
        [mailComposerViewController setMessageBody:@"Hey,\n\nDownload the awesome iDo app to help you manage your to-do lists!" isHTML:NO];
        
        [self presentViewController:mailComposerViewController animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"Cannot share via email. Make sure you have at least one account setup in the Settings app."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
}

- (void)presentMessageComposer
{
    if ([MFMessageComposeViewController canSendText])
    {
        MFMessageComposeViewController *messageComposeViewController = [[MFMessageComposeViewController alloc] init];
        messageComposeViewController.messageComposeDelegate = self;
        [messageComposeViewController setBody:@"Download the awesome iDo app to help you manage your to-do lists!"];
        [self presentViewController:messageComposeViewController animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"Cannot share via messages. Make sure you have iMessage configured or that SMS is supported by your carrier"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
}

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ListBackground"]];
    
    self.facebookButton.layer.cornerRadius = 7;
    self.settingsButton.layer.cornerRadius = 7;
    self.twitterButton.layer.cornerRadius = 7;
    
    self.actionButton.accessibilityHint = @"Share about iDo via email or message";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.navigationController.navigationBar.tintColor)
    {
        self.tintColorView.backgroundColor = self.navigationController.navigationBar.tintColor;
    }
}

@end
