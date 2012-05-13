//
//  TwitterRequestSigner.m
//  JSRestNetworkKitSampleProject
//
//  Created by Javier Soto on 5/13/12.
//  Copyright (c) 2012 JavierSoto. All rights reserved.
//

#import "TwitterRequestSigner.h"

#import "hmac.h"
#import "Base64Transcoder.h"

@interface TwitterRequestSigner()
@property (nonatomic, copy) NSString *baseURL;
@property (nonatomic, copy) NSString *consumerKey;
@property (nonatomic, copy) NSString *consumerSecret;
@property (nonatomic, copy) NSString *tokenKey;
@property (nonatomic, copy) NSString *tokenSecret;

@property (nonatomic, retain) NSString *presignatureURLString;

- (NSString *)signatureBaseStringForRequest:(JSWebServiceRequest *)request withTimestamp:(NSString *)timestamp nonce:(NSString *)nonce;
- (NSURL *)URLWithRequest:(JSWebServiceRequest *)request;
- (NSString *)URLStringWithoutQueryFromURL:(NSURL *)url;
- (NSString *)signClearText:(NSString *)text withSecret:(NSString *)secret;
- (NSString *)URLEncodedString:(NSString *)string;
@end

// Thanks to https://github.com/jdg/oauthconsumer and http://jaanus.com/post/1451098316/understanding-the-guts-of-twit
@implementation TwitterRequestSigner

@synthesize baseURL = _baseURL,
            consumerKey = _consumerKey,
            consumerSecret = _consumerSecret,
            tokenKey = _tokenKey,
            tokenSecret = _tokenSecret,
            presignatureURLString = _presignatureURLString;

- (id)initWithBaseURL:(NSString *)baseURL
          consumerKey:(NSString *)consumerKey
       consumerSecret:(NSString *)consumerSecret
             tokenKey:(NSString *)tokenKey
          tokenSecret:(NSString *)tokenSecret
{
    if ((self = [super init]))
    {
        self.baseURL = baseURL;
        self.consumerKey = consumerKey;
        self.consumerSecret = consumerSecret;
        self.tokenKey = tokenKey;
        self.tokenSecret = tokenSecret;
    }
    
    return self;
}

- (void)dealloc
{
    [_baseURL release];
    [_consumerKey release];
    [_consumerSecret release];
    [_tokenKey release];
    [_tokenSecret release];
    [_presignatureURLString release];
    
    [super dealloc];
}

#pragma mark - JSWebServiceRequestSigning

- (void)signRequest:(JSWebServiceRequest *)request
{
    NSString *consumerSecret = [self URLEncodedString:self.consumerSecret];
	NSString	 *tokenSecret = [self URLEncodedString:self.tokenSecret];
	
    NSString *timestamp = [NSString stringWithFormat:@"%d", (int)time(NULL)];
    
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
    CFRelease(theUUID);
    NSString *nonce = (NSString *)string;
    
    NSString *signatureBaseString = [self signatureBaseStringForRequest:request
                                                          withTimestamp:timestamp
                                                                  nonce:nonce];
    NSString *signature = [self signClearText:signatureBaseString
                                   withSecret:[NSString stringWithFormat:@"%@&%@", consumerSecret, tokenSecret]];
    
    NSString *oauthToken = [NSString stringWithFormat:@"oauth_token=\"%@\", ", [self URLEncodedString:self.tokenKey]];
    
    NSString *oauthHeader = [NSString stringWithFormat:
                             @"OAuth oauth_consumer_key=\"%@\", %@oauth_signature_method=\"%@\", oauth_signature=\"%@\", oauth_timestamp=\"%@\", oauth_nonce=\"%@\", oauth_version=\"1.0\"",
                             [self URLEncodedString:self.consumerKey],
                             oauthToken,
                             [self URLEncodedString:@"HMAC-SHA1"],
                             [self URLEncodedString:signature],
                             timestamp,
                             nonce
							 ];
    
    [request.headerFields setValue:oauthHeader forKey:@"Authorization"];
}

- (NSString *)URLEncodedParameterWithName:(NSString *)name value:(NSString *)value
{
    return [NSString stringWithFormat:@"%@=%@", name, [self URLEncodedString:value]];
}

