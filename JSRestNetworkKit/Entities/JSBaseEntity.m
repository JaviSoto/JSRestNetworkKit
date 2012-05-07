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

#import "JSBaseEntity.h"

#import "JSEntityDictionaryParser.h"
#import "JSRandomDictionaryGenerator.h"

@implementation JSBaseEntity

- (id)initWithDictionary:(NSDictionary *)dictionary inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    if ((self = [self init]))
    {
        [self parseDictionary:dictionary inManagedObjectContext:managedObjectContext];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super init]))
    {
        [[[self class] entityProperties] enumerateObjectsUsingBlock:^(JSEntityProperty *property, NSUInteger idx, BOOL *stop) {
            NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
            [JSEntityDictionaryParser setSafeValue:[aDecoder decodeObjectForKey:property.localPropertyKey] forKey:property.localPropertyKey onEntityObject:self];
            [pool drain];
        }];
    }

    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [[[self class] entityProperties] enumerateObjectsUsingBlock:^(JSEntityProperty *property, NSUInteger idx, BOOL *stop) {
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        NSString *propertyKey = property.localPropertyKey;

        if (propertyKey && [self respondsToSelector:NSSelectorFromString(propertyKey)])
        {
            id objectToEncode = [self valueForKey:propertyKey];

            [aCoder encodeObject:objectToEncode forKey:propertyKey];
        }
        [pool drain];
    }];
}

- (id)copyWithZone:(NSZone *)zone
{
    JSBaseEntity *copiedEntity = [[[self class] allocWithZone:zone] init];

    [[[self class] entityProperties] enumerateObjectsUsingBlock:^(JSEntityProperty *property, NSUInteger idx, BOOL *stop) {
        [copiedEntity setValue:[self valueForKey:property.localPropertyKey] forKey:property.localPropertyKey];
    }];

    return copiedEntity;
}

- (void)parseDictionary:(NSDictionary *)feed inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    [JSEntityDictionaryParser parseDictionary:feed inManagedObjectContext:managedObjectContext inEntityObject:self];
}

+ (NSArray *)entityProperties
{
    NSLog(@"+ entityProperties not implemented for %@ class!", NSStringFromClass([self class]));
    [self doesNotRecognizeSelector:_cmd];
    
    return [NSArray array];
}

+ (NSDictionary *)randomEntityDictionaryWithDepth:(NSInteger)depth
{
    return [JSRandomDictionaryGenerator randomEntityDictionaryWithDepth:depth ofEntityClass:self];
}

+ (id)randomEntityObjectWithDepth:(NSInteger)depth
{
    return [[[self alloc] initWithDictionary:[self randomEntityDictionaryWithDepth:depth]] autorelease];
}

+ (NSString *)entityName
{
    return NSStringFromClass(self);
}

#ifndef JSRestNetworkKitDisableAutoDeallocImplementationOfEntities
- (void)dealloc
{
    [[[self class] entityProperties] enumerateObjectsUsingBlock:^(JSEntityProperty *property, NSUInteger idx, BOOL *stop) {
        if ([property needsRelease])
        {
            [self setValue:nil forKey:property.localPropertyKey];
        }
    }];
    
    [super dealloc];
}
#endif

@end
