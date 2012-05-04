//
//  JSRandomDictionaryGenerator.m
//  JSRestNetworkKitSampleProject
//
//  Created by Javier Soto on 4/8/12.
//  Copyright (c) 2012 MindSnacks. All rights reserved.
//

#import "JSRandomDictionaryGenerator.h"

#import "BaseEntity.h"

@implementation JSRandomDictionaryGenerator

+ (NSDictionary *)randomEntityDictionaryWithDepth:(NSInteger)depth ofEntityClass:(Class)entityClass
{
    if (depth < 0)
    {
        return [NSDictionary dictionary];
    }
    
	NSMutableDictionary *randomDictionary = [NSMutableDictionary dictionary];
    
    NSArray *entityProperties = [entityClass entityProperties];
    
    [entityProperties enumerateObjectsUsingBlock:^(JSEntityProperty *property, NSUInteger idx, BOOL *stop) {
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
		id value = [property randomValueWithDepth:depth - 1];
		[randomDictionary setValue:value forKey:property.apiPropertyKey];
        [pool drain];
	}];
    
	return randomDictionary;
}


@end
