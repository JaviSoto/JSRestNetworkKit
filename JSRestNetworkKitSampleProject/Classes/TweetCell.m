//
//  TweetCell.m
//  JSRestNetworkKitSampleProject
//
//  Created by Javier Soto on 5/6/12.
//  Copyright (c) 2012 JavierSoto. All rights reserved.
//

#import "TweetCell.h"

#import "UIImageView+AFNetworking.h"

#import "Tweet.h"

@interface TweetCell ()
@property (retain, nonatomic) IBOutlet UIImageView *userAvatar;
@property (retain, nonatomic) IBOutlet UILabel *username;
@property (retain, nonatomic) IBOutlet UILabel *tweetText;
@end

@implementation TweetCell
@synthesize userAvatar;
@synthesize username;
@synthesize tweetText;

- (void)setTweet:(Tweet *)tweet
{
    [self.userAvatar setImageWithURL:tweet.profileImageURL];
    self.username.text = tweet.username;
    self.tweetText.text = tweet.text;
}

- (void)dealloc {
    [userAvatar release];
    [username release];
    [tweetText release];
    
    [super dealloc];
}
@end
