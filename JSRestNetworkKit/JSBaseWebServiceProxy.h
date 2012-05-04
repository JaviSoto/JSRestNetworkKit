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

#import <Foundation/Foundation.h>

#import "JSWebServiceResponse.h"
#import "AFHTTPClient.h"

typedef void (^ProxySuccessCallback)(id data, BOOL cached);
typedef void (^ProxyErrorCallback)();
typedef id (^ProxyDataParsingBlock)(id data);

@class JSWebServiceRequest;
@protocol JSWebServiceRequestSigning;

@interface JSBaseWebServiceProxy : AFHTTPClient

/* Optional: set to be able to sign a request (by modifying its headers) before it's performed */
@property (nonatomic, retain) id<JSWebServiceRequestSigning> requestSigner;

+ (JSBaseWebServiceProxy *)instance;

- (void)makeRequest:(JSWebServiceRequest *)wsRequest 
            success:(ProxySuccessCallback)successCallback 
              error:(ProxyErrorCallback)errorCallback;

- (void)makeRequest:(JSWebServiceRequest *)wsRequest 
       withCacheKey:(NSString *)cacheKey
         parseBlock:(ProxyDataParsingBlock)parsingBlock
            success:(ProxySuccessCallback)successCallback 
              error:(ProxyErrorCallback)errorCallback;

/* Required: implement this method in your own subclass */
+ (NSString *)webServiceBaseURL;

@end
