//
//  Tweet.m
//  JSRestNetworkKitSampleProject
//
//  Created by Javier Soto on 5/6/12.
//  Copyright (c) 2012 JavierSoto. All rights reserved.
//

#import "Tweet.h"

#import "TwitterUser.h"

@implementation Tweet

@synthesize user = _user,
            text = _text;

+ (NSArray *)entityProperties
{
    static NSMutableArray *entityProperties = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        entityProperties = [[NSMutableArray alloc] init];
        
        [entityProperties addObject:[JSEntityProperty entityPropertyWithKey:@"user" relationClass:[TwitterUser class] propertyType:JSEntityPropertyTypeRelationshipOneToOne]];
        [entityProperties addObject:[JSEntityProperty entityPropertyWithKey:@"text" propertyType:JSEntityPropertyTypeString]];
    });
    
    return entityProperties;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@> %@: %@", NSStringFromClass([self class]), self.user.screenName, self.text];
}

- (void)dealloc
{
    [_user release];
    [_text release];
    
    [super dealloc];
}

@end
