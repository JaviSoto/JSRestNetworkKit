//
//  EntityPropertyRelationshipOneToMany.m
//  
//
//  Created by Javier Soto on 03/01/12.
//  Copyright (c) 2012 , Inc. All rights reserved.
//

#import "EntityPropertyRelationshipOneToMany.h"

#import "BaseEntity.h"

#import "BaseCoreDataBackedEntity.h"

#import "JSClassDescendantOfClass.h"

#define kMaxObjectsInArray 15

@implementation EntityPropertyRelationshipOneToMany

- (id)parsedValueForObject:(id)object inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    if (!object || [object isEqual:[NSNull null]] || ![self.entityRelationClass conformsToProtocol:@protocol(BaseEntity)] || ![object isKindOfClass:[NSArray class]])
    {
        return nil;
    }
    
    NSMutableArray *array = [NSMutableArray array];
    [object enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        id entity;
        
        BOOL isCoreDataEntity = classDescendsFromClass(self.entityRelationClass, [BaseCoreDataBackedEntity class]);
        
        if (isCoreDataEntity && managedObjectContext != nil)
        {
            entity = [[self.entityRelationClass updateOrInsertIntoManagedObjectContext:managedObjectContext withDictionary:obj] retain];
        }
        else
        {
            entity = [[self.entityRelationClass alloc] initWithDictionary:obj inManagedObjectContext:nil];
        }

        if (entity)
        {
            [array addObject:entity];
        }
        [entity release];
    }];
    
    return [NSArray arrayWithArray:array];
}

- (id)randomValueWithDepth:(NSInteger)depth
{    
    NSMutableArray *objects = [NSMutableArray array];
    
    const NSUInteger numberOfElements = [NSNumber randomIntBetweenNumber:1 andNumber:kMaxObjectsInArray];
    
    for (int i = 0; i < numberOfElements; i++)
    {
        id object = [self.entityRelationClass randomEntityDictionaryWithDepth:depth];
        [objects addObject:object];
    }
    
    return objects;
}

- (BOOL)needsRelease
{
    return YES;
}

@end
