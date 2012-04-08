//
//  EntityProperty.h
//
//  Created by Javier Soto on 03/01/12.
//  Copyright (c) 2012 , Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
	EntityPropertyTypeInt,
    EntityPropertyTypeFloat,
	EntityPropertyTypeString,
	EntityPropertyTypeBool,
    EntityPropertyTypeGender,
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
