//
//  Tweet.m
//  JSRestNetworkKitSampleProject
//
//  Created by Javier Soto on 5/6/12.
//  Copyright (c) 2012 JavierSoto. All rights reserved.
//

#import "Tweet.h"

@implementation Tweet

- (NSArray *)entityProperties
{
    static NSMutableArray *entityProperties = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
//        [entityProperties addObject:[JSEntityProperty entity
    });
    
    return entityProperties;
}

@end
