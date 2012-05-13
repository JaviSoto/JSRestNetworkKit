//
//  TwitterUser.h
//  JSRestNetworkKitSampleProject
//
//  Created by Javier Soto on 5/13/12.
//  Copyright (c) 2012 JavierSoto. All rights reserved.
//

@class Tweet;

@interface TwitterUser : JSBaseEntity

@property (nonatomic, copy) NSString *userID;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *screenName;
@property (nonatomic, copy) NSURL *avatarURL;
@property (nonatomic, assign) NSUInteger followers;
@property (nonatomic, assign) NSUInteger tweets;

@end
