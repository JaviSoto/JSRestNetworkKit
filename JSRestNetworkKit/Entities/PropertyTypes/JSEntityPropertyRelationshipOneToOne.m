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

#import "JSEntityPropertyRelationshipOneToOne.h"
#import "JSBaseEntity.h"

#import "JSBaseCoreDataBackedEntity.h"

#import "JSClassDescendantOfClass.h"

@implementation JSEntityPropertyRelationshipOneToOne

- (id)parsedValueForObject:(id)object inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    if ([object isEqual:[NSNull null]] || ![self.entityRelationClass isSubclassOfClass:[JSBaseEntity class]])
    {
        return nil;
    }
    
    BOOL isCoreDataEntity = classDescendsFromClass(self.entityRelationClass, [JSBaseCoreDataBackedEntity class]);
    
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
        NSLog(@"%@ tried create a random object with an invalid entityRelationClass", self);
        return nil;
    }
}

- (BOOL)needsRelease
{
    return YES;
}

@end
