//
//  AppDelegate.m
//  BFGCallbackRouterSample
//
//  Created by Craig Pearlman on 2015-01-16.
//  Copyright (c) 2015 Black Fog Interactive. All rights reserved.
//

#import "AppDelegate.h"
#import "BFGCallbackRouter.h"
#import "BFGCallback.h"

@interface AppDelegate ()

@property (nonatomic, strong) BFGCallbackRouter *router;

@end

@implementation AppDelegate

@synthesize router;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.router = [[BFGCallbackRouter alloc] init];
    
    // router://x-callback-url/hello
    [self.router addAction:@"hello" scheme:@"router" handler:^(BFGCallback *callback) {
        NSLog(@"Hello, World!");
    }];
    
    // router://x-callback-url/echo?foo=bar&baz=1
    [self.router addAction:@"echo" scheme:@"router" handler:^(BFGCallback *callback) {
        NSLog(@"Params: %@", callback.parameters);
    }];
    
    // router://x-callback-url/callback?type=success&x-source=Foo&x-success=http%3A%2F%2Fapple.com&x-cancel=http%3A%2F%2Fgoogle.com&x-error=http%3A%2F%2Fmicrosoft.com
    // router://x-callback-url/callback?type=cancel&x-source=Foo&x-success=http%3A%2F%2Fapple.com&x-cancel=http%3A%2F%2Fgoogle.com&x-error=http%3A%2F%2Fmicrosoft.com
    // router://x-callback-url/callback?type=error&x-source=Foo&x-success=http%3A%2F%2Fapple.com&x-cancel=http%3A%2F%2Fgoogle.com&x-error=http%3A%2F%2Fmicrosoft.com
    [self.router addAction:@"callback" scheme:@"router" handler:^(BFGCallback *callback) {
        NSLog(@"Callback from “%@”", callback.source);
        
        if (callback.parameters[@"type"]) {
            if ([callback.parameters[@"type"] isEqualToString:@"success"]) {
                [callback performOnSuccessCallbackWithAdditionalParameters:@{ @"x": @"1" }];
            }
            else if ([callback.parameters[@"type"] isEqualToString:@"cancel"]) {
                [callback performOnCancelCallback];
            }
            else if ([callback.parameters[@"type"] isEqualToString:@"error"]) {
                [callback performOnErrorCallbackWithCode:999 message:@"test"];
            }
        }
    }];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    [self.router routeURL:url errorHandler:^(BFGCallbackError *error) {
        NSLog(@"Callback Error: %@", error);
    }];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
