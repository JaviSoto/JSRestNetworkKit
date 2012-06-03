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
            screenName = _screenName,
            avatarURL = _avatarURL,
            followers = _followers,
            tweets = _tweets;

+ (NSArray *)entityProperties
{
    static NSMutableArray *entityProperties = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        entityProperties = [[NSMutableArray alloc] init];
        
        [entityProperties addObject:[JSEntityProperty entityPropertyWithAPIKeyPath:@"id" entityPropertyKey:@"userID" propertyType:JSEntityPropertyTypeString]];
        [entityProperties addObject:[JSEntityProperty entityPropertyWithKey:@"name" propertyType:JSEntityPropertyTypeString]];
        [entityProperties addObject:[JSEntityProperty entityPropertyWithAPIKeyPath:@"screen_name" entityPropertyKey:@"screenName" propertyType:JSEntityPropertyTypeString]];
        [entityProperties addObject:[JSEntityProperty entityPropertyWithAPIKeyPath:@"profile_image_url" entityPropertyKey:@"avatarURL" propertyType:JSEntityPropertyTypeURL]];
        [entityProperties addObject:[JSEntityProperty entityPropertyWithAPIKeyPath:@"followers_count" entityPropertyKey:@"followers" propertyType:JSEntityPropertyTypeInt]];
        [entityProperties addObject:[JSEntityProperty entityPropertyWithAPIKeyPath:@"statuses_count" entityPropertyKey:@"tweets" propertyType:JSEntityPropertyTypeInt]];
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
