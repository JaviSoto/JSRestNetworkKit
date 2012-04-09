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

#import <Foundation/Foundation.h>

typedef enum
{
	EntityPropertyTypeInt,
    EntityPropertyTypeFloat,
	EntityPropertyTypeString,
	EntityPropertyTypeBool,
	EntityPropertyTypeURL,
    EntityPropertyTypeDate,
	EntityPropertyTypeRelationshipOneToOne,
	EntityPropertyTypeRelationshipOneToMany
} EntityPropertyType; 

@interface EntityProperty : NSObject

@property (nonatomic, copy) NSString *apiPropertyKey;
@property (nonatomic, copy) NSString *localPropertyKey;
@property (nonatomic, assign) Class entityRelationClass;

+ (EntityProperty *)entityPropertyWithKey:(NSString *)key propertyType:(EntityPropertyType)propertyType;

+ (EntityProperty *)entityPropertyWithApiKey:(NSString *)apiKey andLocalKey:(NSString *)localKey propertyType:(EntityPropertyType)propertyType;

+ (EntityProperty *)entityPropertyWithKey:(NSString *)key relationClass:(Class)relationClass propertyType:(EntityPropertyType)propertyType;

+ (EntityProperty *)entityPropertyWithApiKey:(NSString *)apiKey andLocalKey:(NSString *)localKey relationClass:(Class)relationClass propertyType:(EntityPropertyType)propertyType;

// Second parameter is optional
- (id)parsedValueForObject:(id)object inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;
- (id)randomValueWithDepth:(NSInteger)depth;

- (BOOL)needsRelease;

@end
