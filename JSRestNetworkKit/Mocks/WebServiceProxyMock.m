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

#import "WebServiceProxyMock.h"
#import "WebServiceRequestMock.h"

#import "AFNetworkActivityIndicatorManager.h"

#import "JSCache.h"

#define kShouldSleepBeforeReturningData YES

@implementation WebServiceProxyMock

+ (WebServiceProxy *)instance {
    static dispatch_once_t dispatchOncePredicate;
    static WebServiceProxyMock *myInstance = nil;
    
    dispatch_once(&dispatchOncePredicate, ^{
        myInstance = [[WebServiceProxyMock alloc] initWithBaseURL:[NSURL URLWithString:@"http://dummy"]];
	});
    
    return myInstance;
}

- (id)initWithBaseURL:(NSURL *)url
{
    if ((self = [super initWithBaseURL:url]))
    {
        NSLog(@"Starting app with WebServiceProxyMock ENABLED");
    }
    
    return self;
}

- (void)makeRequest:(WebServiceRequest *)wsRequest withCacheKey:(NSString *)cacheKey parseBlock:(ProxyDataParsingBlock)parsingBlock success:(ProxySuccessCallback)successCallback error:(ProxyErrorCallback)errorCallback
{
    static const CGFloat kMockRequestMaxDurationInSeconds = 1.4f;
    static const NSInteger kMockRequestFailuresPerHundred = 5;
//    static const NSInteger kMockRequestFailuresPerHundred = 0;
    static const NSInteger kMilisecondsInASecond = 1000000;
    
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (cacheKey)
        {
            id cachedObject = [[JSCache instance] cachedObjectForKey:cacheKey];
            
            if (cachedObject)
            {
                if (successCallback)
                {
                    successCallback(cachedObject, YES);
                }
            }
        }
        if (kShouldSleepBeforeReturningData)
        {
            usleep((arc4random() % kMilisecondsInASecond) * (kMockRequestMaxDurationInSeconds));
        }
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            BOOL failure = ((arc4random() % 100) < kMockRequestFailuresPerHundred);
            
            if (!failure)
            {    
                WebServiceRequestMock *requestMock = [WebServiceRequestMock mockRequestWithRequest:wsRequest];                
                
                [requestMock runRequestWithSuccess:^(NSURLRequest *request, NSURLResponse *response, id JSON) {
                    [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
                    WebServiceResponse *wsResponse = [[[WebServiceResponse alloc] initWithDictionary:JSON] autorelease];
                    if (wsResponse.code == WSResponseNoError)
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
                            errorCallback(wsResponse, nil);
                        }
                    }
                } failure:^(NSURLRequest *request, NSURLResponse *response, NSError *error) {
                    [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
                    if (errorCallback)
                        errorCallback(nil, error);
                }];
            }
            else
            {
                [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
                if (errorCallback)
                    errorCallback(nil, nil);
            }
        });
    });
}

- (void)makeRequest:(WebServiceRequest *)wsRequest success:(ProxySuccessCallback)successCallback error:(ProxyErrorCallback)errorCallback
{
    [self makeRequest:wsRequest withCacheKey:nil parseBlock:NULL success:successCallback error:errorCallback];
}

@end
