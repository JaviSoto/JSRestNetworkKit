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
