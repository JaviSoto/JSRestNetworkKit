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

#import "JSRequestParameters.h"

@implementation JSRequestParameters

@synthesize parametersDictionary = _parametersDictionary;

+ (JSRequestParameters *)emptyRequestParameters
{
    JSRequestParameters *requestParameters = [[JSRequestParameters alloc] init];
    
    return [requestParameters autorelease];
}

- (id)init
{
    if ((self = [super init]))
    {
        _parametersDictionary = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

#pragma mark - NSCoding Methods

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super init]))
    {
        _parametersDictionary = [[aDecoder decodeObjectForKey:@"parametersDictionary"] retain];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.parametersDictionary forKey:@"parametersDictionary"];
}

#pragma mark - Public methods

- (void)setValue:(id)value forKey:(NSString *)parameterName
{
    if (value)
    {
        [_parametersDictionary setValue:value forKey:parameterName];
    }
    else
    {
        NSLog(@"Tried to set a nil value for parameter %@", parameterName);
    }
}

- (NSString *)description
{
    return [_parametersDictionary description];
}

#pragma mark - Memory Mangement

- (void)dealloc
{
    [_parametersDictionary release];
    
    [super dealloc];
}

@end
