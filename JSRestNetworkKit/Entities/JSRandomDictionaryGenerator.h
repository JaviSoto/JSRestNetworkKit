//
//  JSRandomDictionaryGenerator.h
//  JSRestNetworkKitSampleProject
//
//  Created by Javier Soto on 4/8/12.
//  Copyright (c) 2012 MindSnacks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSRandomDictionaryGenerator : NSObject

+ (NSDictionary *)randomEntityDictionaryWithDepth:(NSInteger)depth ofEntityClass:(Class)entityClass;

@end
