//
//  NSString+RandomValues.h
//  JSRestNetworkKitSampleProject
//
//  Created by Javier Soto on 4/8/12.
//  Copyright (c) 2012 MindSnacks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (RandomValues)

+ (NSString *)randomStringWithLength:(int)length;
+ (NSString *)randomStringWithLengthBetween:(int)minLength and:(int)maxLength;

@end
