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

#import "JSWebServiceRequestRetryQueue.h"

#import "JSWebServiceRequest.h"

#import "JSCache.h"
#import "JSReachabilityService.h"

#define kRequestsQueueCacheKey @"RequestsQueue"

#define WebServiceRequestRetryQueueDebug 1

#if WebServiceRequestRetryQueueDebug
    #define WebServiceRequestRetryQueueDebugLog(s,...) NSLog(@"%@", [NSString stringWithFormat:@"%@ %@", NSStringFromClass([self class]), [NSString stringWithFormat:s, ##__VA_ARGS__]])
#else
    #define WebServiceRequestRetryQueueDebugLog(s,...)
#endif

@interface JSWebServiceRequestRetryQueue()
@property (nonatomic, retain) NSMutableArray *queuedRequests;
@property (nonatomic, retain) NSOperationQueue *requestsRetryOperationQueue;

- (void)removeRequestFromRetryQueue:(JSWebServiceRequest *)request;
- (void)cachePendingRequests;
@end

@implementation JSWebServiceRequestRetryQueue

@synthesize queuedRequests, requestsRetryOperationQueue;

#pragma mark - Singleton

+ (JSWebServiceRequestRetryQueue *)sharedRetryQueue {
    static dispatch_once_t dispatchOncePredicate;
    static JSWebServiceRequestRetryQueue *myInstance = nil;
    
    dispatch_once(&dispatchOncePredicate, ^{
		myInstance = [[JSWebServiceRequestRetryQueue alloc] init];

        myInstance.queuedRequests = [NSMutableArray array];

        NSOperationQueue *_requestsRetryOperationQueue = [[NSOperationQueue alloc] init];
        _requestsRetryOperationQueue.maxConcurrentOperationCount = 1;
        [_requestsRetryOperationQueue setSuspended:YES];
        myInstance.requestsRetryOperationQueue = _requestsRetryOperationQueue;
        [_requestsRetryOperationQueue release];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [myInstance start];
        });
	});
    
    return myInstance;
}

- (void)start
{    
    NSMutableArray *cachedRequests = [[[JSCache instance] cachedObjectForKey:kRequestsQueueCacheKey] mutableCopy];
    
    WebServiceRequestRetryQueueDebugLog(@"Starting. Adding %d operations to the queue", self.queuedRequests.count);
    
    if (cachedRequests)
    {
        for (JSWebServiceRequest *request in cachedRequests)
        {
            [self addRequestToRetryQueue:request];
        }
    }
    
    [cachedRequests release];
    
    [[JSReachabilityService instance] addObserver:self];
}

#pragma mark - Retry Queue

- (void)addRequestToRetryQueue:(JSWebServiceRequest *)request
{
    dispatch_async(dispatch_get_main_queue(), ^{
        WebServiceRequestRetryQueueDebugLog(@"Adding request to URL %@ to the queue", request.url);
        
        request.retryLaterOnFailure = NO; // So when this one is tried again, if it fails, it doesn't get added to the queue again.
        
        [self.queuedRequests addObject:request];
        [self cachePendingRequests];
        
        AFHTTPRequestOperation *operation = [request requestOperationWithSuccess:^(NSURLRequest *r, NSURLResponse *response, id JSON) {
            [self removeRequestFromRetryQueue:request];
        } failure:^(NSURLRequest *r, NSURLResponse *response, NSError *error) {
            [self removeRequestFromRetryQueue:request];
            [self addRequestToRetryQueue:request]; // So that it gets queued again
        }];
        
        [self.requestsRetryOperationQueue addOperation:(NSOperation *)operation];
    });
}

- (void)removeRequestFromRetryQueue:(JSWebServiceRequest *)request
{
    @synchronized(self)
    {
        WebServiceRequestRetryQueueDebugLog(@"Removing request to URL %@ from the queue", request.url);
        [queuedRequests removeObject:request];
        [self cachePendingRequests];
    }
}

- (void)removeAllRequestsFromRetryQueue
{
    @synchronized(self)
    {
        #if WebServiceRequestRetryQueueDebug
            NSLog(@"[RetryQueue] %s", (char *)_cmd);
        #endif
        
        [queuedRequests removeAllObjects];
        [self.requestsRetryOperationQueue cancelAllOperations];
        [self cachePendingRequests];
    }
}

#pragma mark - Reachability Change

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:kConnectionAvailableKeyPath])
    {
        BOOL connectionAvailable = [[change valueForKey:NSKeyValueChangeNewKey] boolValue];
        
        [requestsRetryOperationQueue setSuspended:!connectionAvailable];
    }
}

#pragma mark - Background status change

- (void)cachePendingRequests
{
    WebServiceRequestRetryQueueDebugLog(@"Persisting %d requests", self.queuedRequests.count);
    
    if (self.queuedRequests.count > 0)
    {
        [[JSCache instance] cacheObject:self.queuedRequests forKey:kRequestsQueueCacheKey];
    }
    else
    {
        [[JSCache instance] invalidateCachedObjectForKey:kRequestsQueueCacheKey];
    }
}

#pragma mark - Memory management

- (void)dealloc
{
    [queuedRequests release];
    [requestsRetryOperationQueue release];
    [[JSReachabilityService instance] removeObserver:self];
    
    [super dealloc];
}

@end
