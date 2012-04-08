//
//  EntityPropertyDate.m
//  
//
//  Created by Javier Soto on 1/3/12.
//  Copyright (c) 2012 , Inc. All rights reserved.
//

#import "EntityPropertyDate.h"

@implementation EntityPropertyDate

- (id)parsedValueForObject:(id)object inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    if ([object isEqual:[NSNull null]] || ![object respondsToSelector:@selector(intValue)])
    {
        return nil;
    }
    
    return [NSDate dateWithTimeIntervalSince1970:[object intValue]];
}

- (id)randomValueWithDepth:(NSInteger)depth
{
    return [NSNumber randomNumberBetweenNumber:0 andNumber:1300000000];
}

- (BOOL)needsRelease
{
    return YES;
}

@end
