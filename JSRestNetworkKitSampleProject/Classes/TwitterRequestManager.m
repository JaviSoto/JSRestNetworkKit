//
//  TwitterRequestManager.m
//  JSRestNetworkKitSampleProject
//
//  Created by Javier Soto on 5/6/12.
//  Copyright (c) 2012 JavierSoto. All rights reserved.
//

#import "TwitterRequestManager.h"
#import "JSRequest.h"
#import "JSRequestParameters.h"

#import "TwitterRequestSigner.h"
#import "TwitterResponseParser.h"

#import "Tweet.h"
#import "TwitterUser.h"

@interface TwitterRequestManager ()
{
    JSRESTClient *_webProxy;
}
@end

@implementation TwitterRequestManager

- (id)init
{
    if ((self = [super init]))
    {
        NSString *baseURL = @"https://api.twitter.com";
        
        TwitterResponseParser *responseParser = [[TwitterResponseParser alloc] init];
        TwitterRequestSigner *requestSigner = [[TwitterRequestSigner alloc] initWithBaseURL:baseURL
                                                                                consumerKey:@"AAuensXl4zk0V3UEw6wHPQ"
                                                                             consumerSecret:@"SRWGf0aQZjnnsjlECeDLTm5XkxGiAtuVtR6wCK6HrDo"
                                                                                   tokenKey:@"579275196-4mkKjxoiIwP1HDyJwD8f2JVXK70pdx6JHJQL5vml"
                                                                                tokenSecret:@"4NCaeKXp3GIQmCQSh4IUPiZHZo9dYXxt2yASdd4uaqc"];
        
        _webProxy = [[JSRESTClient alloc] initWithBaseURL:[NSURL URLWithString:baseURL] requestSigner:requestSigner responseParser:responseParser];
        
        [requestSigner release];
        [responseParser release];
    }
        
    return self;
}

- (JSProxyDataParsingBlock)parseBlockForArrayOfTweets
{
    return [[^id(NSArray *tweetDictionaries) {        
        NSMutableArray *tweets = [NSMutableArray array];
        
        for (NSDictionary *tweetDictionary in tweetDictionaries)
        {
            // This is where all the magic happens: initWithDictionary works out of the box, just because we defined the properties of the class Tweet in the method +entityProperties
            Tweet *tweet = [[Tweet alloc] initWithDictionary:tweetDictionary];
            [tweets addObject:tweet];
            [tweet release];
        }
        
        return tweets;
    } copy] autorelease];
}

/* https://dev.twitter.com/docs/api/1/get/statuses/home_timeline */

- (void)requestTimelineWithSuccessCallback:(TwitterRequestManagerSucessCallback)success errorCallback:(TwitterRequestManagerErrorCallback)error;
{
    JSRequestParameters *parameters = [JSRequestParameters emptyRequestParameters];
    
    // I create a GET request object with the path and parameters.
    JSRequest *request = [[JSRequest alloc] initWithType:JSRequestTypeGET path:@"1/statuses/home_timeline.json" parameters:parameters];
    
    /* - I make the request passing a cache key. If another request is made with the same cache key, the successCallback will be called inmediately with the last saved cached data
     - The parse block has to be implemented so that, taking the raw dictionary, it returns parsed data ready to be cached and returned
     - This is where most of the code is saved, as I only need to call - initWithDictionary: and the model class knows how to instantiate itself just because the attributes are defined (see Tweet.m) */
    [_webProxy makeRequest:request
              withCacheKey:@"timeline"
                parseBlock:[self parseBlockForArrayOfTweets]
                   success:success
                     error:error];
    
    [request release];
}

/* https://dev.twitter.com/docs/api/1/get/users/show */
- (void)requestUser:(TwitterUser *)user successCallback:(TwitterRequestManagerSucessCallback)success errorCallback:(TwitterRequestManagerErrorCallback)error
{
    JSRequestParameters *parameters = [JSRequestParameters emptyRequestParameters];
    [parameters setValue:user.userID forKey:@"user_id"];
    
    JSRequest *request = [[JSRequest alloc] initWithType:JSRequestTypeGET path:@"1/users/show.json" parameters:parameters];

    NSString *userCacheKey = [NSString stringWithFormat:@"twitter_user_cache_%@", user.userID];
    
    [_webProxy makeRequest:request withCacheKey:userCacheKey parseBlock:^id(NSDictionary *userInfo) {
        [user parseDictionary:userInfo];
        return user;
    } success:success error:error];
    
    [request release];
}

/* https://dev.twitter.com/docs/api/1/get/statuses/user_timeline */
- (void)requestUserTimeline:(TwitterUser *)user successCallback:(TwitterRequestManagerSucessCallback)success errorCallback:(TwitterRequestManagerErrorCallback)error
{
    JSRequestParameters *parameters = [JSRequestParameters emptyRequestParameters];
    [parameters setValue:user.userID forKey:@"user_id"];
    
    JSRequest *request = [[JSRequest alloc] initWithType:JSRequestTypeGET path:@"1/statuses/user_timeline.json" parameters:parameters];
    
    NSString *userCacheKey = [NSString stringWithFormat:@"twitter_user_timeline_cache_%@", user.userID];
    
    [_webProxy makeRequest:request
              withCacheKey:userCacheKey
                parseBlock:[self parseBlockForArrayOfTweets]
                   success:success
                     error:error];
    
    [request release];
}

#pragma mark - Memory Management

- (void)dealloc
{
    [_webProxy release];
    
    [super dealloc];
}
    
@end
