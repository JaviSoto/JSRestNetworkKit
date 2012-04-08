//
//  BaseCoreDataBackedEntity.m
//  minube
//
//  Created by Javier Soto on 3/14/12.
//  Copyright (c) 2012 minube.com. All rights reserved.
//

#import "BaseCoreDataBackedEntity.h"

#import "BaseEntityPrivate.h"

#import "EntityPropertyRelationshipOneToMany.h"

#define kCoreDataEntityNoPrimaryKey nil

ImplementBaseEntity(BaseCoreDataBackedEntity);

+ (id)updateOrInsertIntoManagedObjectContext:(NSManagedObjectContext *)managedObjectContext withDictionary:(NSDictionary *)dictionary
{
    BaseCoreDataBackedEntity *newObject = nil;
    
    EntityProperty *primaryKeyProperty = [self primaryKeyProperty];
    NSString *entityName = [self entityName];
    
    BOOL noPreviouslyExistintObject = YES;
    
    if (primaryKeyProperty != kCoreDataEntityNoPrimaryKey)
    {
        NSString *objectId = [dictionary valueForKey:primaryKeyProperty.apiPropertyKey];
        
        if (objectId)
        {
            NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:entityName];
            fetchRequest.fetchLimit = 1;
            fetchRequest.predicate = [NSPredicate predicateWithFormat:@"%K == %@", primaryKeyProperty.localPropertyKey, objectId];

            NSArray *fetchResult=[managedObjectContext executeFetchRequest:fetchRequest error:nil];
            if(fetchResult==nil){
                DebugLog(@"error");
            }
            BaseCoreDataBackedEntity *matchedObject = [fetchResult lastObject];
                        
            if (matchedObject)
            {
                noPreviouslyExistintObject = NO;
                newObject = matchedObject;
            }
        }
    }

    if (noPreviouslyExistintObject)
    {
        newObject = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:managedObjectContext];
    }
    
    [newObject parseDictionary:dictionary inManagedObjectContext:managedObjectContext];
    return newObject;
}

+ (id)updateOrInsertRandomObjectInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext withDepth:(NSUInteger)depth
{
    NSDictionary *randomDictionary = [self randomEntityDictionaryWithDepth:depth];
    return [self updateOrInsertIntoManagedObjectContext:managedObjectContext withDictionary:randomDictionary];
}
+ (void)failedExecutingFetchRequestWithError:(NSError*)error{

}
#pragma mark - Setting values from a relation


- (void)setValue:(id)value forKey:(NSString *)key
{
    BOOL isKeyOfRelationOneToMany = NO;
    
    EntityProperty *propertyOfKeyBeingSet = nil;
    
    for (EntityProperty *p in [[self class] entityProperties])
    {
        if ([p isKindOfClass:[EntityPropertyRelationshipOneToMany class]])
        {
            if ([p.localPropertyKey isEqualToString:key])
            {
                isKeyOfRelationOneToMany = YES;
                propertyOfKeyBeingSet = p;
                break;
            }
        }
    }
    
    if (isKeyOfRelationOneToMany)
    {
        NSString *removeObjectsSelectorName = [NSString stringWithFormat:@"remove%@:", [propertyOfKeyBeingSet.localPropertyKey stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[propertyOfKeyBeingSet.localPropertyKey substringToIndex:1] capitalizedString]]];
        SEL removeObjectsSelector = NSSelectorFromString(removeObjectsSelectorName);
        
        NSString *addObjectsSelectorName = [NSString stringWithFormat:@"add%@:", [propertyOfKeyBeingSet.localPropertyKey stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[propertyOfKeyBeingSet.localPropertyKey substringToIndex:1] capitalizedString]]];
        SEL addObjectsSelector = NSSelectorFromString(addObjectsSelectorName);
        
        if ([self respondsToSelector:removeObjectsSelector])
            [self performSelector:NSSelectorFromString(removeObjectsSelectorName) withObject:[self valueForKey:key]];
        else
            DebugLog(@"%@ doesn't respond to selector %@. Can't set %@", NSStringFromClass([self class]), removeObjectsSelectorName, key);
        
        if ([self respondsToSelector:addObjectsSelector])
        {
            NSSet *objectsToAdd = value;
            
            if ([value isKindOfClass:[NSArray class]])
            {
                objectsToAdd = [NSSet setWithArray:value];
            }
            
            [self performSelector:addObjectsSelector withObject:objectsToAdd];
        }
        else
        {
            DebugLog(@"%@ doesn't respond to selector %@. Can't set %@", NSStringFromClass([self class]), removeObjectsSelectorName, key);
        }
    }
    else
    {
        DebugLog(@"Set %@ for %@",value,key);
        [super setValue:value forKey:key];
    }
}

#pragma mark - Public aux

+ (EntityProperty *)primaryKeyProperty
{
    return kCoreDataEntityNoPrimaryKey;
}

@end
