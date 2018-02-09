//
//  LoginViewController.m
//  VKFriends
//
//  Created by VLADIMIR on 2/8/18.
//  Copyright © 2018 ALEXANDER. All rights reserved.
//

#import "LoginViewController.h"
#import "VKSdk.h"

static NSString *const TOKEN_KEY = @"my_application_access_token";
//static NSString *const NEXT_CONTROLLER_SEGUE_ID = @"START_WORK";
static NSArray *SCOPE = nil;

@interface LoginViewController ()<VKSdkDelegate, VKSdkUIDelegate>

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    SCOPE = @[VK_PER_FRIENDS, VK_PER_WALL, VK_PER_AUDIO, VK_PER_PHOTOS, VK_PER_NOHTTPS, VK_PER_EMAIL, VK_PER_MESSAGES];
    [[VKSdk initializeWithAppId:@"6365157"] registerDelegate:self];
    [[VKSdk instance] setUiDelegate:self];
    [VKSdk wakeUpSession:SCOPE completeBlock:^(VKAuthorizationState state, NSError *error) {
        if (state == VKAuthorizationAuthorized) {
            //[self startWorking];
        } else if (error) {
            
            

            
            [[[UIAlertView alloc] initWithTitle:nil message:[error description] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
        }
        else{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                 [VKSdk authorize:SCOPE];
            });
           
        }
    }];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    [VKSdk processOpenURL:url fromApplication:sourceApplication];
    
    return YES;
}

- (void)vkSdkAccessAuthorizationFinishedWithResult:(VKAuthorizationResult *)result {
    if (result.token) {
        //[self startWorking];
    } else if (result.error) {
        [[[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"Access denied\n%@", result.error] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
    }
}

- (void)vkSdkUserAuthorizationFailed {
    [[[UIAlertView alloc] initWithTitle:nil message:@"Access denied" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
    //[self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)vkSdkShouldPresentViewController:(UIViewController *)controller {
    // [self.navigationController.topViewController presentViewController:controller animated:YES completion:nil];
    [self presentViewController:controller animated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
