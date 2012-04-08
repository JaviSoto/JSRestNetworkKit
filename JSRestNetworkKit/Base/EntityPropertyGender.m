//
//  EntityPropertyGender.m
//  
//
//  Created by Javier Soto on 1/3/12.
//  Copyright (c) 2012 , Inc. All rights reserved.
//

#import "EntityPropertyGender.h"

@implementation EntityPropertyGender

- (id)parsedValueForObject:(id)object inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    if ([object isEqual:[NSNull null]] || ![object respondsToSelector:@selector(isEqualToString:)])
    {
        return [NSNumber numberWithBool:YES];
    }
    
    return [NSNumber numberWithBool:[object isEqualToString:@"male"]];
}

- (id)randomValueWithDepth:(NSInteger)depth
{
    return [NSNumber randomBoolNumber];
}

@end
