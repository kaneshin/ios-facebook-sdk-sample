//
//  KSViewController.m
//  facebook-sdk-sample
//
//  Created by Shintaro Kaneko on 1/28/14.
//  Copyright (c) 2014 kaneshinth.com. All rights reserved.
//

#import "KSViewController.h"

#import "KSFacebookManager.h"

@interface KSViewController ()
- (void)handleFacebookButton;
@end

@implementation KSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0., 0., 200., 40.)];
    button.center = self.view.center;
    [button setBackgroundColor:[UIColor colorWithWhite:.8 alpha:1.]];
    [button setTitle:NSLocalizedString(@"Sign-in with Facebook", nil) forState:UIControlStateNormal];
    [button addTarget:self action:@selector(handleFacebookButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    // refresh session for facebook
    [[KSFacebookManager sharedManager] refreshSessionWithPermission];
}

- (void)handleFacebookButton
{
    if ([KSFacebookManager sharedManager].session.state != FBSessionStateCreated) {
        [[KSFacebookManager sharedManager] refreshSessionWithPermission];
    }
    if (![KSFacebookManager sharedManager].session.isOpen) {
        [[KSFacebookManager sharedManager].session openWithCompletionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
            if (!error) {
                NSString *accessToken = session.accessTokenData.accessToken;
                NSLog(@"%@", accessToken);
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Access Token", nil)
                                                                message:accessToken
                                                               delegate:nil
                                                      cancelButtonTitle:NSLocalizedString(@"Close", nil)
                                                      otherButtonTitles:nil];
                [alert show];
            } else {
                NSLog(@"Failed Facebook: %@", error.description);
            }
        }];
    }
}

@end
