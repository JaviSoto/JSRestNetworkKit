//
//  NSDate+RandomValues.m
//  JSRestNetworkKitSampleProject
//
//  Created by Javier Soto on 4/8/12.
//  Copyright (c) 2012 MindSnacks. All rights reserved.
//

#import "NSDate+RandomValues.h"

#import "NSNumber+RandomValues.h"

@implementation NSDate (RandomValues)

+ (NSDate *)randomPastDate
{
    return [NSDate dateWithTimeIntervalSinceNow:[NSNumber randomIntBetweenNumber:0 andNumber:10000]];
}

+ (NSTimeInterval)randomUnixTimeOfPastDate
{
    return [[self randomPastDate] timeIntervalSince1970];
}

@end
