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
	JSEntityPropertyTypeInt,
    JSEntityPropertyTypeFloat,
	JSEntityPropertyTypeString,
	JSEntityPropertyTypeBool,
	JSEntityPropertyTypeURL,
    JSEntityPropertyTypeDate,
	JSEntityPropertyTypeRelationshipOneToOne,
	JSEntityPropertyTypeRelationshipOneToMany
} JSEntityPropertyType;

@interface JSEntityProperty : NSObject

@property (nonatomic, assign) BOOL isKeyPath;
@property (nonatomic, copy) NSString *apiPropertyKey;
@property (nonatomic, copy) NSString *entityPropertyKey;
@property (nonatomic, assign) Class entityRelationClass;

+ (JSEntityProperty *)entityPropertyWithKey:(NSString *)key
                               propertyType:(JSEntityPropertyType)propertyType;

+ (JSEntityProperty *)entityPropertyWithKeyPath:(NSString *)key
                                   propertyType:(JSEntityPropertyType)propertyType;

+ (JSEntityProperty *)entityPropertyWithAPIKey:(NSString *)apiKey
                             entityPropertyKey:(NSString *)localKey
                                  propertyType:(JSEntityPropertyType)propertyType;

+ (JSEntityProperty *)entityPropertyWithAPIKeyPath:(NSString *)apiKey
                                 entityPropertyKey:(NSString *)localKey
                                      propertyType:(JSEntityPropertyType)propertyType;

+ (JSEntityProperty *)entityPropertyWithKey:(NSString *)key
                              relationClass:(Class)relationClass
                               propertyType:(JSEntityPropertyType)propertyType;

+ (JSEntityProperty *)entityPropertyWithKeyPath:(NSString *)key
                                  relationClass:(Class)relationClass
                                   propertyType:(JSEntityPropertyType)propertyType;

// Second parameter is optional
- (id)parsedValueForObject:(id)object inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;
- (id)randomValueWithDepth:(NSInteger)depth;

@end
