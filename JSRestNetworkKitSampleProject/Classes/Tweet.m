//
//  Tweet.m
//  JSRestNetworkKitSampleProject
//
//  Created by Javier Soto on 5/6/12.
//  Copyright (c) 2012 JavierSoto. All rights reserved.
//

#import "Tweet.h"

@implementation Tweet

+ (NSArray *)entityProperties
{
    static NSMutableArray *entityProperties = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        entityProperties = [[NSMutableArray alloc] init];
        
        [entityProperties addObject:[JSEntityProperty entityPropertyWithApiKey:@"from_user_name" andLocalKey:@"username" propertyType:JSEntityPropertyTypeString]];
        [entityProperties addObject:[JSEntityProperty entityPropertyWithKey:@"text" propertyType:JSEntityPropertyTypeString]];
        [entityProperties addObject:[JSEntityProperty entityPropertyWithApiKey:@"profile_image_url" andLocalKey:@"profileImageURL" propertyType:JSEntityPropertyTypeURL]];
    });
    
    return entityProperties;
}

@end
