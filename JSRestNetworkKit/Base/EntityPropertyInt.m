//
//  EntityPropertyTypeInt.m
//  
//
//  Created by Javier Soto on 03/01/12.
//  Copyright (c) 2012 , Inc. All rights reserved.
//

#import "EntityPropertyInt.h"

#define kRandomMinNumber 0 
#define kRandomMaxNumber 199 

@implementation EntityPropertyInt

- (id)parsedValueForObject:(id)object inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    if (![object respondsToSelector:@selector(intValue)])
    {
        return [NSNumber numberWithInt:0];
    }
    
    return [NSNumber numberWithInt:[object intValue]];
}

- (id)randomValueWithDepth:(NSInteger)depth
{
    return [NSNumber randomNumberBetweenNumber:0 andNumber:15];
}

@end
