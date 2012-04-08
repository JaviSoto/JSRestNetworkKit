//
//  Helper.m
//  minube
//
//  Created by Javier Soto on 3/21/12.
//  Copyright (c) 2012 minube.com. All rights reserved.
//

#import "Helper.h"

#import <objc/runtime.h>

@implementation Helper

+ (void)swizzleSelector:(SEL)orig ofClass:(Class)c withSelector:(SEL)newSelector;
{
    Method origMethod = class_getInstanceMethod(c, orig);
    Method newMethod = class_getInstanceMethod(c, newSelector);
    
    if (class_addMethod(c, orig, method_getImplementation(newMethod),
                        method_getTypeEncoding(newMethod)))
    {
        class_replaceMethod(c, newSelector, method_getImplementation(origMethod),
                            method_getTypeEncoding(origMethod));
    }
    else
    {
        method_exchangeImplementations(origMethod, newMethod);
    }
}

BOOL classDescendsFromClass(Class classA, Class classB)
{
    while(classA)
    {
        if(classA == classB) return YES;
        classA = class_getSuperclass(classA);
    }
    
    return NO;
}


@end
