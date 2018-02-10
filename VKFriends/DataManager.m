//
//  DataManager.m
//  VKFriends
//
//  Created by VLADIMIR on 2/8/18.
//  Copyright © 2018 ALEXANDER. All rights reserved.
//

#import "DataManager.h"

static NSString *const ALL_USER_FIELDS = @"id,first_name,last_name,sex,bdate,city,country,photo_50,photo_100,photo_200_orig,photo_200,photo_400_orig,photo_max,photo_max_orig,online,online_mobile,lists,domain,has_mobile,contacts,connections,site,education,universities,schools,can_post,can_see_all_posts,can_see_audio,can_write_private_message,status,last_seen,common_count,relation,relatives,counters";

@implementation DataManager

+(DataManager *)sharedInstance
{
    static dispatch_once_t predicate;
    static DataManager *sharedInstance = nil;
    
    dispatch_once(&predicate, ^{
        sharedInstance = [DataManager new];
    });
    
    return sharedInstance;
}

-(void)loadFriendsWithCompletion:(void (^)(VKResponse * vkResponse))completion
{
	VKRequest *friendsRequest = [[VKApi friends] get:@{VK_API_FIELDS : ALL_USER_FIELDS}];
	[friendsRequest executeWithResultBlock:^(VKResponse *response) {
        completion(response);
	}                                errorBlock:^(NSError *error) {
		NSLog(@"error:%@", error);
	}];
}


@end
