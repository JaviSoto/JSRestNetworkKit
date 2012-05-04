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

#import "JSBaseWebServiceProxy.h"

#import "JSWebServiceRequest.h"
#import "JSWebServiceRequestRetryQueue.h"
#import "JSCache.h"

#import "JSWebServiceRequestSigning.h"

#import "AFNetworkActivityIndicatorManager.h"
#import "AFJSONRequestOperation.h"

#define WebServiceProxyDebug 1

#if WebServiceProxyDebug
    #define WebServiceProxyDebugLog(s,...) NSLog(@"%@", [NSString stringWithFormat:@"%@ %@", NSStringFromClass([self class]), [NSString stringWithFormat:s, ##__VA_ARGS__]])
#else
    #define WebServiceProxyDebugLog(s,...)
#endif

@interface JSBaseWebServiceProxy ()
@property (nonatomic, assign) dispatch_queue_t webProxyDispatchQueue;
@end

@implementation JSBaseWebServiceProxy
@synthesize webProxyDispatchQueue;
@synthesize requestSigner;

#pragma mark - Singleton

+ (JSBaseWebServiceProxy *)instance {
    static dispatch_once_t dispatchOncePredicate;
    static JSBaseWebServiceProxy *myInstance = nil;
        
    dispatch_once(&dispatchOncePredicate, ^{
        myInstance = [[JSBaseWebServiceProxy alloc] initWithBaseURL:[NSURL URLWithString:[JSBaseWebServiceProxy webServiceBaseURL]]];
        myInstance.webProxyDispatchQueue = dispatch_queue_create("WebProxyDispatchQueue", DISPATCH_QUEUE_CONCURRENT);
        
        [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];        
	});
    
    return myInstance;
}

#pragma mark - Request

- (void)makeRequest:(JSWebServiceRequest *)wsRequest
       withCacheKey:(NSString *)cacheKey
         parseBlock:(ProxyDataParsingBlock)parsingBlock
            success:(ProxySuccessCallback)successCallback
              error:(ProxyErrorCallback)errorCallback
{    
    dispatch_async(self.webProxyDispatchQueue, ^{
        if (cacheKey)
        {
            id cachedData = [[JSCache instance] cachedObjectForKey:cacheKey];
            if (cachedData)
            {
                dispatch_sync(dispatch_get_main_queue(), ^{
                    successCallback(cachedData, YES);
                });
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.requestSigner)
            {
                [self.requestSigner signRequest:wsRequest];
            }
            
            // run the request
            [wsRequest runRequestWithSuccess:^(NSURLRequest *request, NSURLResponse *response, id JSON) {                
                JSWebServiceResponse *wsResponse = [[[JSWebServiceResponse alloc] initWithDictionary:JSON] autorelease];
                if (![wsResponse hasError])
                {                
                    if (successCallback)
                    {
                        id parsedData = wsResponse.body;
                        
                        if (parsingBlock)
                        {
                            parsedData = parsingBlock(parsedData);
                        }
                        
                        if (cacheKey)
                        {
                            [[JSCache instance] cacheObject:parsedData forKey:cacheKey];
                        }
                        
                        successCallback(parsedData, NO);            
                    }
                }
                else
                { 
                    if (errorCallback)
                    {
                        errorCallback();
                    }
                }
                
            } failure:^(NSURLRequest *request, NSURLResponse *response, NSError *error) {
                if (errorCallback)
                {
                    errorCallback();
                }
                
                BOOL errorDueToConnectionProblem = response == nil;
                if (wsRequest.retryLaterOnFailure && errorDueToConnectionProblem)
                {
                    [[JSWebServiceRequestRetryQueue sharedRetryQueue] addRequestToRetryQueue:wsRequest];
                }
            }];
        });
    });
}

- (void)makeRequest:(JSWebServiceRequest *)wsRequest
            success:(ProxySuccessCallback)successCallback 
              error:(ProxyErrorCallback)errorCallback
{
    [self makeRequest:wsRequest withCacheKey:nil parseBlock:NULL success:successCallback error:errorCallback];
}

#pragma mark - URL Generation

+ (NSString *)webServiceBaseURL
{
    NSAssert(NO, @"%@ is an abstract class. You need to inherit from it and implement this method", NSStringFromClass([self class]));
    return @"";
}

#pragma mark - Memory Management

- (void)dealloc
{
    dispatch_release(self.webProxyDispatchQueue);
    [requestSigner release];
    
    [super dealloc];
}

@end 
