//
//  AppDelegate+VKAuthorization.h
//  VKFriends
//
//  Created by VLADIMIR on 2/10/18.
//  Copyright © 2018 ALEXANDER. All rights reserved.
//

#import "AppDelegate.h"
#import "VKSdk.h"

extern NSString * const kVKAuthSuscessNotification;

@interface AppDelegate (VKAuthorization)<VKSdkDelegate, VKSdkUIDelegate>

+(AppDelegate *)appDelegate;
+(VKAuthorizationState)authState;
-(void)startVK;

@end
