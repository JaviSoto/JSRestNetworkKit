//
//  BaseCoreDataBackedEntity.h
//  minube
//
//  Created by Javier Soto on 3/14/12.
//  Copyright (c) 2012 minube.com. All rights reserved.
//

#import "BaseEntity.h"

@interface BaseCoreDataBackedEntity : NSManagedObject <BaseEntity>

+ (void)failedExecutingFetchRequestWithError:(NSError*)error;

/* Parse the dictionary and save into the passed managed object context */
+ (id)updateOrInsertIntoManagedObjectContext:(NSManagedObjectContext *)managedObjectContext withDictionary:(NSDictionary *)dictionary;

+ (id)updateOrInsertRandomObjectInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext withDepth:(NSUInteger)depth;

/* Implement the getter in the subclasses. By default there's no primary key (updateOrInsert calls are always insert) */
+ (EntityProperty *)primaryKeyProperty;

@end
