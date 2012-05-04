//
//  JSEntityDictionaryParser.h
//  JSRestNetworkKitSampleProject
//
//  Created by Javier Soto on 4/8/12.
//  Copyright (c) 2012 MindSnacks. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JSBaseEntity;

@interface JSEntityDictionaryParser : NSObject

+ (void)setSafeValue:(id)value forKey:(NSString *)key onEntityObject:(id)entityObject;

+ (void)parseDictionary:(NSDictionary *)dictionary inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext inEntityObject:(id<JSBaseEntity>)entityObject;

@end
