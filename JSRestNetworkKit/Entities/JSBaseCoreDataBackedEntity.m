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

#import "JSBaseCoreDataBackedEntity.h"

#import "JSEntityDictionaryParser.h"
#import "JSRandomDictionaryGenerator.h"

#import "JSEntityPropertyRelationshipOneToMany.h"

#define kCoreDataEntityNoPrimaryKey nil

@implementation JSBaseCoreDataBackedEntity

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

+ (NSString *)entityName
{
    return NSStringFromClass(self);
}

#pragma mark - Random

+ (NSDictionary *)randomEntityDictionaryWithDepth:(NSInteger)depth
{
    return [JSRandomDictionaryGenerator randomEntityDictionaryWithDepth:depth ofEntityClass:self];
}

+ (id)randomEntityObjectWithDepth:(NSInteger)depth
{
    return [[[self alloc] initWithDictionary:[self randomEntityDictionaryWithDepth:depth]] autorelease];
}

#pragma mark - Core Data

+ (id)updateOrInsertIntoManagedObjectContext:(NSManagedObjectContext *)managedObjectContext withDictionary:(NSDictionary *)dictionary
{
    JSBaseCoreDataBackedEntity *newObject = nil;
    
    JSEntityProperty *primaryKeyProperty = [self primaryKeyProperty];
    NSString *entityName = [self entityName];
    
    BOOL noPreviouslyExistintObject = YES;
    
    if (primaryKeyProperty != kCoreDataEntityNoPrimaryKey)
    {
        NSString *objectId = [dictionary valueForKey:primaryKeyProperty.apiPropertyKeyPath];
        
        if (objectId)
        {
            NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:entityName];
            fetchRequest.fetchLimit = 1;
            fetchRequest.predicate = [NSPredicate predicateWithFormat:@"%K == %@", primaryKeyProperty.entityPropertyKey, objectId];

            NSArray *fetchResult = [managedObjectContext executeFetchRequest:fetchRequest error:nil];

            JSBaseCoreDataBackedEntity *matchedObject = [fetchResult lastObject];
                        
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

#pragma mark - Setting values from a relation


- (void)setValue:(id)value forKey:(NSString *)key
{
    BOOL isKeyOfRelationOneToMany = NO;
    
    JSEntityProperty *propertyOfKeyBeingSet = nil;
    
    for (JSEntityProperty *p in [[self class] entityProperties])
    {
        if ([p isKindOfClass:[JSEntityPropertyRelationshipOneToMany class]])
        {
            if ([p.entityPropertyKey isEqualToString:key])
            {
                isKeyOfRelationOneToMany = YES;
                propertyOfKeyBeingSet = p;
                break;
            }
        }
    }
    
    if (isKeyOfRelationOneToMany)
    {
        NSString *removeObjectsSelectorName = [NSString stringWithFormat:@"remove%@:", [propertyOfKeyBeingSet.entityPropertyKey stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[propertyOfKeyBeingSet.entityPropertyKey substringToIndex:1] capitalizedString]]];
        SEL removeObjectsSelector = NSSelectorFromString(removeObjectsSelectorName);
        
        NSString *addObjectsSelectorName = [NSString stringWithFormat:@"add%@:", [propertyOfKeyBeingSet.entityPropertyKey stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[propertyOfKeyBeingSet.entityPropertyKey substringToIndex:1] capitalizedString]]];
        SEL addObjectsSelector = NSSelectorFromString(addObjectsSelectorName);
        
        if ([self respondsToSelector:removeObjectsSelector])
            [self performSelector:NSSelectorFromString(removeObjectsSelectorName) withObject:[self valueForKey:key]];
        else
            NSLog(@"%@ doesn't respond to selector %@. Can't set %@", NSStringFromClass([self class]), removeObjectsSelectorName, key);
        
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
            NSLog(@"%@ doesn't respond to selector %@. Can't set %@", NSStringFromClass([self class]), removeObjectsSelectorName, key);
        }
    }
    else
    {
        NSLog(@"Set %@ for %@",value,key);
        [super setValue:value forKey:key];
    }
}

#pragma mark - Public aux

+ (JSEntityProperty *)primaryKeyProperty
{
    return kCoreDataEntityNoPrimaryKey;
}

@end
