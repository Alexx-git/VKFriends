//
//  DataManager.h
//  VKFriends
//
//  Created by VLADIMIR on 2/8/18.
//  Copyright © 2018 ALEXANDER. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VKSdk.h"

@interface DataManager : NSObject

+(DataManager *)sharedInstance;
-(void)loadFriendsWithCompletion:(void (^)(VKResponse * vkResponse))completeion;

@end
