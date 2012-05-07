//
//  TwitterRequestManager.h
//  JSRestNetworkKitSampleProject
//
//  Created by Javier Soto on 5/6/12.
//  Copyright (c) 2012 JavierSoto. All rights reserved.
//

typedef JSProxySuccessCallback TwitterRequestManagerSucessCallback;
typedef JSProxyErrorCallback TwitterRequestManagerErrorCallback;

@interface TwitterRequestManager : NSObject

- (id)init;

- (void)requestTweetsWithSearch:(NSString *)search successCallback:(TwitterRequestManagerSucessCallback)success errorCallback:(TwitterRequestManagerErrorCallback)error;

@end
