//
//  TwitterRequestManager.h
//  JSRestNetworkKitSampleProject
//
//  Created by Javier Soto on 5/6/12.
//  Copyright (c) 2012 JavierSoto. All rights reserved.
//

typedef JSProxySuccessCallback TwitterRequestManagerSucessCallback;
typedef JSProxyErrorCallback TwitterRequestManagerErrorCallback;

@class TwitterUser;

@interface TwitterRequestManager : NSObject

- (id)init;

- (void)requestTimelineWithSuccessCallback:(TwitterRequestManagerSucessCallback)success
                             errorCallback:(TwitterRequestManagerErrorCallback)error;

- (void)requestUser:(TwitterUser *)user
    successCallback:(TwitterRequestManagerSucessCallback)success
      errorCallback:(TwitterRequestManagerErrorCallback)error;

- (void)requestUserTimeline:(TwitterUser *)user
            successCallback:(TwitterRequestManagerSucessCallback)success
              errorCallback:(TwitterRequestManagerErrorCallback)error;

@end
