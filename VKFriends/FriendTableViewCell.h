//
//  FriendTableViewCell.h
//  VKFriends
//
//  Created by VLADIMIR on 2/10/18.
//  Copyright © 2018 ALEXANDER. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface FriendTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *photoView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end
