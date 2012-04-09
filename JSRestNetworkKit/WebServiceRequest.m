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

#import "WebServiceRequest.h"
#import "WebServiceRequestParameters.h"

#import "AFJSONRequestOperation.h"

#define kImageJPEGCompressionFactor 0.4

#define WebServiceRequestDebug 1
#define WebServiceRequestDetailDebug 0

#if WebServiceRequestDebug
    #define WebServiceRequestNSLog(s,...)        NSLog(s, ##__VA_ARGS__)
#else
    #define WebServiceRequestNSLog(s,...)
#endif

#if WebServiceRequestDetailDebug
    #define WebServiceRequestDebugDetailLog(s,...)  NSLog(s, ##__VA_ARGS__)
#else
    #define WebServiceRequestDebugDetailLog(s,...)
#endif

@implementation WebServiceRequest
@synthesize requestType, url, parameters, files, requestHeaderFields, isPublic, retryLaterOnFailure;

- (id)initWithType:(WSRequestType)_type
               url:(NSString *)_url
        parameters:(WebServiceRequestParameters *)_parameters
{
    return [self initWithType:_type url:_url parameters:_parameters files:nil isPublic:NO];
}


- (id)initWithType:(WSRequestType)_type
               url:(NSString *)_url
        parameters:(WebServiceRequestParameters *)_parameters 
          isPublic:(BOOL)_isPublic
{
    if ((self = [self initWithIsPublic:_isPublic])) {
        self.requestType = _type;
        self.parameters = _parameters;
        self.files = nil;
                
        [self buildURL:_url];
    }
    
    return self;
}

- (id)initWithType:(WSRequestType)_type
               url:(NSString *)_url
        parameters:(WebServiceRequestParameters *)_parameters 
             files:(NSDictionary *)_files 
          isPublic:(BOOL)_isPublic
{
    if ((self = [self initWithIsPublic:_isPublic]) ) {
        self.requestType = _type;
        self.parameters = _parameters;
        self.files = _files;
        
        [self buildURL:_url];
    }
    
    return self;
}

- (id)initWithIsPublic:(BOOL)_isPublic
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.isPublic = _isPublic;
    self.retryLaterOnFailure = NO;
    self.requestHeaderFields = [NSMutableDictionary dictionary];
    
    return self;
}

#pragma mark - NSCoding methods

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super init]))
    {
        self.requestType = [aDecoder decodeIntForKey:@"requestType"];
        self.url = [aDecoder decodeObjectForKey:@"url"];
        self.parameters = [aDecoder decodeObjectForKey:@"parameters"];
        self.files = [aDecoder decodeObjectForKey:@"files"];
        self.isPublic = [aDecoder decodeBoolForKey:@"isPublic"];
        self.retryLaterOnFailure = [aDecoder decodeBoolForKey:@"retryLaterOnFailure"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInt:self.requestType forKey:@"requestType"];
    [aCoder encodeObject:self.url forKey:@"url"];
    [aCoder encodeObject:self.parameters forKey:@"parameters"];
    [aCoder encodeObject:self.files forKey:@"files"];
    [aCoder encodeBool:self.isPublic forKey:@"isPublic"];
    [aCoder encodeBool:self.retryLaterOnFailure forKey:@"retryLaterOnFailure"];
}

#pragma mark - Getters

- (BOOL)isPost
{
    return (self.requestType == WSRequestAPIMethodPOST);
}

- (BOOL)isGet
{
    return (self.requestType == WSRequestAPIMethodGET);
}

- (BOOL)isMultiForm
{
    return (self.requestType == WSRequestAPIMultiForm);  
}

- (BOOL)isPrivate
{
    return !isPublic;
}

- (NSString *)requestTypeString
{
    return (self.requestType == WSRequestAPIMethodGET) ? @"GET" : @"POST";
}

#pragma mark -

- (AFHTTPRequestOperation *)requestOperationWithSuccess:(void (^)(NSURLRequest *request, NSURLResponse *response, id JSON))success
                                                failure:(void (^)(NSURLRequest *request, NSURLResponse *response, NSError *error))failure
{
    NSMutableURLRequest *request = nil;
    
    switch (requestType) {
        case WSRequestAPIMethodGET:
        default:
        {
            request = [[WebServiceProxy instance] requestWithMethod:@"GET" path:self.url parameters:[parameters parametersDictionary]];
            break;
        } 
        case WSRequestAPIMultiForm:
        {
            failure(nil, nil, [NSError errorWithDomain:nil code:0 userInfo:[NSDictionary dictionaryWithObject:@"Type not implemented" forKey:@"userInfo"]]);
            return nil;
        }
        case WSRequestAPIMethodPOST:
        {
            request = [[WebServiceProxy instance] requestWithMethod:@"POST" path:self.url parameters:[parameters parametersDictionary]];
            break;
        }
    }
    
    
    NSMutableDictionary *allHeaders = [[request.allHTTPHeaderFields mutableCopy] autorelease];
    [allHeaders addEntriesFromDictionary:self.requestHeaderFields];
    [request setAllHTTPHeaderFields:allHeaders];
    
	if ([request URL] == nil || [[request URL] isEqual:[NSNull null]]) {
		return nil;
	}
    
    AFHTTPRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSURLResponse *response, id JSON) {
        [self logRequest:request response:response JSON:JSON error:nil];
        if (success)
        {
            success(request, response, JSON);
        }
    } failure:^(NSURLRequest *request, NSURLResponse *response, NSError *error, id JSON) {
        [self logRequest:request response:response JSON:JSON error:error];
        
        if (failure)
        {
            failure(request, response, error);
        }
    }];    
    
    return operation;
}

