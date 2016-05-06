//
//  BFGCallbackRouter.h
//  BFGCallbackRouter
//
//  Created by Craig Pearlman on 2015-01-16.
//  Copyright (c) 2015 Black Fog Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BFGCallback.h"

typedef NS_ENUM(NSUInteger, BFGCallbackError) {
    BFGCallbackErrorInvalidURL = 400,
    BFGCallbackErrorUnknownScheme = 401,
    BFGCallbackErrorUnknownAction = 402
};

typedef void(^BFGCallbackActionHandler)(BFGCallback *callback);
typedef void(^BFGCallbackErrorHandler)(BFGCallbackError error);

@interface BFGCallbackRouter : NSObject

@property (nonatomic, getter=isRoutingEnabled) BOOL routingEnabled;
@property (nonatomic) BOOL allowBareScheme;

- (void)addAction:(NSString *)action scheme:(NSString *)scheme notificationName:(NSString *)notificationName;
- (void)addAction:(NSString *)action scheme:(NSString *)scheme delegate:(id<BFGCallbackDelegate>)delegate;
- (void)addAction:(NSString *)action scheme:(NSString *)scheme handler:(BFGCallbackActionHandler)handler;
- (void)routeURL:(NSURL *)url errorHandler:(BFGCallbackErrorHandler)errorHandler;

@end
