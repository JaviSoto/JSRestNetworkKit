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

#import "WebServiceRequestMock.h"

#define kCreationOfObjectsMaxDepth 2

@interface WebServiceRequestMock()
- (BOOL)urlContains:(NSString *)subStringInURL;
@end

@implementation WebServiceRequestMock

+ (WebServiceRequestMock *)mockRequestWithRequest:(WebServiceRequest *)request
{
    WebServiceRequestMock *mockRequest = [[self alloc] init];
    
    mockRequest.url = request.url;
    mockRequest.parameters = request.parameters;
    
    return [mockRequest autorelease];
}

- (void)runRequestWithSuccess:(void (^)(NSURLRequest *request, NSURLResponse *response, id JSON))success failure:(void (^)(NSURLRequest *request, NSURLResponse *response, NSError *error))failure
{    
    NSLog(@"%@", self.url);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSDictionary *response = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"ok", @"status", nil];
        
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        
        NSLog(@"URL %@ not implemented.", url);
        
        [pool drain];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            id JSON = [[NSDictionary alloc] initWithObjectsAndKeys:response, @"response", nil];
            [response release];
            
            [self logRequest:(NSURLRequest *)self response:nil JSON:JSON error:nil];
            
            success(nil, nil, JSON);
            [JSON release];
        });
    });
}
        
- (BOOL)urlContains:(NSString *)subStringInURL
{
    return ([self.url rangeOfString:subStringInURL].location != NSNotFound);
}

@end
