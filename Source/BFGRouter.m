//
//  BFGCallbackRouter.m
//  BFGCallbackRouter
//
//  Created by Craig Pearlman on 2015-01-16.
//  Copyright (c) 2015 Black Fog Interactive. All rights reserved.
//

#import "BFGRouter.h"
#import "BFGCallback.h"

static NSString * const RequiredHost = @"x-callback-url";
static NSString * const SourceParameter = @"x-source";
static NSString * const SuccessParameter = @"x-success";
static NSString * const CancelParameter = @"x-cancel";
static NSString * const ErrorParameter = @"x-error";

@interface BFGRouter ()

@property (nonatomic, strong) NSMutableDictionary *routes;

@end

@implementation BFGRouter

@synthesize routingEnabled = _routingEnabled;
@synthesize allowBareScheme = _allowBareScheme;
@synthesize routes = _routes;

#pragma mark - Constructor

- (instancetype)init {
    self = [super init];
    
    if (self) {
        _routingEnabled = YES;
        _allowBareScheme = YES;
        _routes = [NSMutableDictionary dictionary];
    }
    
    return self;
}

#pragma mark - Public methods

- (void)addAction:(NSString *)action scheme:(NSString *)scheme notificationName:(NSString *)notificationName {
    [self addAction:action scheme:scheme object:notificationName];
}

- (void)addAction:(NSString *)action scheme:(NSString *)scheme delegate:(id<BFGCallbackDelegate>)delegate {
    [self addAction:action scheme:scheme object:delegate];
}

- (void)addAction:(NSString *)action scheme:(NSString *)scheme handler:(BFGCallbackActionHandler)handler {
    [self addAction:action scheme:scheme object:handler];
}

- (void)routeURL:(NSURL *)url errorHandler:(BFGCallbackErrorHandler)errorHandler {
    if (!self.isRoutingEnabled) return;
    
    NSURLComponents *components = [NSURLComponents componentsWithURL:url resolvingAgainstBaseURL:NO];
    
    // check for "bare" call to the scheme if allowed
    if (self.allowBareScheme) {
        if (
            (!components.host || [components.host isEqualToString:@""]) &&
            (!components.path || [components.path isEqualToString:@""]) &&
            (!components.query || [components.query isEqualToString:@""])
        ) {
            return;
        }
    }

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

                id handler = self.routes[components.scheme][components.path];
                
                if ([handler isKindOfClass:[NSString class]]) {
                    [self notify:handler callback:callback];
                }
                else if ([handler conformsToProtocol:@protocol(BFGCallbackDelegate)]) {
                    if ([handler respondsToSelector:@selector(handleCallback:)]) {
                        [handler handleCallback:callback];
                    }
                }
                else { // sadly, no good, reliable to check the type here (pray)
                    BFGCallbackActionHandler actionHandler = handler;
                    actionHandler(callback);
                }
            }
            else {
                errorHandler(BFGCallbackErrorUnknownAction);
            }
        }
        else {
            errorHandler(BFGCallbackErrorUnknownScheme);
        }
    }
    else {
        errorHandler(BFGCallbackErrorInvalidURL);
    }
}

#pragma mark - Private methods

- (void)addAction:(NSString *)action scheme:(NSString *)scheme object:(id)object {
    if (!self.routes[scheme]) {
        self.routes[scheme] = [NSMutableDictionary dictionary];
    }
    
    NSString *pathAction = [@"/" stringByAppendingString:action]; // this is how it will be parsed
    
    self.routes[scheme][pathAction] = object;
}

- (void)notify:(NSString *)notificationName callback:(BFGCallback *)callback {
    [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:callback];
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
