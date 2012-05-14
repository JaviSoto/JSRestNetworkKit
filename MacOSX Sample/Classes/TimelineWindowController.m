//
//  TimelineWindowController.m
//  JSRestNetworkKitSampleProject
//
//  Created by Javier Soto on 5/13/12.
//  Copyright (c) 2012 JavierSoto. All rights reserved.
//

#import "TimelineWindowController.h"

#import "TwitterRequestManager.h"

@interface TimelineWindowController ()
{
    TwitterRequestManager *_requestManager;
}
@property (assign) IBOutlet NSWindow *window;
@end

@implementation TimelineWindowController
@synthesize window;

- (id)init
{
    return [self initWithWindowNibName:NSStringFromClass([self class])];
}

- (id)initWithWindowNibName:(NSString *)windowNibName
{
    if ((self = [super initWithWindowNibName:windowNibName]))
    {
        _requestManager = [[TwitterRequestManager alloc] init];
    }
    
    return self;
}

- (void)dealloc
{
    [_requestManager release];
    
    [super dealloc];
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    [_requestManager requestTimelineWithSuccessCallback:^(id data, BOOL cached) {
        NSLog(@"%@", data);
    } errorCallback:^{
        NSLog(@"error");        
    }];
}

@end
