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

#import "EntityProperty.h"

typedef enum {
    PoiTypeToSee = 0,
    PoiTypeToEat,
    PoiTypeToSleep
} PoiType;

@protocol BaseEntity <NSObject>

// Initializes the entity parsing the dictionary with the parseDictionary: method. Second parameter is optional.
- (id)initWithDictionary:(NSDictionary *)dictionary inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

// Takes the dictionary and sets the corresponding properties of the entity object according to the values in it. Second param is optional.
- (void)parseDictionary:(NSDictionary *)feed inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

// Returns a dictionary filled with random data, like the one the API would return for this entity.
+ (NSDictionary *)randomEntityDictionaryWithDepth:(NSInteger)depth;

// Returns an autoreleased entity object with random values for the properties. Should be implemented in each subclass.
+ (id)randomEntityObjectWithDepth:(NSInteger)depth;

// Returns YES if 1. object is of the class or inheritates from BaseEntity and 2. both entities are the same because of some identifier property.
- (BOOL)isEqual:(id)object;

// subclasses only need to implement this method and return an NSArray of EntityProperty instances.
+ (NSArray *)entityProperties;

/* No need to override. Returns the name of the class (useful for fetches */
+ (NSString *)entityName;

@end

@interface BaseEntity : NSObject <BaseEntity, NSCoding, NSCopying>

@end