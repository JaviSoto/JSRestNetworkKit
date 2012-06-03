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

#import "JSRestClient.h"

typedef enum {
    JSRequestTypeGET,
    JSRequestTypePOST,
    JSRequestTypePUT,
    JSRequestTypeDELETE
} JSRequestType;

@class JSRequestParameters;

@interface JSRequest : NSObject <NSCoding>

@property (atomic, assign) JSRequestType type;
@property (nonatomic, copy) NSString *path;
@property (atomic, retain) JSRequestParameters *parameters;
@property (atomic, retain) NSMutableDictionary *headerFields;

- (id)initWithType:(JSRequestType)method
              path:(NSString *)path
        parameters:(JSRequestParameters *)parameters;

- (NSString *)requestTypeString;

@end
