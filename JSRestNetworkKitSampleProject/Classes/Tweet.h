//
//  Tweet.h
//  JSRestNetworkKitSampleProject
//
//  Created by Javier Soto on 5/6/12.
//  Copyright (c) 2012 JavierSoto. All rights reserved.
//

@class TwitterUser;

@interface Tweet : JSBaseEntity

@property (nonatomic, retain) TwitterUser *user;
@property (nonatomic, copy) NSString *text;

@end
