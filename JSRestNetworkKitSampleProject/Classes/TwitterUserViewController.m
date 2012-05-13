//
//  TwitterUserViewController.m
//  JSRestNetworkKitSampleProject
//
//  Created by Javier Soto on 5/13/12.
//  Copyright (c) 2012 JavierSoto. All rights reserved.
//

#import "TwitterUserViewController.h"

#import "TwitterUser.h"
#import "Tweet.h"
#import "TwitterRequestManager.h"

#import "TweetCell.h"

@interface TwitterUserViewController() <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, retain, readwrite) TwitterUser *user;
@property (nonatomic, retain) TwitterRequestManager *requestManager;
@property (nonatomic, retain) NSArray *tweets;

@property (retain, nonatomic) IBOutlet UIImageView *userAvatar;
@property (retain, nonatomic) IBOutlet UILabel *username;
@property (retain, nonatomic) IBOutlet UILabel *followersCount;
@property (retain, nonatomic) IBOutlet UILabel *tweetsCount;
@property (retain, nonatomic) IBOutlet UITableView *tweetsTable;
@property (retain, nonatomic) UINib *cellNib;

- (void)refreshUI;
@end

@implementation TwitterUserViewController
@synthesize userAvatar = _userAvatar;
@synthesize username = _username;
@synthesize followersCount = _followersCount;
@synthesize tweetsCount = _tweetsCount;
@synthesize tweetsTable = _tweetsTable;
@synthesize cellNib = _cellNib;

@synthesize user = _user;
@synthesize requestManager = _requestManager;
@synthesize tweets = _tweets;

- (id)initWithUser:(TwitterUser *)user
    requestManager:(TwitterRequestManager *)requestManager
{
    if ((self = [super init]))
    {
        self.user = user;
        self.requestManager = requestManager;
        
        self.title = self.user.name;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self refreshUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.requestManager requestUser:self.user successCallback:^(id data, BOOL cached) {
        [self refreshUI];
    } errorCallback:^{
        [[[[UIAlertView alloc] initWithTitle:@"Error" message:@"Error loading User" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
    }];
    
    [self.requestManager requestUserTimeline:self.user successCallback:^(id data, BOOL cached) {
        self.tweets = data;
        [self.tweetsTable reloadData];
    } errorCallback:^{
        [[[[UIAlertView alloc] initWithTitle:@"Error" message:@"Error loading Tweets" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
    }];
}

- (void)refreshUI
{
    [self.userAvatar setImageWithURL:self.user.avatarURL];
    self.username.text = self.user.name;
    self.followersCount.text = [NSString stringWithFormat:@"%d followers", self.user.followers];
    self.tweetsCount.text = [NSString stringWithFormat:@"%d tweets", self.user.tweets];
}

#pragma mark - Table View Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"TweetCell";
    
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell)
        cell = [[self.cellNib instantiateWithOwner:self options:nil] objectAtIndex:0];
    
    [cell setTweet:[self.tweets objectAtIndex:indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Tweet *tweet = [self.tweets objectAtIndex:indexPath.row];
    
    TwitterUserViewController *userVC = [[TwitterUserViewController alloc] initWithUser:tweet.user requestManager:self.requestManager];
    [self.navigationController pushViewController:userVC animated:YES];
    [userVC release];
}

#pragma mark - Memory Management

- (UINib *)cellNib
{
    if (!_cellNib)
        _cellNib = [[UINib nibWithNibName:NSStringFromClass([TweetCell class]) bundle:nil] retain];
    
    return _cellNib;
}

- (void)viewDidUnload
{
    [self setUserAvatar:nil];
    [self setUsername:nil];
    [self setFollowersCount:nil];
    [self setTweetsTable:nil];
    [self setCellNib:nil];
    
    [self setTweetsCount:nil];
    [super viewDidUnload];
}

- (void)dealloc
{
    [_user release];
    [_requestManager release];
    [_tweets release];
    
    [_userAvatar release];
    [_username release];
    [_followersCount release];
    [_tweetsTable release];
    [_cellNib release];
    
    [_tweetsCount release];
    [super dealloc];
}
@end
