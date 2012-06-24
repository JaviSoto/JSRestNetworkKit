#JSRestNetworkKit v0.5.4
**JSRestNetworkKit** is a lightweight library to manage the backend of your iOS / Mac OSX applications perfect to work against a model-based REST backend.
It's a framework written on top of [AFNetworking](https://github.com/AFNetworking/AFNetworking) that allows to write the backend code of apps with very little code.

##Features:
- Automatic parsing of JSON just by defining your models and their properties. It allows you to map the server-side model entities to your own model classes.
- **Don't code all that usual boilerplate code** any more: parsing the JSON dictionaries with ```-valueForKey:```, having to deal with crashes because of ```NSNull``` or expecting an ```NSArray``` and getting an ```NSDictionary```, ```NSArray``` out of bounds, ```-initWithCoder:``` and ```- encodeWithCoder:```... **JSRestNetworkKit takes care of all that for you**.
- Implement the backend of your app and have it working (returning random data) without a working API server-side.
- Caching with very little code. Make your app behave better with no connection.
- Support to automatically insert parsed objects into CoreData.

##Components:
- ```JSRestClient```: Your entry point to make requests the API. Instantiate it with the base URL of your API, and optionally ```JSRequestSigning``` and ```JSResponseParser``` objects. Then pass ```JSRequest``` objects to execute them.
- ```JSRequest```: Holds all the information about a request: type (GET/POST/PUT/DELETE), the path (relative to the base URL of the Rest client), the parameters and optionally the request headers.
- ```JSRequestParameters```: Wrapper on top of NSMutableDictionary to store the parameters of a request.
- ```JSRequestSigning```: Protocol that you can conform to if you want to have the chance to alter a request just before it's sent off to the network. You can alter the request headers at that point, for example, to add authentication.
- ```JSResponseParser```: Protocol that you can conform to if you want to help ```JSRestClient``` distinguish between a successful and a failed request depending on the content of the response. For example, checking if the JSON contains an *error* dictionary.
- ```JSBaseEntity```: Class that your models must inherit from. Just implement the method ```+entityProperties``` and you get the JSON parsing for free.
- ```JSBaseCoreDataBackedEntity```: Works the same as ```JSBaseEntity```, but enables you to store the objects in CoreData.
- ```JSEntityProperty```: Holds the information about an entity field: key in the JSONs returned by the API, key of the property in the corresponding ```JSBaseEntity```/```JSBaseCoreDataBackedEntity``` object, type (numeric, string, relationship...) so it's parsed accordingly.

##How to use it:
- Clone the repo.
- Update the submodules recursively:

```bash
$ git submodule update --init --recursive
```
- Add ```JSRestNetworkKit``` to your Xcode project.
- Import ```JSRestNetworkKit.h```.
- Start playing with it (check out the sample project).

## Sample snippets

- This sample method makes a request to twitter and shows how easy it becomes to parse the response:

```objc
- (void)requestTwitterTimelineOfUser:(TwitterUser *)user successCallback:(TwitterRequestManagerSucessCallback)success errorCallback:(TwitterRequestManagerErrorCallback)error
{
    JSRequestParameters *parameters = [JSRequestParameters emptyRequestParameters];
    [parameters setValue:user.userID forKey:@"user_id"];
    
    JSRequest *request = [[[JSRequest alloc] initWithType:JSRequestTypeGET path:@"1/statuses/user_timeline.json" parameters:parameters] autorelease];
    
    NSString *userCacheKey = [NSString stringWithFormat:@"twitter_user_timeline_cache_%@", user.userID];
    
    [self.restClient makeRequest:request withCacheKey:userCacheKey parseBlock:^id(NSArray *tweetDictionaries) {        
		NSMutableArray *tweets = [NSMutableArray array];
        
	    for (NSDictionary *tweetDictionary in tweetDictionaries)
	    {
	        // This is where all the magic happens: initWithDictionary works out of the box, just because we defined the properties of the class Tweet in the method +entityProperties
	        Tweet *tweet = [[Tweet alloc] initWithDictionary:tweetDictionary];
	        [tweets addObject:tweet];
	        [tweet release];
	    }
	    
	    return tweets;
    } success:success error:error];
}
```
- More to come.

##Status:
The status of **JSRestNetworkitKit** is *work in progress*. And you may ask yourself: *why am I sharing this if it's not finished*? Well, [Jeff Atwood](http://www.codinghorror.com/blog/) convinced me to [embrace the suck](http://www.codinghorror.com/blog/2012/05/how-to-stop-sucking-and-be-awesome-instead.html).
Particularly this is what I'd like to do before considering ```JSRestNetworkKit``` stable:
- Some general refactoring / cleaning
- Adding some unit tests
- Add a Mac OSX sample app
- Better (and more complete) documentation

##ARC Support:
JSRestNetworkKit doesn't support ARC at the moment. If you want to integrate it in your ARC project, simply add the ```-fno-objc-arc``` linker option to each of the implementation files. [Quick tutorial](http://maniacdev.com/2012/01/easily-get-non-arc-enabled-open-source-libraries-working-in-arc-enabled-projects/)

##Contributors:
- [Oriol Blanc](https://github.com/oriolblanc). A lot of this is based on previous work of his. This wouldn't have been possible without his contribution and inspiration.
- [Matt Thompson](https://github.com/mattt). This wouldn't exist without [AFNetworking](https://github.com/AFNetworking/AFNetworking). I also have to thank him for encouraging me to publish this.
- Want to be in this list? Try this out, open an issue, fork it, open a pull request...

##License:
Copyright 2012 [Javier Soto](http://twitter.com/javisoto) (ios@javisoto.es)

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
 limitations under the License. 

Attribution is not required, but appreciated.