- (void)runRequestWithSuccess:(void (^)(NSURLRequest *request, NSURLResponse *response, id JSON))success
                      failure:(void (^)(NSURLRequest *request, NSURLResponse *response, NSError *error))failure
{
    AFHTTPRequestOperation *operation = [self requestOperationWithSuccess:success failure:failure];   
    if (operation)
    {
        WebServiceRequestNSLog(@"Starting request to URL %@", self.url);
        
        [[WebServiceProxy instance].operationQueue addOperation:operation];
    }
}

- (void)uploadProgress:(void (^)(float percent, int remainingSeconds))progess
                  success:(void (^)(NSURLRequest *request, NSURLResponse *response, id JSON))success
                  failure:(void (^)(NSURLRequest *request, NSURLResponse *response, NSError *error))failure
{    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *image = [files objectForKey:@"image"];
        
        NSData *imageData = UIImageJPEGRepresentation(image, kImageJPEGCompressionFactor);
        
        WebServiceRequestNSLog(@"Uploading image of %.1fKB", [imageData length]/1024.0);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSMutableURLRequest *request = [[WebServiceProxy instance] multipartFormRequestWithMethod:@"POST" path:self.url parameters:[parameters parametersDictionary] constructingBodyWithBlock: ^(id formData) {
                [formData appendPartWithFileData:imageData name:@"image" fileName:@"photo.png" mimeType:@"image/jpeg"];
            }];        
            
            [request setAllHTTPHeaderFields:self.requestHeaderFields];
            
            AFHTTPRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSURLResponse *response, id JSON) {
                [self logRequest:request response:response JSON:JSON error:nil];        
                success(request, response, JSON); 
            } failure:^(NSURLRequest *request, NSURLResponse *response, NSError *error, id JSON) {
                [self logRequest:request response:response JSON:JSON error:error];
                failure(request, response, error);        
            }];
            
            NSDate *timeOfDownloadStart = [NSDate date];
            [operation setUploadProgressBlock:^(NSInteger bytesWritten, NSInteger totalBytesWritten, NSInteger totalBytesExpectedToWrite) {
                CGFloat percentage = totalBytesWritten / (CGFloat)totalBytesExpectedToWrite;
                NSUInteger secondsRemaining = INT_MAX;            
                NSUInteger secondsElapsed = -[timeOfDownloadStart timeIntervalSinceNow];
                
                if (secondsElapsed > 0) { // Beware of division by 0!
                    CGFloat averageBytesPerSecond = totalBytesWritten / (float)secondsElapsed;
                    secondsRemaining = (int)(totalBytesExpectedToWrite - totalBytesWritten) / averageBytesPerSecond;
                }
                progess(percentage, secondsRemaining);
            }];
            
            WebServiceRequestNSLog(@"Starting upload request to URL %@", self.url);
            [[WebServiceProxy instance].operationQueue addOperation:operation];
        });
    });
}

- (void)logRequest:(NSURLRequest *)request response:(NSURLResponse *)response JSON:(id)JSON error:(NSError *)error
{
    #if WebServiceRequestDetailDebug
    
    WebServiceRequest *wsRequest = (WebServiceRequest *)request;
    
    NSString *requestURL = @"";
    NSString *httpMethod = @"";
    NSDictionary *requestHeaders = [NSDictionary dictionary];
    NSDictionary *responseHeaderFields = [NSDictionary dictionary];
    int responseStatusCode = 0;
    NSString *responseStatusCodeString = @"";
    
    if ([request isKindOfClass:[NSURLRequest class]])
    {
        requestURL = [request.URL absoluteString];
        httpMethod = request.HTTPMethod;
        requestHeaders = request.allHTTPHeaderFields;
        responseHeaderFields = [(NSHTTPURLResponse *)response allHeaderFields];
        responseStatusCode = [(NSHTTPURLResponse *)response statusCode];
        responseStatusCodeString = [NSHTTPURLResponse localizedStringForStatusCode:[(NSHTTPURLResponse *)response statusCode]];
    }
    else if ([request isKindOfClass:[WebServiceRequest class]])
    {
        requestURL = wsRequest.url;
        httpMethod = [wsRequest isPost] ? @"POST" : @"GET";        
    }
    
    if (error == nil)
    {  
        WebServiceRequestDebugDetailLog(@"[OK] %@ Request to URL: %@\nHeaders:\n%@\nParameters:\n%@\nFinished with response headers:\n%@ \nContent:\n%@", httpMethod, requestURL, requestHeaders, self.parameters, responseHeaderFields, JSON);
    }
    else
    {
        WebServiceRequestDebugDetailLog(@"[ERROR] %@ Request to URL: %@ \nHeaders:\n%@\nParameters:\n%@\nFailed with response headers:\n%@.\nError %d (%@):\n%@", httpMethod, requestURL, requestHeaders, self.parameters, responseHeaderFields,  responseStatusCode, responseStatusCodeString, [error localizedDescription]);
    }
    
    #endif
}

- (void)buildURL:(NSString *)_url
{ 
    self.url = [_url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

#pragma mark -

- (NSString *)description
{
    return [NSString stringWithFormat:@"Request to URL %@ with parameters %@", self.url, self.parameters];
}

#pragma mark - Memory Management

- (void)dealloc
{
    [parameters release];
    [files release];
    [requestHeaderFields release];
    [url release];
    
    [super dealloc];
}

@end
