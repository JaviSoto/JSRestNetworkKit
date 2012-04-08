//
//  NSDate+RandomValues.h
//  JSRestNetworkKitSampleProject
//
//  Created by Javier Soto on 4/8/12.
//  Copyright (c) 2012 MindSnacks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (RandomValues)

+ (NSDate *)randomPastDate;
+ (NSTimeInterval)randomUnixTimeOfPastDate;

@end
