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

#import "JSEntityPropertyURL.h"

#import "NSNumber+JSRandomValues.h"

@implementation JSEntityPropertyURL

- (id)parsedValueForObject:(id)object inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    if ([object isEqual:[NSNull null]] || ![object isKindOfClass:[NSString class]] || [object length] == 0)
    {
        return nil;
    }
    
    return [NSURL URLWithString:[object stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
}

- (id)randomValueWithDepth:(NSInteger)depth
{
    NSArray *imageURLs = [NSArray arrayWithObjects:@"http://4.bp.blogspot.com/-IT5XaPP7_a0/To76ESXwMNI/AAAAAAAACd0/J2GIcOP8pkw/s72-c/steve-jobs.jpg", @"http://static.mobile.macworld.nl/thumbnails/72x72/e/f/ef6193e235005946ce68b8c92f881388.jpg", @"http://4.bp.blogspot.com/_UYjuChp11yY/S5Zio-tMKLI/AAAAAAAAALI/xw3P79ekdZw/s72-c/steve_ballmer.jpg", @"http://img.thoughts.com/3axt3dk00iaz471.gif", nil];
    
    return [[imageURLs objectAtIndex:[NSNumber randomIntBetweenNumber:0 andNumber:imageURLs.count-1]] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (BOOL)needsRelease
{
    return YES;
}

@end
