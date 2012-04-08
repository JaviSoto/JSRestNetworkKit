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
#import "WebServiceProxy.h"

typedef enum {
    WSRequestAPIMethodGET       = 100,
    WSRequestAPIMethodPOST      = 200,
    WSRequestAPIMultiForm       = 300,
} WSRequestType;

@class WebServiceRequestParameters;

@interface WebServiceRequest : NSObject <NSCoding>
{
    WSRequestType requestType;
    NSString *url;
    WebServiceRequestParameters *parameters;
    NSDictionary *files;
    NSMutableDictionary *requestHeaderFields;
    
    BOOL isPublic;
    
    BOOL retryLaterOnFailure;
}

@property (atomic, assign) WSRequestType requestType;
@property (atomic, retain) NSString *url;
@property (atomic, retain) WebServiceRequestParameters *parameters;
@property (atomic, retain) NSDictionary *files;
@property (atomic, retain) NSMutableDictionary *requestHeaderFields;

@property (atomic, assign) BOOL isPublic;

@property (atomic, assign) BOOL retryLaterOnFailure;

- (id)initWithIsPublic:(BOOL)_isPublic;

- (id)initWithType:(WSRequestType)_method
               url:(NSString *)_url
        parameters:(WebServiceRequestParameters *)_parameters;

- (id)initWithType:(WSRequestType)_method
               url:(NSString *)_url
        parameters:(WebServiceRequestParameters *)_parameters 
          isPublic:(BOOL)isPublic;

- (id)initWithType:(WSRequestType)_type
               url:(NSString *)_url
        parameters:(WebServiceRequestParameters *)_parameters 
             files:(NSDictionary *)_files 
          isPublic:(BOOL)_isPublic;

// Getters
- (BOOL)isPost;
- (BOOL)isGet;
- (BOOL)isMultiForm;
- (BOOL)isPrivate;

- (NSString *)requestTypeString;

- (void)buildURL:(NSString *)url;

- (AFHTTPRequestOperation *)requestOperationWithSuccess:(void (^)(NSURLRequest *request, NSURLResponse *response, id JSON))success
                                                failure:(void (^)(NSURLRequest *request, NSURLResponse *response, NSError *error))failure;
- (void)runRequestWithSuccess:(void (^)(NSURLRequest *request, NSURLResponse *response, id JSON))success
                      failure:(void (^)(NSURLRequest *request, NSURLResponse *response, NSError *error))failure;

- (void)uploadProgress:(void (^)(float percent, int remainingSeconds))progess
               success:(void (^)(NSURLRequest *request, NSURLResponse *response, id JSON))success
               failure:(void (^)(NSURLRequest *request, NSURLResponse *response, NSError *error))failure;

- (void)logRequest:(NSURLRequest *)request response:(NSURLResponse *)response JSON:(id)JSON error:(NSError *)error;

@end
