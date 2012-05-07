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

#import "JSWebServiceRequest.h"

@implementation JSWebServiceRequest

@synthesize type = _type;
@synthesize path = _path;
@synthesize parameters = _parameters;
@synthesize headerFields = _headerFields;

- (id)initWithType:(JSWebServiceRequestType)type
               path:(NSString *)path
        parameters:(JSWebServiceRequestParameters *)parameters
{
    if ((self = [super init]))
    {
        self.type = type;
        self.parameters = parameters;
        self.headerFields = [NSMutableDictionary dictionary];
                
        self.path = path;
    }
    
    return self;
}

#pragma mark - NSCoding methods

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super init]))
    {
        self.type = [aDecoder decodeIntForKey:@"requestType"];
        self.path = [aDecoder decodeObjectForKey:@"url"];
        self.parameters = [aDecoder decodeObjectForKey:@"parameters"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInt:self.type forKey:@"requestType"];
    [aCoder encodeObject:self.path forKey:@"url"];
    [aCoder encodeObject:self.parameters forKey:@"parameters"];
}

- (NSString *)requestTypeString
{
    return (self.type == JSWebServiceRequestTypeGET) ? @"GET" : @"POST";
}

- (void)setPath:(NSString *)path
{
    @synchronized(self)
    {
        [_path release];
        _path = [[path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] copy];
    }
}

#pragma mark -

- (NSString *)description
{
    return [NSString stringWithFormat:@"Request to URL %@ with parameters %@", self.path, self.parameters];
}

#pragma mark - Memory Management

- (void)dealloc
{
    [_parameters release];
    [_headerFields release];
    [_path release];
    
    [super dealloc];
}

@end