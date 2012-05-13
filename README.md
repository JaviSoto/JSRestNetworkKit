#Description:

JSRestNetworkKit is a lightweight library to manage the backend of your iOS / Mac OSX applications perfect to work against a model-based REST backend.
It's a framework written on top of AFNetworking that allows to write the backend code of apps with very little code.

#Features:

- Automatic parsing of JSON just by defining your models and their properties.
- Safe against NSNull, objectAtIndex out of bounds, etc to avoid those usual crashes without boilerplate code
- Implement the backend of your app even and have it working (returning random data) before your backend team implementes the server side code (more on this later)
- Caching with very little code. Make your app behave better with no connection.
- Support to automatically insert parsed objects into your CoreData DB.

#Components:

#ARC:

JSRestNetworkKit doesn't support ARC at the moment. If you want to integrate it in your ARC project, simply add the ```-fno-objc-arc``` linker option to each of the implementation files. [Quick tutorial](http://maniacdev.com/2012/01/easily-get-non-arc-enabled-open-source-libraries-working-in-arc-enabled-projects/)

#Examples:

#Thanks to:
