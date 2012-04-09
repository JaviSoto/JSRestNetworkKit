/* 
 Copyright 2012 Javier Soto (ios@javisoto.es)
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License. 
 */

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
