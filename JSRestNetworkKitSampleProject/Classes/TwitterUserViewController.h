//
//  TwitterUserViewController.h
//  JSRestNetworkKitSampleProject
//
//  Created by Javier Soto on 5/13/12.
//  Copyright (c) 2012 JavierSoto. All rights reserved.
//

@class TwitterUser;
@class TwitterRequestManager;

@interface TwitterUserViewController : UIViewController

- (id)initWithUser:(TwitterUser *)user
    requestManager:(TwitterRequestManager *)requestManager;

@property (nonatomic, retain, readonly) TwitterUser *user;

@end
