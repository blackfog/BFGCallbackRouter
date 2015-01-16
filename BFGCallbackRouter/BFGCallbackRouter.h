//
//  BFGCallbackRouter.h
//  BFGCallbackRouter
//
//  Created by Craig Pearlman on 2015-01-16.
//  Copyright (c) 2015 Black Fog Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BFGCallback;
@class BFGCallbackError;

typedef void(^BFGCallbackRouterActionHandler)(BFGCallback *callback);
typedef void(^BFGCallbackErrorHandler)(BFGCallbackError *error);

@interface BFGCallbackRouter : NSObject

@property (nonatomic, getter=isRoutingEnabled) BOOL routingEnabled;

- (void)addAction:(NSString *)action scheme:(NSString *)scheme handler:(BFGCallbackRouterActionHandler)handler;
- (void)routeURL:(NSURL *)url errorHandler:(BFGCallbackErrorHandler)errorHandler;

@end
