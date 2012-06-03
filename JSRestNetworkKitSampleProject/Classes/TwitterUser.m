//
//  TwitterUser.m
//  JSRestNetworkKitSampleProject
//
//  Created by Javier Soto on 5/13/12.
//  Copyright (c) 2012 JavierSoto. All rights reserved.
//

#import "TwitterUser.h"
#import "Tweet.h"

@implementation TwitterUser

@synthesize userID = _userID,
            name = _name,
            avatarURL = _avatarURL,
            followers = _followers,
            tweets = _tweets;

+ (NSArray *)entityProperties
{
    static NSMutableArray *entityProperties = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        entityProperties = [[NSMutableArray alloc] init];
        
        [entityProperties addObject:[JSEntityProperty entityPropertyWithApiKey:@"id" andLocalKey:@"userID" propertyType:JSEntityPropertyTypeString]];
        [entityProperties addObject:[JSEntityProperty entityPropertyWithKey:@"name" propertyType:JSEntityPropertyTypeString]];
        [entityProperties addObject:[JSEntityProperty entityPropertyWithApiKey:@"screen_name" andLocalKey:@"screenName" propertyType:JSEntityPropertyTypeString]];
        [entityProperties addObject:[JSEntityProperty entityPropertyWithApiKey:@"profile_image_url" andLocalKey:@"avatarURL" propertyType:JSEntityPropertyTypeURL]];
        [entityProperties addObject:[JSEntityProperty entityPropertyWithApiKey:@"followers_count" andLocalKey:@"followers" propertyType:JSEntityPropertyTypeInt]];
        [entityProperties addObject:[JSEntityProperty entityPropertyWithApiKey:@"statuses_count" andLocalKey:@"tweets" propertyType:JSEntityPropertyTypeInt]];
    });
    
    return entityProperties;
}

- (void)dealloc
{
    [_userID release];
    [_name release];
    [_screenName release];
    [_avatarURL release];
    
    [super dealloc];
}

@end
