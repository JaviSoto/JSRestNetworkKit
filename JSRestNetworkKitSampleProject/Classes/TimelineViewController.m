//
//  TweetsViewController.m
//  JSRestNetworkKitSampleProject
//
//  Created by Javier Soto on 5/6/12.
//  Copyright (c) 2012 JavierSoto. All rights reserved.
//

#import "TimelineViewController.h"

#import "TweetCell.h"
#import "TwitterUserViewController.h"

#import "TwitterRequestManager.h"
#import "Tweet.h"

@interface TimelineViewController () <UITableViewDelegate, UITableViewDataSource>
{
    TwitterRequestManager *_twitterReqManager;
}

@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, retain) UINib *cellNib;
@property (nonatomic, retain) NSArray *tweets;
@end

@implementation TimelineViewController

@synthesize tableView = _tableView;
@synthesize cellNib = _cellNib;

@synthesize tweets = _tweets;

- (id)init
{
    if ((self = [super init]))
    {
        _twitterReqManager = [[TwitterRequestManager alloc] init];
        
        self.title = @"Timeline";
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self loadTweets];
}

#pragma mark - Loading

- (void)loadTweets
{
    [_twitterReqManager requestTimelineWithSuccessCallback:^(id data, BOOL cached) {
        self.tweets = data;
        [self.tableView reloadData];
    } errorCallback:^{
        [[[[UIAlertView alloc] initWithTitle:@"Error" message:@"Error loading tweets" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
    }];
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
    
    TwitterUserViewController *userVC = [[TwitterUserViewController alloc] initWithUser:tweet.user requestManager:_twitterReqManager];
    [self.navigationController pushViewController:userVC animated:YES];
    [userVC release];
}

#pragma mark - Memory management
                
- (UINib *)cellNib
{
    if (!_cellNib)
        _cellNib = [[UINib nibWithNibName:NSStringFromClass([TweetCell class]) bundle:nil] retain];
    
    return _cellNib;
}

- (void)viewDidUnload {
    self.tableView = nil;
    self.cellNib = nil;
    
    [super viewDidUnload];
}

- (void)dealloc
{
    [_cellNib release];
    [_twitterReqManager release];
    [_tweets release];
    [_tableView release];
    
    [super dealloc];
}

@end
