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

#import "JSEntityProperty.h"

#import "JSEntityPropertyInt.h"
#import "JSEntityPropertyFloat.h"
#import "JSEntityPropertyBool.h"
#import "JSEntityPropertyString.h"
#import "JSEntityPropertyURL.h"
#import "JSEntityPropertyDate.h"
#import "JSEntityPropertyRelationshipOneToMany.h"
#import "JSEntityPropertyRelationshipOneToOne.h"

@implementation JSEntityProperty

@synthesize apiPropertyKey = _apiPropertyKey;
@synthesize entityPropertyKey = _localPropertyKey;
@synthesize entityRelationClass = _entityRelationClass;


+ (JSEntityProperty *)entityPropertyWithKey:(NSString *)key propertyType:(JSEntityPropertyType)propertyType
{
    return [self entityPropertyWithAPIKeyPath:key entityPropertyKey:key relationClass:nil propertyType:propertyType];
}

+ (JSEntityProperty *)entityPropertyWithAPIKeyPath:(NSString *)apiKey entityPropertyKey:(NSString *)localKey propertyType:(JSEntityPropertyType)propertyType
{
    return [self entityPropertyWithAPIKeyPath:apiKey entityPropertyKey:localKey relationClass:nil propertyType:propertyType];
}

+ (JSEntityProperty *)entityPropertyWithKey:(NSString *)key relationClass:(Class)relationClass propertyType:(JSEntityPropertyType)propertyType
{
    return [self entityPropertyWithAPIKeyPath:key entityPropertyKey:key relationClass:relationClass propertyType:propertyType];
}

+ (JSEntityProperty *)entityPropertyWithAPIKeyPath:(NSString *)apiKey entityPropertyKey:(NSString *)localKey relationClass:(Class)relationClass propertyType:(JSEntityPropertyType)propertyType
{
    JSEntityProperty *property = nil;
    
    switch (propertyType) {
        case JSEntityPropertyTypeInt:
            property = [[JSEntityPropertyInt alloc] init];
            break;
        case JSEntityPropertyTypeFloat:
            property = [[JSEntityPropertyFloat alloc] init];
            break;
        case JSEntityPropertyTypeBool:
            property = [[JSEntityPropertyBool alloc] init];
            break;
        case JSEntityPropertyTypeString:
            property = [[JSEntityPropertyString alloc] init];
            break;
        case JSEntityPropertyTypeURL:
            property = [[JSEntityPropertyURL alloc] init];
            break;
        case JSEntityPropertyTypeDate:
            property = [[JSEntityPropertyDate alloc] init];
            break;
        case JSEntityPropertyTypeRelationshipOneToMany:
            property = [[JSEntityPropertyRelationshipOneToMany alloc] init];
            break;
        case JSEntityPropertyTypeRelationshipOneToOne:
            property = [[JSEntityPropertyRelationshipOneToOne alloc] init];
            break;
        default:
            break;
    }
    property.isKeyPath = isKeyPath;
    property.apiPropertyKey = apiKey;
    property.entityPropertyKey = localKey;
    property.entityRelationClass = relationClass;
    
    return [property autorelease];
}

- (id)parsedValueForObject:(id)object inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    // Abstract implementation
    return nil;
}

- (id)randomValueWithDepth:(NSInteger)depth
{
    // Abstract implementation
    return nil;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ with local key: %@ api key: %@ relation with class: %@", NSStringFromClass(self.class), self.entityPropertyKey, self.apiPropertyKey, self.entityRelationClass.class];
}
- (void)dealloc
{
	[_apiPropertyKey release];
	[_localPropertyKey release];
    
	[super dealloc];
}

@end
