//
//  BFGCallbackError.m
//  BFGCallbackRouterSample
//
//  Created by Craig Pearlman on 2015-01-16.
//  Copyright (c) 2015 Black Fog Interactive. All rights reserved.
//

#import "BFGCallbackError.h"

@implementation BFGCallbackError

@synthesize error = _error;

- (instancetype)init {
    self = [super init];
    
    if (self) {
        _error = BFGCallbackErrorNone;
    }
    
    return self;
}

- (instancetype)initWithError:(BFGCallbackErrorType)errorType {
    self = [self init];
    
    self.error = errorType;
    
    return self;
}

+ (instancetype)errorWithError:(BFGCallbackErrorType)error {
    return [[BFGCallbackError alloc] initWithError:error];
}

@end
