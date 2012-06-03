//
//  JSEntityDictionaryParser.m
//  JSRestNetworkKitSampleProject
//
//  Created by Javier Soto on 4/8/12.
//  Copyright (c) 2012 JavierSoto. All rights reserved.
//

#import "JSEntityDictionaryParser.h"

#import "JSBaseEntity.h"

@implementation JSEntityDictionaryParser

+ (void)setSafeValue:(id)value forKey:(NSString *)key onEntityObject:(id)entityObject
{
    @try
    {
        if (![value isEqual:[NSNull null]])
        {
            [entityObject setValue:value forKey:key];
        }
        else
        {
            [entityObject setValue:nil forKey:key];
        }
    }
    @catch (NSException *exception)
    {
        NSLog(@"Tried to set value %@ for property %@ in class %@ when it doesn't have that property", value, key, NSStringFromClass([entityObject class]));
    }
}

+ (void)parseDictionary:(NSDictionary *)dictionary inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext inEntityObject:(id<JSBaseEntity>)entityObject
{
	if ([dictionary isKindOfClass:[NSDictionary class]])
	{
		[[[entityObject class] entityProperties] enumerateObjectsUsingBlock:^(JSEntityProperty *property, NSUInteger idx, BOOL *stop) {
            NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
			id value = [dictionary valueForKeyPath:property.apiPropertyKeyPath];
            if (value)
            {
                id parsedSafeValue = [property parsedValueForObject:value inManagedObjectContext:managedObjectContext];
                
                [self setSafeValue:parsedSafeValue forKey:property.entityPropertyKey onEntityObject:entityObject];
            }
            [pool drain];
		}];
	}
	else
    {
        if (dictionary)
        {
            NSLog(@"Tried to parse a %@ as a dictionary with content: %@", NSStringFromClass([dictionary class]), dictionary);
        }
    }
}

@end
