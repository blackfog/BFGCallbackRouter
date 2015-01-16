//
//  BFGCallbackRouter.m
//  BFGCallbackRouter
//
//  Created by Craig Pearlman on 2015-01-16.
//  Copyright (c) 2015 Black Fog Interactive. All rights reserved.
//

#import "BFGCallbackRouter.h"
#import "BFGCallback.h"
#import "BFGCallbackError.h"

static NSString * const RequiredHost = @"x-callback-url";
static NSString * const SourceParameter = @"x-source";
static NSString * const SuccessParameter = @"x-success";
static NSString * const CancelParameter = @"x-cancel";
static NSString * const ErrorParameter = @"x-error";

@interface BFGCallbackRouter ()

@property (nonatomic, strong) NSMutableDictionary *routes;

@end

@implementation BFGCallbackRouter

#pragma mark - Constructor

- (instancetype)init {
    self = [super init];
    
    if (self) {
        self.routingEnabled = YES;
        self.routes = [NSMutableDictionary dictionary];
    }
    
    return self;
}

#pragma mark - Public methods

- (void)addAction:(NSString *)action scheme:(NSString *)scheme handler:(BFGCallbackRouterActionHandler)handler {
    if (!self.routes[scheme]) {
        self.routes[scheme] = [NSMutableDictionary dictionary];
    }
    
    self.routes[scheme][action] = handler;
}

- (void)routeURL:(NSURL *)url errorHandler:(BFGCallbackErrorHandler)errorHandler {
    if (!self.isRoutingEnabled) return;
    
    NSURLComponents *components = [NSURLComponents componentsWithURL:url resolvingAgainstBaseURL:NO];
    
    if ([components.host isEqualToString:RequiredHost]) {
        if (self.routes[components.scheme]) {
            if (self.routes[components.scheme][components.path]) {
                BFGCallback *callback = [[BFGCallback alloc] init];
                
                callback.sourceURL = url;
                callback.action = components.path;
                callback.source = [self queryValueForParameter:SourceParameter components:components];
                callback.onSuccess = [self urlValueForParameter:SuccessParameter components:components];
                callback.onCancel = [self urlValueForParameter:CancelParameter components:components];
                callback.onError = [self urlValueForParameter:ErrorParameter components:components];
                callback.parameters = [self parametersFromComponents:components];

                BFGCallbackRouterActionHandler handler = self.routes[components.scheme][components.path];
                handler(callback);
            }
            else {
                [self handleError:BFGCallbackErrorUnknownAction errorHandler:errorHandler];
            }
        }
        else {
            [self handleError:BFGCallbackErrorUnknownScheme errorHandler:errorHandler];
        }
    }
    else {
        [self handleError:BFGCallbackErrorInvalidURL errorHandler:errorHandler];
    }
}

#pragma mark - Private methods

- (void)handleError:(BFGCallbackErrorType)errorType errorHandler:(BFGCallbackErrorHandler)errorHandler {
    if (!errorHandler) return;
    errorHandler([BFGCallbackError errorWithError:errorType]);
}

- (NSString *)queryValueForParameter:(NSString *)parameter components:(NSURLComponents *)components {
    for (NSURLQueryItem *item in components.queryItems) {
        if ([item.name isEqualToString:parameter]) {
            return item.value;
        }
    }
    
    return nil;
}

- (NSURL *)urlValueForParameter:(NSString *)parameter components:(NSURLComponents *)components {
    NSString *value = [self queryValueForParameter:parameter components:components];
    
    if (!value) return nil;
    
    return [NSURL URLWithString:value];
}

- (NSDictionary *)parametersFromComponents:(NSURLComponents *)components {
    NSMutableDictionary *temp = [NSMutableDictionary dictionary];
    NSSet *omit = [NSSet setWithArray:@[SourceParameter, SuccessParameter, CancelParameter, ErrorParameter]];
    
    for (NSURLQueryItem *item in components.queryItems) {
        if ([omit containsObject:item.name]) continue;
        temp[item.name] = item.value;
    }
    
    return temp;
}

@end
