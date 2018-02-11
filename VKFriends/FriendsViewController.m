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
    LoadingNone,
    LoadingInProcess,
    LoadingSuccess,
    LoadingFailure,
};


@interface FriendsViewController ()

@property (strong, nonatomic) NSArray * friends;
@property (assign, nonatomic) LoadingStatus loadingStatus;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *signOutButton;

@end

static NSString * const reuseIdentifier = @"FriendsTableViewCell";

@implementation FriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.loadingStatus = LoadingNone;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self vkAuthorization];
    NSNotificationCenter * notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(didReceiveVKAuthClearNotification:) name:kVKAuthClearNotification object:nil];
    [super viewWillAppear:animated];
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
    [self showSignOutButton];
}

-(void)didReceiveVKAuthClearNotification:(NSNotification *)notification
{
    [self resetAuth];
}



-(void)loadData {
    self.loadingStatus = LoadingInProcess;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[DataManager sharedInstance] loadFriendsWithCompletion:^(VKResponse * response) {
            self.loadingStatus = LoadingSuccess;
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
    NSURL * photoURL = [NSURL URLWithString:friend.photo_max];
    
    [cell.photoView sd_setImageWithURL:photoURL];
    cell.nameLabel.text = [NSString stringWithFormat:@"%@ %@", friend.first_name, friend.last_name];
    return cell;
}

- (IBAction)signOutButtonPressed:(id)sender
{
    [VKSdk forceLogout];
    [self resetAuth];
}

-(void)vkAuthorization
{
    AppDelegate * appDelegate = [AppDelegate appDelegate];
    [appDelegate startVK];
    VKAuthorizationState authState = [AppDelegate authState];
    if (self.loadingStatus == LoadingNone)
    {
        if (authState == VKAuthorizationAuthorized)
        {
            [self updateData];
        }
        else
        {
            NSNotificationCenter * notificationCenter = [NSNotificationCenter defaultCenter];
            [notificationCenter addObserver:self selector:@selector(didReceiveVKAuthSuccessNotification:) name:kVKAuthSuccessNotification object:nil];
        }
    }
}

-(void)hideSignOutButton
{
    self.signOutButton = self.navigationItem.rightBarButtonItem;
    self.navigationItem.rightBarButtonItem = nil;
    [self.view setNeedsDisplay];
}

-(void)showSignOutButton
{
    self.navigationItem.rightBarButtonItem = self.signOutButton;
    [self.view setNeedsDisplay];
}

-(void)resetAuth
{
    
    [self hideSignOutButton];
    self.friends = nil;
    [self updateData];
    [self vkAuthorization];
}



@end
