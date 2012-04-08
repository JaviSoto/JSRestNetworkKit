//
//  EntityPropertyString.m
//  
//
//  Created by Javier Soto on 03/01/12.
//  Copyright (c) 2012 , Inc. All rights reserved.
//

#import "EntityPropertyString.h"

#define kRandomValueLength 15

@implementation EntityPropertyString

- (id)parsedValueForObject:(id)object inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    if (!object || [object isEqual:[NSNull null]])
    {
        return @"";
    }
    
    return [NSString stringWithFormat:@"%@", object];
}

- (id)randomValueWithDepth:(NSInteger)depth
{
    return [NSString randomStringWithLengthBetween:2 and:20];
}

- (BOOL)needsRelease
{
    return YES;
}

@end
