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

#import "JSRestClient.h"

#import "JSRequest.h"
#import "JSCache.h"

#import "JSRequestSigning.h"

#import "AFNetworkActivityIndicatorManager.h"
#import "AFJSONRequestOperation.h"

#define WebServiceProxyDebug 1

#if WebServiceProxyDebug
    #define WebServiceProxyDebugLog(s,...) NSLog(@"%@", [NSString stringWithFormat:@"%@ %@", NSStringFromClass([self class]), [NSString stringWithFormat:s, ##__VA_ARGS__]])
#else
    #define WebServiceProxyDebugLog(s,...)
#endif

@interface JSRestClient ()
{
    dispatch_queue_t _webProxyDispatchQueue;
}
- (AFHTTPRequestOperation *)operationForRequest:(JSRequest *)request
                                        success:(void (^)(NSURLRequest *request, NSURLResponse *response, id JSON))success
                                        failure:(void (^)(NSURLRequest *request, NSURLResponse *response, NSError *error))failure;

- (void)runRequest:(JSRequest *)request
           success:(void (^)(NSURLRequest *request, NSURLResponse *response, id JSON))success
           failure:(void (^)(NSURLRequest *request, NSURLResponse *response, NSError *error))failure;
@end

@implementation JSRestClient
@synthesize requestSigner = _requestSigner;
@synthesize responseParser = _responseParser;

- (id)initWithBaseURL:(NSURL *)url
{
    if ((self = [super initWithBaseURL:url]))
    {
        _webProxyDispatchQueue = dispatch_queue_create("JSWebProxyDispatchQueue", DISPATCH_QUEUE_CONCURRENT);
    }
    
    return self;
}

- (id)initWithBaseURL:(NSURL *)baseURL
        requestSigner:(id<JSRequestSigning>)requestSigner
       responseParser:(id<JSResponseParser>)responseParser
{
    if ((self = [self initWithBaseURL:baseURL]))
    {
        self.requestSigner = requestSigner;
        self.responseParser = responseParser;
        
        #warning TODO: make optional?
        [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    }
    
    return self;
}

- (id)initWithBaseURL:(NSURL *)baseURL
       responseParser:(id<JSResponseParser>)responseParser
{
    return [self initWithBaseURL:baseURL requestSigner:nil responseParser:responseParser];
}

#pragma mark - Request

- (void)makeRequest:(JSRequest *)request
       withCacheKey:(NSString *)cacheKey
         parseBlock:(JSProxyDataParsingBlock)parsingBlock
            success:(JSProxySuccessCallback)successCallback
              error:(JSProxyErrorCallback)errorCallback
{    
    dispatch_async(_webProxyDispatchQueue, ^{
        if (cacheKey)
        {
            id cachedData = [[JSCache sharedCache] cachedObjectForKey:cacheKey];
            if (cachedData)
            {
                dispatch_sync(dispatch_get_main_queue(), ^{
                    successCallback(cachedData, YES);
                });
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.requestSigner)
                [self.requestSigner signRequest:request];
            
            [self runRequest:request success:^(NSURLRequest *request, NSURLResponse *urlResponse, id JSON) {
                if (!self.responseParser || [self.responseParser responseIsSuccessfulWithDictionary:JSON])
                {
                    id parsedData = (self.responseParser != nil && [self.responseParser respondsToSelector:@selector(dataFromResponseDictionary:)]) ? [self.responseParser dataFromResponseDictionary:JSON] : JSON;
                    
                    if (parsingBlock)
                        parsedData = parsingBlock(parsedData);
                    
                    if (cacheKey)
                        [[JSCache sharedCache] cacheObject:parsedData forKey:cacheKey];

                    if (successCallback)
                        successCallback(parsedData, NO);            
                }
                else
                { 
                    if (errorCallback)
                        errorCallback();
                }
                
            } failure:^(NSURLRequest *request, NSURLResponse *response, NSError *error) {
                if (errorCallback)
                    errorCallback();
            }];
        });
    });
}

- (void)makeRequest:(JSRequest *)request
            success:(JSProxySuccessCallback)successCallback 
              error:(JSProxyErrorCallback)errorCallback
{
    [self makeRequest:request withCacheKey:nil parseBlock:NULL success:successCallback error:errorCallback];
}

#pragma mark - Build request Operation

- (AFHTTPRequestOperation *)operationForRequest:(JSRequest *)request
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

- (void)runRequest:(JSRequest *)request
           success:(void (^)(NSURLRequest *request, NSURLResponse *response, id JSON))success
                      failure:(void (^)(NSURLRequest *request, NSURLResponse *response, NSError *error))failure
{
    AFHTTPRequestOperation *operation = [self operationForRequest:request success:success failure:failure];

    NSAssert(operation, @"Couldn't create an operation for request %@", request);
    [self.operationQueue addOperation:operation];
}

#pragma mark - Memory Management

- (void)dealloc
{
    dispatch_release(_webProxyDispatchQueue);
    [_requestSigner release];
    [_responseParser release];
    
    [super dealloc];
}

@end 
