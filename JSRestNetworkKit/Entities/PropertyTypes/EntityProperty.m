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

#import "EntityPropertyInt.h"
#import "EntityPropertyFloat.h"
#import "EntityPropertyBool.h"
#import "EntityPropertyString.h"
#import "EntityPropertyURL.h"
#import "EntityPropertyDate.h"
#import "EntityPropertyRelationshipOneToMany.h"
#import "EntityPropertyRelationshipOneToOne.h"

@implementation EntityProperty

@synthesize apiPropertyKey = _apiPropertyKey;
@synthesize localPropertyKey = _localPropertyKey;
@synthesize entityRelationClass = _entityRelationClass;


+ (EntityProperty *)entityPropertyWithKey:(NSString *)key propertyType:(EntityPropertyType)propertyType
{
    return [self entityPropertyWithApiKey:key andLocalKey:key relationClass:nil propertyType:propertyType];
}

+ (EntityProperty *)entityPropertyWithApiKey:(NSString *)apiKey andLocalKey:(NSString *)localKey propertyType:(EntityPropertyType)propertyType
{
    return [self entityPropertyWithApiKey:apiKey andLocalKey:localKey relationClass:nil propertyType:propertyType];
}

+ (EntityProperty *)entityPropertyWithKey:(NSString *)key relationClass:(Class)relationClass propertyType:(EntityPropertyType)propertyType
{
    return [self entityPropertyWithApiKey:key andLocalKey:key relationClass:relationClass propertyType:propertyType];
}

+ (EntityProperty *)entityPropertyWithApiKey:(NSString *)apiKey andLocalKey:(NSString *)localKey relationClass:(Class)relationClass propertyType:(EntityPropertyType)propertyType
{
    EntityProperty *property = nil;
    switch (propertyType) {
        case EntityPropertyTypeInt:
            property = [[EntityPropertyInt alloc] init];
            break;
        case EntityPropertyTypeFloat:
            property = [[EntityPropertyFloat alloc] init];
            break;
        case EntityPropertyTypeBool:
            property = [[EntityPropertyBool alloc] init];
            break;
        case EntityPropertyTypeString:
            property = [[EntityPropertyString alloc] init];
            break;
        case EntityPropertyTypeURL:
            property = [[EntityPropertyURL alloc] init];
            break;
        case EntityPropertyTypeDate:
            property = [[EntityPropertyDate alloc] init];
            break;
        case EntityPropertyTypeRelationshipOneToMany:
            property = [[EntityPropertyRelationshipOneToMany alloc] init];
            break;
        case EntityPropertyTypeRelationshipOneToOne:
            property = [[EntityPropertyRelationshipOneToOne alloc] init];
            break;
        default:
            break;
    }
    property.apiPropertyKey = apiKey;
    property.localPropertyKey = localKey;
    property.entityRelationClass = relationClass;
    
    return [property autorelease];
}

- (id)parsedValueForObject:(id)object inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    // Abstract implementation
    return nil;
}

// think what would happen with recursive relationdships. Probable infinite loop. Perhaps add a maxdepth parameter for this method
- (id)randomValueWithDepth:(NSInteger)depth
{
    // Abstract implementation
    return nil;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ with local key: %@ api key: %@ relation with class: %@", NSStringFromClass(self.class), self.localPropertyKey, self.apiPropertyKey, self.entityRelationClass.class];
}

- (BOOL)needsRelease
{
    return NO;
}

- (void)dealloc
{
	[_apiPropertyKey release];
	[_localPropertyKey release];
    
	[super dealloc];
}

@end
