//
//  DataManager.m
//  VKFriends
//
//  Created by VLADIMIR on 2/8/18.
//  Copyright © 2018 ALEXANDER. All rights reserved.
//

#import "DataManager.h"

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

-(void)loadItems
{
    
}


@end
