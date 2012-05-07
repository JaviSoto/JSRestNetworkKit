//
//  TwitterResponseParser.m
//  JSRestNetworkKitSampleProject
//
//  Created by Javier Soto on 5/6/12.
//  Copyright (c) 2012 JavierSoto. All rights reserved.
//

#import "TwitterResponseParser.h"

@implementation TwitterResponseParser

- (BOOL)responseIsSuccessfulWithDictionary:(NSDictionary *)dictionary
{
    return (dictionary != nil);
}

- (id)dataFromResponseDictionary:(NSDictionary *)dictionary
{
    return [dictionary valueForKey:@"results"];
}

@end
