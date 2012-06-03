#Description:

**JSRestNetworkKit** is a lightweight library to manage the backend of your iOS / Mac OSX applications perfect to work against a model-based REST backend.
It's a framework written on top of AFNetworking that allows to write the backend code of apps with very little code.

#Features:

- Automatic parsing of JSON just by defining your models and their properties. It allows you to map the server-side model entities to your own model classes.
- **Don't code all that usual boilerplate code** any more: parsing the JSON dictionaries with ```-valueForKey:```, having to deal with crashes because of ```NSNull``` or expecting an ```NSArray``` and getting an ```NSDictionary```, ```NSArray``` out of bounds, ```-initWithCoder:``` and ```- encodeWithCoder:```... **JSRestNetworkKit takes care of all that for you**.
- Implement the backend of your app and have it working (returning random data) even before your backend team implementes the server side code (more on this later)
- Caching with very little code. Make your app behave better with no connection.
- Support to automatically insert parsed objects into your CoreData DB.

#Components:

#ARC:

JSRestNetworkKit doesn't support ARC at the moment. If you want to integrate it in your ARC project, simply add the ```-fno-objc-arc``` linker option to each of the implementation files. [Quick tutorial](http://maniacdev.com/2012/01/easily-get-non-arc-enabled-open-source-libraries-working-in-arc-enabled-projects/)

#Examples:

#Thanks to:

#License:

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

Attribution is not required, but appreciated.
