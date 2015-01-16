//
//  BFGCallback.m
//  BFGCallbackRouterSample
//
//  Created by Craig Pearlman on 2015-01-16.
//  Copyright (c) 2015 Black Fog Interactive. All rights reserved.
//

#import "BFGCallback.h"
#import "BFGCallbackError.h"

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

// TODO: test to make sure this doesn't bork pre-encoded paramters if we're adding new ones
- (BFGCallbackError *)performOnSuccessCallbackWithAdditionalParameters:(NSDictionary *)additionalParameters {
    if (!self.onSuccess) return self.noError;
    
    NSURL *url = additionalParameters ? [self addQueryParameters:additionalParameters toURL:self.onSuccess] : self.onSuccess;
    return [self executeCallbackWithURL:url];
}

- (BFGCallbackError *)performOnCancelCallback {
    if (!self.onCancel) return self.noError;
    return [self executeCallbackWithURL:self.onCancel];
}

// TODO: test to make sure this doesn't bork pre-encoded paramters when we add the error information
- (BFGCallbackError *)performOnErrorCallbackWithCode:(NSInteger)code message:(NSString *)message {
    if (!self.onError) return self.noError;
    
    NSURL *url = [self addQueryParameters:@{ ErrorCodeParameter: @(code), ErrorMessageParameter: message } toURL:self.onError];
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

- (BFGCallbackError *)noError {
    return [BFGCallbackError errorWithError:BFGCallbackErrorNone];
}

- (BFGCallbackError *)executeCallbackWithURL:(NSURL *)url {
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
        return self.noError;
    }
    else {
        return [BFGCallbackError errorWithError:BFGCallbackErrorCannotPerformCallback];
    }
}

@end
