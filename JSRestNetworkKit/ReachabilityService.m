/* 
 Copyright 2012 Javier Soto (ios@javisoto.es)
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License. 
 */

#import "ReachabilityService.h"

#import "Reachability.h"

@implementation ReachabilityService

@synthesize connectionAvailable;

#pragma mark - Singleton methods

+ (ReachabilityService *)instance {
    static dispatch_once_t dispatchOncePredicate;
    static ReachabilityService *myInstance = nil;
    
    dispatch_once(&dispatchOncePredicate, ^{
        myInstance = [[self alloc] init];
    });
    
    return myInstance;
}

#pragma mark - ReachService

- (Reachability *)hostReach
{
    if (!hostReach)
    {
        NSString *hostname = [NSString stringWithFormat:@"api.up.com"];
        hostReach = [[Reachability reachabilityWithHostName:hostname] retain];    
    }
    
    return hostReach;
}

- (void)start
{
    #if (!DUMMY_MODE)
    __block typeof(self) blockSafeSelf = self;
    
    [[NSNotificationCenter defaultCenter] addObserverForName:kReachabilityChangedNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        Reachability *curReach = [note object];
        NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
        NetworkStatus netStatus = [curReach currentReachabilityStatus];
        
        BOOL newConnectionAvailable = netStatus != NotReachable;
        BOOL connectionStatusChanged = blockSafeSelf.connectionAvailable != newConnectionAvailable;
        
        if (connectionStatusChanged || !connectionStatusSet)
        {
            blockSafeSelf.connectionAvailable = newConnectionAvailable;
            blockSafeSelf->connectionStatusSet = YES;
            
            if (newConnectionAvailable)
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:kReachabilityConnectionBecomeAvailableNotification object:nil];
                DebugLog(@"reachabilityChanged. connectionAvailable: YES");
            }
            else
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:kReachabilityConnectionBecomeUnAvailableNotification object:nil];
                DebugLog(@"reachabilityChanged. connectionAvailable: NO");
            }
        }
    }];
    
    [[self hostReach] startNotifier];
    #endif
}

- (void)stop
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
    [[self hostReach] stopNotifier];   
}

- (void)addObserver:(NSObject *)delegate
{
    [self addObserver:delegate forKeyPath:kConnectionAvailableKeyPath options:NSKeyValueObservingOptionNew context:nil];
}

- (void)removeObserver:(NSObject *)delegate
{
    [self removeObserver:delegate forKeyPath:kConnectionAvailableKeyPath];
}

- (void)dealloc
{
    [hostReach release];
    
    [super dealloc];
}

@end
