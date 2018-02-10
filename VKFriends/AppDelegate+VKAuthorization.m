//
//  AppDelegate+VKAuthorization.m
//  VKFriends
//
//  Created by VLADIMIR on 2/10/18.
//  Copyright © 2018 ALEXANDER. All rights reserved.
//

#import "AppDelegate+VKAuthorization.h"
#import "DataManager.h"


@interface AppDelegate (VKAuthorization)<VKSdkDelegate, VKSdkUIDelegate>

@end

static NSString *const TOKEN_KEY = @"my_application_access_token";
//static NSString *const NEXT_CONTROLLER_SEGUE_ID = @"START_WORK";
static NSArray *SCOPE = nil;
static VKAuthorizationState authState = VKAuthorizationUnknown;
NSString * const kVKAuthSuscessNotification = @"Authorization finished with success";


@implementation AppDelegate (VKAuthorization)

+(AppDelegate *)appDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

+(VKAuthorizationState)authState
{
    return authState;
}

-(void)startVK
{
    authState = VKAuthorizationUnknown;
    SCOPE = @[VK_PER_FRIENDS, VK_PER_WALL, VK_PER_AUDIO, VK_PER_PHOTOS, VK_PER_NOHTTPS, VK_PER_EMAIL, VK_PER_MESSAGES];
    [[VKSdk initializeWithAppId:@"6365157"] registerDelegate:self];
    [[VKSdk instance] setUiDelegate:self];
    [VKSdk wakeUpSession:SCOPE completeBlock:^(VKAuthorizationState state, NSError *error) {
        if (state == VKAuthorizationAuthorized) {
            authState = VKAuthorizationAuthorized;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                NSNotificationCenter * notificationCenter = [NSNotificationCenter defaultCenter];
                [notificationCenter postNotificationName:kVKAuthSuscessNotification object:nil];
            });
            
        }
        else if (error) {
            [[[UIAlertView alloc] initWithTitle:nil message:[error description] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
            authState = VKAuthorizationError;
        }
        else{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [VKSdk authorize:SCOPE];
            });
            
        }
    }];
}

- (void)vkSdkAccessAuthorizationFinishedWithResult:(VKAuthorizationResult *)result {
    if (result.token) {
        NSNotificationCenter * notificationCenter = [NSNotificationCenter defaultCenter];
        [notificationCenter postNotificationName:kVKAuthSuscessNotification object:nil];
    } else if (result.error) {
        [[[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"Access denied\n%@", result.error] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
    }
}

- (void)vkSdkUserAuthorizationFailed {
    [[[UIAlertView alloc] initWithTitle:nil message:@"Access denied" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
    //[self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)vkSdkShouldPresentViewController:(UIViewController *)controller {
    //[self.navigationController.topViewController presentViewController:controller animated:YES completion:nil];
    //[self presentViewController:controller animated:YES completion:nil];
    [self.window.rootViewController presentViewController:controller animated:YES completion:nil];
}

@end