- (NSString *)signatureBaseStringForRequest:(JSWebServiceRequest *)request withTimestamp:(NSString *)timestamp nonce:(NSString *)nonce
{
    // OAuth Spec, Section 9.1.1 "Normalize Request Parameters"
    // build a sorted array of both request parameters and OAuth header parameters
    NSMutableArray *parameterPairs = [NSMutableArray  arrayWithCapacity:(7 + [request.parameters.parametersDictionary count])]; // 6 being the number of OAuth params in the Signature Base String

    
	[parameterPairs addObject:[self URLEncodedParameterWithName:@"oauth_consumer_key" value:self.consumerKey]];
	[parameterPairs addObject:[self URLEncodedParameterWithName:@"oauth_signature_method" value:@"HMAC-SHA1"]];
	[parameterPairs addObject:[self URLEncodedParameterWithName:@"oauth_timestamp" value:timestamp]];
	[parameterPairs addObject:[self URLEncodedParameterWithName:@"oauth_nonce" value:nonce]];
	[parameterPairs addObject:[self URLEncodedParameterWithName:@"oauth_version" value:@"1.0"]];
    
    if (self.tokenKey.length > 0) [parameterPairs addObject:[self URLEncodedParameterWithName:@"oauth_token" value:self.tokenKey]];	//added for the Twitter OAuth implementation
    
    for (NSString *param in [request.parameters.parametersDictionary allKeys])
    {
        [parameterPairs addObject:[self URLEncodedParameterWithName:param value:[request.parameters.parametersDictionary valueForKey:param]]];
    }
    
    NSArray *sortedPairs = [parameterPairs sortedArrayUsingSelector:@selector(compare:)];
    NSString *normalizedRequestParameters = [sortedPairs componentsJoinedByString:@"&"];
    
    NSURL *url = [self URLWithRequest:request];
    
	self.presignatureURLString = [NSString stringWithFormat:@"%@?%@",
                                  [self URLStringWithoutQueryFromURL:url],
                                  normalizedRequestParameters];
    
    // OAuth Spec, Section 9.1.2 "Concatenate Request Elements"
    NSString *ret = [NSString stringWithFormat:@"%@&%@&%@",
					 [request requestTypeString],
					 [self URLEncodedString: [self URLStringWithoutQueryFromURL:url]],
					 [self URLEncodedString: normalizedRequestParameters]];
	
	return ret;
}

- (NSURL *)URLWithRequest:(JSWebServiceRequest *)request
{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", self.baseURL, request.path]];
}

- (NSString *)URLStringWithoutQueryFromURL:(NSURL *)url
{
    NSArray *parts = [[url absoluteString] componentsSeparatedByString:@"?"];
    return [parts objectAtIndex:0];
}

- (NSString *)signClearText:(NSString *)text withSecret:(NSString *)secret
{
    NSData *secretData = [[secret dataUsingEncoding:NSUTF8StringEncoding] retain];
    NSData *clearTextData = [[text dataUsingEncoding:NSUTF8StringEncoding] retain];
    unsigned char result[20];
    hmac_sha1((unsigned char *)[clearTextData bytes], [clearTextData length], (unsigned char *)[secretData bytes], [secretData length], result);
	[secretData release];
	[clearTextData release];
    
    //Base64 Encoding
    
    char base64Result[32];
    size_t theResultLength = 32;
    Base64EncodeData(result, 20, base64Result, &theResultLength);
    NSData *theData = [NSData dataWithBytes:base64Result length:theResultLength];
    
    NSString *base64EncodedResult = [[[NSString alloc] initWithData:theData encoding:NSUTF8StringEncoding] autorelease];
    
    return base64EncodedResult;
}

- (NSString *)URLEncodedString:(NSString *)string
{
	CFStringRef preprocessedString = CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault, (CFStringRef) string, CFSTR(""), kCFStringEncodingUTF8);
    NSString *result = (NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                           preprocessedString,
                                                                           NULL,
																		   CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                           kCFStringEncodingUTF8);
    [result autorelease];
	CFRelease(preprocessedString);
	return result;	
}

@end
