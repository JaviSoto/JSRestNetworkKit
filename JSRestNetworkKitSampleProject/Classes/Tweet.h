//
//  Tweet.h
//  JSRestNetworkKitSampleProject
//
//  Created by Javier Soto on 5/6/12.
//  Copyright (c) 2012 JavierSoto. All rights reserved.
//

@interface Tweet : JSBaseEntity

@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSURL *profileImageURL;

@end
