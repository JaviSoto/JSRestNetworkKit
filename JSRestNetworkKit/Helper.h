//
//  Helper.h
//  minube
//
//  Created by Javier Soto on 3/21/12.
//  Copyright (c) 2012 minube.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Helper : NSObject

+ (void)swizzleSelector:(SEL)orig ofClass:(Class)c withSelector:(SEL)newSelector;

BOOL classDescendsFromClass(Class classA, Class classB);

@end
