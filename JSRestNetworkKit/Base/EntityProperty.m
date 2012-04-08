//
//  EntityProperty.m
//  
//
//  Created by Javier Soto on 03/01/12.
//  Copyright (c) 2012 , Inc. All rights reserved.
//

#import "EntityProperty.h"

#import "EntityPropertyInt.h"
#import "EntityPropertyFloat.h"
#import "EntityPropertyBool.h"
#import "EntityPropertyGender.h"
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
        case EntityPropertyTypeGender:
            property = [[EntityPropertyGender alloc] init];
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
