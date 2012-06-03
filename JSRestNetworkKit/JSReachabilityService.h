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

#define kConnectionAvailableKeyPath @"connectionAvailable"
#define kReachabilityConnectionBecomeAvailableNotification @"ReachabilityConnectionBecomeAvailableNotification"
#define kReachabilityConnectionBecomeUnAvailableNotification @"ReachabilityConnectionBecomeUnAvailableNotification"

@class Reachability;

@interface JSReachabilityService : NSObject
{
    Reachability *hostReach;
    BOOL connectionStatusSet;
}

@property (nonatomic, assign) BOOL connectionAvailable;

+ (JSReachabilityService *)instance;

- (void)start;
- (void)stop;

- (void)addObserver:(NSObject *)delegate;
- (void)removeObserver:(NSObject *)delegate;

@end
