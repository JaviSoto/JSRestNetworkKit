//
//  TweetsViewController.m
//  JSRestNetworkKitSampleProject
//
//  Created by Javier Soto on 5/6/12.
//  Copyright (c) 2012 JavierSoto. All rights reserved.
//

#import "TweetsViewController.h"

#import "TweetCell.h"

#import "TwitterRequestManager.h"

@interface TweetsViewController () <UITableViewDelegate, UITableViewDataSource>
{
    TwitterRequestManager *_twitterReqManager;
}

@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, retain) UINib *cellNib;
@property (nonatomic, retain) NSArray *tweets;
@end

@implementation TweetsViewController

@synthesize tableView = _tableView;
@synthesize cellNib = _cellNib;

@synthesize tweets = _tweets;

- (id)init
{
    if ((self = [super init]))
    {
        _twitterReqManager = [[TwitterRequestManager alloc] init];
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
        
    }];
}

#pragma mark - Table View Methods

- (NSInteger)tableView:(UITableView *)tableview numberOfRowsInSection:(NSInteger)section
{
    return self.tweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"TweetCell";
    
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell)
    {
        cell = [[self.cellNib instantiateWithOwner:self options:nil] objectAtIndex:0];
    }
    
    [cell setTweet:[self.tweets objectAtIndex:indexPath.row]];
    
    return cell;
}

#pragma mark - Memory management
                
- (UINib *)cellNib
{
    if (!_cellNib)
    {
        _cellNib = [[UINib nibWithNibName:NSStringFromClass([TweetCell class]) bundle:nil] retain];
    }
    
    return _cellNib;
}

- (void)dealloc
{
    [_cellNib release];
    [_twitterReqManager release];
    [_tweets release];
    
    [_tableView release];
    [super dealloc];
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [super viewDidUnload];
}
@end
