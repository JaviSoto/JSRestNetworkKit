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

#import "EntityPropertyFloat.h"

#import "NSNumber+RandomValues.h"

@implementation EntityPropertyFloat

- (id)parsedValueForObject:(id)object inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    if (![object respondsToSelector:@selector(floatValue)])
    {
        return [NSNumber numberWithFloat:0];
    }
    
    return [NSNumber numberWithFloat:[object floatValue]];
}

- (id)randomValueWithDepth:(NSInteger)depth
{
    static const int maxWholeNumber = 20;
    
    float number1 = [NSNumber randomIntBetweenNumber:0 andNumber:maxWholeNumber * 200];
    float number2 = number1 - (maxWholeNumber * 100);
    float number3 = number2 / 100.0;
    return [NSNumber numberWithFloat:number3];
}

@end
