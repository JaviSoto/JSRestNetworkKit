//
//  TwitterRequestManager.m
//  JSRestNetworkKitSampleProject
//
//  Created by Javier Soto on 5/6/12.
//  Copyright (c) 2012 JavierSoto. All rights reserved.
//

#import "TwitterRequestManager.h"
#import "JSWebServiceRequest.h"
#import "JSWebServiceRequestParameters.h"

@interface TwitterRequestManager ()
{
    JSWebServiceProxy *_webProxy;
}
@end

@implementation TwitterRequestManager

- (id)init
{
    if ((self = [super init]))
    {
        _webProxy = [[JSWebServiceProxy alloc] initWithBaseURL:[NSURL URLWithString:@"http://search.twitter.com"]];
    }
        
    return self;
}

- (void)requestTimelineWithSuccessCallback:(TwitterRequestManagerSucessCallback)success errorCallback:(TwitterRequestManagerErrorCallback)error
{
    JSWebServiceRequestParameters *parameters = [JSWebServiceRequestParameters emptyRequestParameters];
    [parameters setValue:@"iphone" forKey:@"q"];
    
    JSWebServiceRequest *request = [[JSWebServiceRequest alloc] initWithType:JSWebServiceRequestTypeGET path:@"search.json" parameters:parameters];
    
    [_webProxy makeRequest:request success:^(id data, BOOL cached) {
        NSLog(@"data %@", data);
    } error:error];
}

#pragma mark - Memory Management

- (void)dealloc
{
    [_webProxy release];
    
    [super dealloc];
}
    
@end
