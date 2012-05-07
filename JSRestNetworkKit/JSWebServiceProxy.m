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

#import "JSWebServiceProxy.h"

#import "JSWebServiceRequest.h"
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

@interface JSWebServiceProxy ()
@property (nonatomic, assign) dispatch_queue_t webProxyDispatchQueue;

- (AFHTTPRequestOperation *)operationForRequest:(JSWebServiceRequest *)request
                                        success:(void (^)(NSURLRequest *request, NSURLResponse *response, id JSON))success
                                        failure:(void (^)(NSURLRequest *request, NSURLResponse *response, NSError *error))failure;

- (void)runRequest:(JSWebServiceRequest *)request
           success:(void (^)(NSURLRequest *request, NSURLResponse *response, id JSON))success
           failure:(void (^)(NSURLRequest *request, NSURLResponse *response, NSError *error))failure;
@end

@implementation JSWebServiceProxy
@synthesize webProxyDispatchQueue;
@synthesize requestSigner;

#pragma mark - Singleton

- (id)initWithBaseURL:(NSURL *)url
{
    if ((self = [super initWithBaseURL:url]))
    {
        self.webProxyDispatchQueue = dispatch_queue_create("JSWebProxyDispatchQueue", DISPATCH_QUEUE_CONCURRENT);
        
        #warning TODO: make optional?
        [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    }
    
    return self;
}

#pragma mark - Request

- (void)makeRequest:(JSWebServiceRequest *)request
       withCacheKey:(NSString *)cacheKey
         parseBlock:(JSProxyDataParsingBlock)parsingBlock
            success:(JSProxySuccessCallback)successCallback
              error:(JSProxyErrorCallback)errorCallback
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
                [self.requestSigner signRequest:request];
            }
            
            // run the request
            [self runRequest:request success:^(NSURLRequest *request, NSURLResponse *urlResponse, id JSON) {
                JSWebServiceResponse *response = [[[JSWebServiceResponse alloc] initWithDictionary:JSON] autorelease];
                if (![response hasError])
                {                
                    if (successCallback)
                    {
                        id parsedData = response.body;
                        
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
            }];
        });
    });
}

- (void)makeRequest:(JSWebServiceRequest *)request
            success:(JSProxySuccessCallback)successCallback 
              error:(JSProxyErrorCallback)errorCallback
{
    [self makeRequest:request withCacheKey:nil parseBlock:NULL success:successCallback error:errorCallback];
}

#pragma mark - Build request Operation

- (AFHTTPRequestOperation *)operationForRequest:(JSWebServiceRequest *)request
                                        success:(void (^)(NSURLRequest *request, NSURLResponse *response, id JSON))success
                                        failure:(void (^)(NSURLRequest *request, NSURLResponse *response, NSError *error))failure;
{
    NSMutableURLRequest *urlRequest = [self requestWithMethod:request.requestTypeString path:request.path parameters:request.parameters.parametersDictionary];
    
    NSMutableDictionary *allHeaders = [[urlRequest.allHTTPHeaderFields mutableCopy] autorelease];
    [allHeaders addEntriesFromDictionary:request.headerFields];
    [urlRequest setAllHTTPHeaderFields:allHeaders];
    
	if (urlRequest.URL == nil || [urlRequest.URL isEqual:[NSNull null]])
    {
		return nil;
	}
    
    AFHTTPRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:urlRequest success:^(NSURLRequest *urlReq, NSURLResponse *response, id JSON) {
        if (success)
        {
            success(urlReq, response, JSON);
        }
    } failure:^(NSURLRequest *urlReq, NSURLResponse *response, NSError *error, id JSON) {
        if (failure)
        {
            failure(urlReq, response, error);
        }
    }];    
    
    return operation;
}

- (void)runRequest:(JSWebServiceRequest *)request
           success:(void (^)(NSURLRequest *request, NSURLResponse *response, id JSON))success
                      failure:(void (^)(NSURLRequest *request, NSURLResponse *response, NSError *error))failure
{
    AFHTTPRequestOperation *operation = [self operationForRequest:request success:success failure:failure];

    NSAssert(operation != nil, @"Couldn't create an operation for request %@", request);
    [self.operationQueue addOperation:operation];
}

#pragma mark - Memory Management

- (void)dealloc
{
    dispatch_release(self.webProxyDispatchQueue);
    [requestSigner release];
    
    [super dealloc];
}

@end 
