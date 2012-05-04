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

@interface JSBaseCoreDataBackedEntity : NSManagedObject <JSBaseEntity>

+ (void)failedExecutingFetchRequestWithError:(NSError*)error;

/* Parse the dictionary and save into the passed managed object context */
+ (id)updateOrInsertIntoManagedObjectContext:(NSManagedObjectContext *)managedObjectContext withDictionary:(NSDictionary *)dictionary;

+ (id)updateOrInsertRandomObjectInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext withDepth:(NSUInteger)depth;

/* Implement the getter in the subclasses. By default there's no primary key (updateOrInsert calls are always insert) */
+ (JSEntityProperty *)primaryKeyProperty;

@end
