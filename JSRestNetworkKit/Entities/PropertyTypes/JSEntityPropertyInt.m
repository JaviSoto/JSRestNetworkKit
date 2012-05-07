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

#import "JSEntityPropertyInt.h"

#import "NSNumber+RandomValues.h"

#define kJSEntityPropertyIntRandomMinNumber 0
#define kJSEntityPropertyIntRandomMaxNumber 10 

@implementation JSEntityPropertyInt

- (id)parsedValueForObject:(id)object inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    if (![object respondsToSelector:@selector(intValue)])
    {
        return [NSNumber numberWithInt:0];
    }
    
    return [NSNumber numberWithInt:[object intValue]];
}

- (id)randomValueWithDepth:(NSInteger)depth
{
    return [NSNumber randomNumberBetweenNumber:kJSEntityPropertyIntRandomMinNumber andNumber:kJSEntityPropertyIntRandomMaxNumber];
}

@end
