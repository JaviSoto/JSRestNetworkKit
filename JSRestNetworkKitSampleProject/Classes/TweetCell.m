//
//  TweetCell.m
//  JSRestNetworkKitSampleProject
//
//  Created by Javier Soto on 5/6/12.
//  Copyright (c) 2012 JavierSoto. All rights reserved.
//

#import "TweetCell.h"

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
    
}

- (void)dealloc {
    [userAvatar release];
    [username release];
    [tweetText release];
    
    [super dealloc];
}
@end
