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

#import "JSWebServiceResponseParser.h"
#import "AFHTTPClient.h"

typedef void (^JSProxySuccessCallback)(id data, BOOL cached);
typedef void (^JSProxyErrorCallback)();
typedef id (^JSProxyDataParsingBlock)(id data);

@class JSWebServiceRequest;
@protocol JSWebServiceRequestSigning;

@interface JSWebServiceProxy : AFHTTPClient

/* Optional: set to be able to sign a request (by modifying its headers) before it's performed */
@property (nonatomic, retain) id<JSWebServiceRequestSigning>requestSigner;

/* Optional: set to be able to distinguish a successful and a failing request according to the response content */
@property (nonatomic, retain) id<JSWebServiceResponseParser>responseParser;

- (id)initWithBaseURL:(NSURL *)baseURL
        requestSigner:(id<JSWebServiceRequestSigning>)requestSigner
       responseParser:(id<JSWebServiceResponseParser>)responseParser;

- (id)initWithBaseURL:(NSURL *)baseURL
       responseParser:(id<JSWebServiceResponseParser>)responseParser;

- (void)makeRequest:(JSWebServiceRequest *)request
            success:(JSProxySuccessCallback)successCallback 
              error:(JSProxyErrorCallback)errorCallback;

- (void)makeRequest:(JSWebServiceRequest *)request
       withCacheKey:(NSString *)cacheKey
         parseBlock:(JSProxyDataParsingBlock)parsingBlock
            success:(JSProxySuccessCallback)successCallback 
              error:(JSProxyErrorCallback)errorCallback;

@end
