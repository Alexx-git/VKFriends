//
//  FriendsViewController.m
//  VKFriends
//
//  Created by VLADIMIR on 2/8/18.
//  Copyright © 2018 ALEXANDER. All rights reserved.
//

#import "FriendsViewController.h"
#import "DataManager.h"
#import "AppDelegate+VKAuthorization.h"
#import "FriendTableViewCell.h"

typedef NS_ENUM(NSUInteger, LoadingStatus)
{
    LoadingUnknown,
    LoadingInProcess,
    LoadingSuccess,
    LoadingFailure,
};


@interface FriendsViewController ()

@property (assign, nonatomic) BOOL authorized;

@property (strong, nonatomic) NSArray * friends;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

static LoadingStatus loadingStatus = LoadingUnknown;
static NSString * const reuseIdentifier = @"FriendsTableViewCell";


@implementation FriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated
{
    AppDelegate * appDelegate = [AppDelegate appDelegate];
    [appDelegate startVK];
    [super viewWillAppear:animated];
    VKAuthorizationState authState = [AppDelegate authState];
    if (authState == VKAuthorizationAuthorized)
    {
        [self updateData];
    } else
    {
        NSNotificationCenter * notificationCenter = [NSNotificationCenter defaultCenter];
        [notificationCenter addObserver:self selector:@selector(didReceiveVKAuthSuccessNotification:) name:kVKAuthSuscessNotification object:nil];
    }
    //[self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:reuseIdentifier];
}

-(void)viewWillDisappear:(BOOL)animated
{
    NSNotificationCenter * notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter removeObserver:self];
    [super viewWillDisappear:animated];
}

-(void)didReceiveVKAuthSuccessNotification:(NSNotification *)notification
{
    [self loadData];
}


-(void)loadData {
    loadingStatus = LoadingInProcess;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[DataManager sharedInstance] loadFriendsWithCompletion:^(VKResponse * response) {
            loadingStatus = LoadingSuccess;
            self.friends = ((VKUsersArray *)response.parsedModel).items;
            [self updateData];
        }];
    });
}

-(void)updateData
{
    [self.tableView reloadData];

}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    [VKSdk processOpenURL:url fromApplication:sourceApplication];
    
    return YES;
}


#pragma mark - UITableViewDelegate methods

#pragma mark - UITableViewDataSource methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.friends.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    FriendTableViewCell * cell = [self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    VKUser * friend = self.friends[indexPath.row];
    NSURL * photoURL = [NSURL URLWithString:friend.photo_100];
    [cell.photoView sd_setImageWithURL:photoURL];
    cell.nameLabel.text = [NSString stringWithFormat:@"%@ %@", friend.first_name, friend.last_name];
    return cell;
}


@end
