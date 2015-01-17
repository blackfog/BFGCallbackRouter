//
//  BFGCallback.m
//  BFGCallbackRouterSample
//
//  Created by Craig Pearlman on 2015-01-16.
//  Copyright (c) 2015 Black Fog Interactive. All rights reserved.
//

#import "BFGCallback.h"

static NSString * const ErrorCodeParameter = @"errorCode";
static NSString * const ErrorMessageParameter = @"errorMessage";

@implementation BFGCallback

@synthesize sourceURL;
@synthesize action;
@synthesize source;
@synthesize onSuccess;
@synthesize onCancel;
@synthesize onError;
@synthesize parameters;

#pragma mark - Public methods

- (BOOL)performOnSuccessCallbackWithAdditionalParameters:(NSDictionary *)additionalParameters {
    if (!self.onSuccess) return YES;
    
    NSURL *url = additionalParameters ? [self addQueryParameters:additionalParameters toURL:self.onSuccess] : self.onSuccess;
    return [self executeCallbackWithURL:url];
}

- (BOOL)performOnCancelCallback {
    if (!self.onCancel) return YES;
    return [self executeCallbackWithURL:self.onCancel];
}

- (BOOL)performOnErrorCallbackWithCode:(NSInteger)code message:(NSString *)message {
    if (!self.onError) return YES;
    
    NSURL *url = [self addQueryParameters:@{ ErrorCodeParameter: [@(code) stringValue], ErrorMessageParameter: message } toURL:self.onError];
    return [self executeCallbackWithURL:url];
}

#pragma mark - Private methods

- (NSURL *)addQueryParameters:(NSDictionary *)additionalParameters toURL:(NSURL *)url {
    NSURLComponents *components = [NSURLComponents componentsWithURL:url resolvingAgainstBaseURL:NO];
    NSMutableArray *queryItems = [NSMutableArray arrayWithArray:components.queryItems];
    
    [additionalParameters enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSURLQueryItem *item = [NSURLQueryItem queryItemWithName:key value:obj];
        [queryItems addObject:item];
    }];
    
    components.queryItems = queryItems;
    return [components URL];
}

- (BOOL)executeCallbackWithURL:(NSURL *)url {
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            [[UIApplication sharedApplication] openURL:url];
        });
        
        return YES;
    }
    else {
        return NO;
    }
}

@end
