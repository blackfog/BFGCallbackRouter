# Purpose

``BFGCallbackRouter`` is an implementation of the [x-callback-url 1.0 DRAFT Spec](http://x-callback-url.com/specifications/) in Objective-C for use in iOS applications. The intention was to create a simple, light, and flexible implementation.

# Overview

The router is best placed inside your application's app delegate and retained as a property.

`````objective-c
#import "BFGCallbackRouter.h"

…

@property (nonatomic, strong) BFGCallbackRouter *router;

…

@synthesize router;

…

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.router = [[BFGCallbackRouter alloc] init];
}
`````

## Adding Actions

Actions can be added to the router using one of three methods:

`````objective-c
- (void)addAction:(NSString *)action scheme:(NSString *)scheme notificationName:(NSString *)notificationName;
- (void)addAction:(NSString *)action scheme:(NSString *)scheme delegate:(id<BFGCallbackDelegate>)delegate;
- (void)addAction:(NSString *)action scheme:(NSString *)scheme handler:(BFGCallbackActionHandler)handler;
`````

The action is the name of the x-callback-url action parameter from your URL. In `app://x-callback-url/foo` the action is `foo`. The scheme is the URL scheme from your application (in the above example, `app`). The router supports multiple URL schemes if your app requires it (or is implementing a library or framework with its own scheme you need to integrate like the [TextExpander touch SDK](https://github.com/SmileSoftware/TextExpanderTouchSDK)).

### Actions via Notification

If you call the `notificationName` variant of `-addAction`, the name you specify will be the name of a notification posted when the callback is received. The `object` property of the `NSNotification` object sent will contain a `BFGCallback` object representing the callback parameters sent. (More on this below.)

`````objective-c
[self.router addAction:@"foo" scheme:@"scheme" notificationName:@"ApplicationDidReceiveFooActionNotification"];
`````

### Actions via Delegate

Calling the `delegate` variant of `-addAction` expects an object reference to an object that conforms to the `BFGCallbackDelegate` protocol. This protocol requires that the object implement one *required* method: `-handleCallback:` with the signature `- (void)handleCallback:(BFGCallback *)callback`. The parameter to this delegate method will be the `BFGCallback` object representing the callback parameters sent. (More on this below.)

`````objective-c
[self.router addAction:@"bar" scheme:@"scheme" delegate:(BFGCallbackDelegate *)self.window.rootViewController];
`````

### Actions via Block

Finally, calling the `handler` variant of `-addAction` takes in a block conforming to `BFGCallbackActionHandler` or `void(^BFGCallbackActionHandler)(BFGCallback *callback)`. The `BFGCallback` object sent to the block is the object representing the callback parameters sent. (More on this below.)

`````objective-c
[self.router addAction:@"foo" scheme:@"scheme" handler:^(BFGCallback *callback) {
    // do stuff here
}];
`````

## Routing URLs Sent to the App

Inside your app delegate in the  `-application:openURL:sourceApplication:annotation:` method, call the `-routeURL:errorHandler:` method of `BFGCallbackRouter`:

`````objective-c
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    [self.router routeURL:url errorHandler:^(BFGCallbackError error) {
        [self showAlertWithTitle:@"Callback Error" message:[NSString stringWithFormat:@"Invalid URL callback (%ld).", (long)error]];
    }];
    
    return YES;
}

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:NULL]];
    
    [self.window.rootViewController presentViewController:alert animated:YES completion:NULL];
}
`````

`BFGCallbackError` is an `enum` with different error values if you need to act on them specifically.

## `BFGCallback` Object

The `BFGCallback` object contains all the information from the callback received and has the following properties:

* `sourceURL` which is the full URL sent to the app
* `action` which is the name of the x-callback-url action
* `source` which contains the value of the `x-source` parameter, if present
* `onSuccess` which contains the value of the `x-success` parameter, if present
* `onCancel` which contains the value of the `x-cancel` parameter, if present
* `onError` which contains the value of the `x-error` parameter, if present
* `parameters` which contains a dictionary of any other URL query parameters sent with the x-callback-url parameters removed

### Handling Callbacks

The `BFGCallback` object also has three methods to handle x-success, x-cancel, and x-error callbacks.

`````objective-c
- (BOOL)performOnSuccessCallbackWithAdditionalParameters:(NSDictionary *)additionalParameters;
- (BOOL)performOnCancelCallback;
- (BOOL)performOnErrorCallbackWithCode:(NSInteger)code message:(NSString *)message;
`````

To perform the appropriate callback, call the method corresponding to the callback you need. The success callback allows you to add extra parameters to the URL, such as return values or other outgoing parameters from your app. The error callback takes in values to set the standard `errorCode` and `errorMessage` parameters for the `x-error` parameter.

Each method returns a `BOOL` indicating whether the callback was successful or couldn't be completed due to some URL handling error if you need to act on success or failure.

# Requirements

`BFGCallbackRouter` requires iOS 8.1, though it might work in older versions of iOS (untested).

# Installation

Copy `BFGCallback.[hm]` and `BFGCallbackRouter.[hm]` into your project.

## Support for CocoaPods and/or Swift

At this time, there are no plans to make the library available through CocoaPods (it's four files). The library should work fine with Swift through a bridging header (untested).

# Known Issues

* None at this time.

# License

`BFGCallbackRouter` is licensed under the MIT License. While you are under no obligation to attribute the use of the library in your application, attribution is appreciated.

# Contact

If you run into any issues, find me on Twitter under [@blackfog](https://twitter.com/blackfog) or [@blackfoggames](https://twitter.com/blackfoggames). You can also email me at craig at blackfoginteractive dot com.