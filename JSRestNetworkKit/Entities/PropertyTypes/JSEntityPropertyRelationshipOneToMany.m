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

#import "JSEntityPropertyRelationshipOneToMany.h"

#import "JSBaseEntity.h"

#import "JSBaseCoreDataBackedEntity.h"

#import "JSClassDescendantOfClass.h"
#import "NSNumber+JSRandomValues.h"

#define kMaxObjectsInArray 15

@implementation JSEntityPropertyRelationshipOneToMany

- (id)parsedValueForObject:(id)object inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    if (!object || [object isEqual:[NSNull null]] || ![self.entityRelationClass conformsToProtocol:@protocol(JSBaseEntity)] || ![object isKindOfClass:[NSArray class]])
    {
        return nil;
    }
    
    NSMutableArray *array = [NSMutableArray array];
    [object enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        id entity;
        
        BOOL isCoreDataEntity = classDescendsFromClass(self.entityRelationClass, [JSBaseCoreDataBackedEntity class]);
        
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
