//
//  NSString+RandomValues.m
//  JSRestNetworkKitSampleProject
//
//  Created by Javier Soto on 4/8/12.
//  Copyright (c) 2012 MindSnacks. All rights reserved.
//

#import "NSString+RandomValues.h"

#import "NSNumber+RandomValues.h"

@implementation NSString (RandomValues)

+ (NSString *)randomStringWithLength:(int)length
{
    static NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    
    NSMutableString *randomString = [NSMutableString stringWithCapacity:length];
    
    for (int i = 0; i < length; i++) {
        [randomString appendFormat: @"%c", [letters characterAtIndex: arc4random()%letters.length]];
    }
    
    return randomString;
}

+ (NSString *)randomStringWithLengthBetween:(int)minLength and:(int)maxLength
{
    return [self randomStringWithLength:[NSNumber randomIntBetweenNumber:minLength andNumber:maxLength]];
}

@end
