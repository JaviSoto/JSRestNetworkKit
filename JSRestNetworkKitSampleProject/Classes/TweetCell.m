//
//  TweetCell.m
//  JSRestNetworkKitSampleProject
//
//  Created by Javier Soto on 5/6/12.
//  Copyright (c) 2012 JavierSoto. All rights reserved.
//

#import "TweetCell.h"

#import "UIImageView+AFNetworkingJSAdditions.h"

#import "Tweet.h"
#import "TwitterUser.h"

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
    [self.userAvatar setImageWithURL:tweet.user.avatarURL];
    self.username.text = [NSString stringWithFormat:@"@%@", tweet.user.screenName]  ;
    self.tweetText.text = tweet.text;
}

- (void)dealloc {
    [userAvatar release];
    [username release];
    [tweetText release];
    
    [super dealloc];
}
@end
