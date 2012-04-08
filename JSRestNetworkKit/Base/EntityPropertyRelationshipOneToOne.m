//
//  EntityPropertyRelationshipManyToMany.m
//  
//
//  Created by Javier Soto on 03/01/12.
//  Copyright (c) 2012 , Inc. All rights reserved.
//

#import "EntityPropertyRelationshipOneToOne.h"
#import "BaseEntity.h"

#import "BaseCoreDataBackedEntity.h"

#import "JSClassDescendantOfClass.h"

@implementation EntityPropertyRelationshipOneToOne

- (id)parsedValueForObject:(id)object inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    if ([object isEqual:[NSNull null]] || ![self.entityRelationClass isSubclassOfClass:[BaseEntity class]])
    {
        return nil;
    }
    
    BOOL isCoreDataEntity = classDescendsFromClass(self.entityRelationClass, [BaseCoreDataBackedEntity class]);
    
    id entity;
    
    if (isCoreDataEntity && managedObjectContext != nil)
    {
        entity = [[self.entityRelationClass updateOrInsertIntoManagedObjectContext:managedObjectContext withDictionary:object] retain];
    }
    else
    {
        entity = [[self.entityRelationClass alloc] initWithDictionary:object inManagedObjectContext:nil];
    }
    
    return [entity autorelease];
}

- (id)randomValueWithDepth:(NSInteger)depth
{
    if (self.entityRelationClass && [self.entityRelationClass conformsToProtocol:@protocol(BaseEntity)])
    {
        return [self.entityRelationClass randomEntityDictionaryWithDepth:depth];
    }
    else
    {
        DebugLog(@"%@ tried create a random object with an invalid entityRelationClass", self);
        return nil;
    }
}

- (BOOL)needsRelease
{
    return YES;
}

@end
