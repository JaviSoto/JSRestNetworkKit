//
//  BaseEntityPrivate.h
//  minube
//
//  Created by Javier Soto on 3/14/12.
//  Copyright (c) 2012 minube.com. All rights reserved.
//

#define ImplementBaseEntity(classname) \
\
@interface classname() \
- (void)setSafeValue:(id)value forKey:(NSString *)key; \
@end \
@implementation classname \
\
- (id)initWithDictionary:(NSDictionary *)dictionary inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext \
{ \
    if ((self = [self init])) \
    { \
        [self parseDictionary:dictionary inManagedObjectContext:managedObjectContext]; \
    } \
    \
    return self; \
} \
\
- (id)initWithCoder:(NSCoder *)aDecoder \
{ \
    if ((self = [super init])) \
    { \
        [[[self class] entityProperties] enumerateObjectsUsingBlock:^(EntityProperty *property, NSUInteger idx, BOOL *stop) { \
            NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init]; \
            [self setSafeValue:[aDecoder decodeObjectForKey:property.localPropertyKey] forKey:property.localPropertyKey]; \
            [pool drain]; \
        }]; \
    } \
    \
    return self; \
} \
\
- (void)encodeWithCoder:(NSCoder *)aCoder \
{ \
    [[[self class] entityProperties] enumerateObjectsUsingBlock:^(EntityProperty *property, NSUInteger idx, BOOL *stop) { \
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init]; \
        NSString *propertyKey = property.localPropertyKey; \
        \
        if (propertyKey && [self respondsToSelector:NSSelectorFromString(propertyKey)]) \
        { \
            id objectToEncode = [self valueForKey:propertyKey]; \
            \
            [aCoder encodeObject:objectToEncode forKey:propertyKey]; \
        } \
        [pool drain]; \
    }]; \
} \
\
- (id)copyWithZone:(NSZone *)zone \
{ \
    BaseEntity *copiedEntity = [[[self class] allocWithZone:zone] init]; \
    \
    [[[self class] entityProperties] enumerateObjectsUsingBlock:^(EntityProperty *property, NSUInteger idx, BOOL *stop) { \
        [copiedEntity setValue:[self valueForKey:property.localPropertyKey] forKey:property.localPropertyKey]; \
    }]; \
    \
    return copiedEntity; \
} \
\
- (void)parseDictionary:(NSDictionary *)dictionary inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext \
{ \
	if ([dictionary isKindOfClass:[NSDictionary class]]) \
	{ \
		[[[self class] entityProperties] enumerateObjectsUsingBlock:^(EntityProperty *property, NSUInteger idx, BOOL *stop) { \
            NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init]; \
			id value = [dictionary valueForKey:property.apiPropertyKey]; \
            if (value) \
            { \
                id parsedSafeValue = [property parsedValueForObject:value inManagedObjectContext:managedObjectContext]; \
                \
                [self setSafeValue:parsedSafeValue forKey:property.localPropertyKey]; \
            } \
            [pool drain]; \
		}]; \
	} \
	else \
    { \
        if (dictionary) \
        { \
            DebugLog(@"Tried to parse a %@ as a dictionary with content: %@", NSStringFromClass([dictionary class]), dictionary); \
        } \
    } \
} \
\
+ (NSArray *)entityProperties \
{ \
    DebugLog(@"+ entityProperties not implemented for %@ class!", NSStringFromClass([self class])); \
    [self doesNotRecognizeSelector:_cmd]; \
    return [NSArray array]; \
} \
\
+ (NSDictionary *)randomEntityDictionaryWithDepth:(NSInteger)depth \
{ \
    if (depth < 0) \
    { \
        return [NSDictionary dictionary]; \
    } \
    \
	NSMutableDictionary *randomDictionary = [NSMutableDictionary dictionary]; \
	\
    NSArray *entityProperties = [self entityProperties]; \
    \
    [entityProperties enumerateObjectsUsingBlock:^(EntityProperty *property, NSUInteger idx, BOOL *stop) { \
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init]; \
		id value = [property randomValueWithDepth:depth - 1]; \
		[randomDictionary setValue:value forKey:property.apiPropertyKey]; \
        [pool drain]; \
	}]; \
	return randomDictionary; \
} \
\
+ (id)randomEntityObjectWithDepth:(NSInteger)depth \
{ \
    return [[[self alloc] initWithDictionary:[self randomEntityDictionaryWithDepth:depth]] autorelease]; \
} \
\
- (void)setSafeValue:(id)value forKey:(NSString *)key \
{ \
    @try \
    { \
        if (![value isEqual:[NSNull null]]) \
        { \
            [self setValue:value forKey:key]; \
        } \
        else \
        { \
            [self setValue:nil forKey:key]; \
        } \
        \
    } \
    @catch (NSException *exception) \
    { \
        DebugLog(@"Tried to set value %@ for property %@ in class %@ when it doesn't have that property", value, key, NSStringFromClass([self class])); \
    } \
} \
\
+ (NSString *)entityName \
{ \
    return NSStringFromClass(self); \
}

#define ImplementAutoDealloc() \
- (void)dealloc \
{ \
    [[[self class] entityProperties] enumerateObjectsUsingBlock:^(EntityProperty *property, NSUInteger idx, BOOL *stop) { \
        if ([property needsRelease]) \
        { \
            [self setValue:nil forKey:property.localPropertyKey]; \
        } \
    }]; \
    \
    [super dealloc]; \
}