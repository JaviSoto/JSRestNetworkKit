//
//  EntityPropertyBool.m

//  Created by Javier Soto on 03/01/12.
//

#import "EntityPropertyBool.h"

@implementation EntityPropertyBool

- (id)parsedValueForObject:(id)object inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    if (![object respondsToSelector:@selector(boolValue)])
    {
        return [NSNumber numberWithBool:NO];
    }
    
    return [NSNumber numberWithBool:[object boolValue]];
}

- (id)randomValueWithDepth:(NSInteger)depth
{
    return [NSNumber randomBoolNumber];
}

@end
