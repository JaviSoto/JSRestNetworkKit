//
//  TwitterRequestSigner.h
//  JSRestNetworkKitSampleProject
//
//  Created by Javier Soto on 5/13/12.
//  Copyright (c) 2012 JavierSoto. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TwitterRequestSigner : NSObject <JSWebServiceRequestSigning>

- (id)initWithBaseURL:(NSString *)baseURL
          consumerKey:(NSString *)consumerKey
       consumerSecret:(NSString *)consumerSecret
             tokenKey:(NSString *)tokenKey
          tokenSecret:(NSString *)tokenSecret;

@end
