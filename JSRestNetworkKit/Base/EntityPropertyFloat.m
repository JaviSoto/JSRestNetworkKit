//
//  EntityPropertyFloat.m
//  
//
//  Created by Javier Soto on 1/4/12.
//  Copyright (c) 2012 , Inc. All rights reserved.
//

#import "EntityPropertyFloat.h"

#import "NSNumber+RandomValues.h"

@implementation EntityPropertyFloat

- (id)parsedValueForObject:(id)object inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    if (![object respondsToSelector:@selector(floatValue)])
    {
        return [NSNumber numberWithFloat:0];
    }
    
    return [NSNumber numberWithFloat:[object floatValue]];
}

- (id)randomValueWithDepth:(NSInteger)depth
{
    static const int maxWholeNumber = 20;
    
    float number1 = [NSNumber randomIntBetweenNumber:0 andNumber:maxWholeNumber * 200];
    float number2 = number1 - (maxWholeNumber * 100);
    float number3 = number2 / 100.0;
    return [NSNumber numberWithFloat:number3];
}

@end
