//
//  AppDelegate+VKAuthorization.m
//  VKFriends
//
//  Created by VLADIMIR on 2/10/18.
//  Copyright © 2018 ALEXANDER. All rights reserved.
//

#import "AppDelegate+VKAuthorization.h"
#import "DataManager.h"




static NSString *const TOKEN_KEY = @"my_application_access_token";
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
            [self presentAlertWithMessage:[error description]];
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
        [self presentAlertWithMessage:[NSString stringWithFormat:@"Access denied\n%@", result.error]];
    }
}

- (void)vkSdkUserAuthorizationFailed {
    [self presentAlertWithMessage:@"Access denied"];
}

- (void)vkSdkShouldPresentViewController:(UIViewController *)controller {
    [self.window.rootViewController presentViewController:controller animated:YES completion:nil];
}

- (void)vkSdkNeedCaptchaEnter:(VKError *)captchaError {
    VKCaptchaViewController *vc = [VKCaptchaViewController captchaControllerWithError:captchaError];
    [self.window.rootViewController presentViewController:vc animated:YES completion:nil];
}

-(void)presentAlertWithMessage:(nullable NSString *)message
{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:okAction];
    [self.window.rootViewController presentViewController:alertController animated:YES completion:nil];
}

@end
