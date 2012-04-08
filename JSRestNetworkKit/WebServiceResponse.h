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

typedef enum {
    WSResponseUndefinedError        = 0,
    WSResponseNoError               = 200,

    WSResponseGlobalError           = 500,
} WebServiceResponseCode;

@interface WebServiceResponse : NSObject {
    WebServiceResponseCode code;
    NSString            *message;
    NSDictionary        *body;
    
    BOOL isFacebookAPI;
}

@property (nonatomic, assign) WebServiceResponseCode   code;
@property (nonatomic, retain) NSString              *message;
@property (nonatomic, retain) NSDictionary          *body;

- (id)initWithDictionary:(NSDictionary *)_dictionary;

- (BOOL)hasError;

@end
