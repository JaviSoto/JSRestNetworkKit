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

#import "NSNumber+JSRandomValues.h"

@implementation NSNumber (JSRandomValues)

+ (NSUInteger)randomIntBetweenNumber:(NSUInteger)minNumber andNumber:(NSUInteger)maxNumber
{
    if (minNumber > maxNumber) {
        return [self randomIntBetweenNumber:maxNumber andNumber:minNumber];
    }
    
    NSUInteger i = (arc4random() % (maxNumber - minNumber + 1)) + minNumber;
    return i;
}

+ (NSNumber *)randomNumberBetweenNumber:(NSUInteger)minNumber andNumber:(NSUInteger)maxNumber
{
    return [NSNumber numberWithInt:[self randomIntBetweenNumber:minNumber andNumber:maxNumber]];
}

+ (BOOL)randomBool
{
    return (BOOL)([NSNumber randomIntBetweenNumber:0 andNumber:1] == 1);
}

+ (NSNumber *)randomBoolNumber
{
    return [NSNumber numberWithBool:[self randomBool]];
}

@end
