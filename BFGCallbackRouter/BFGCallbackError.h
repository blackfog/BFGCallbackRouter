//
//  BFGCallbackError.h
//  BFGCallbackRouterSample
//
//  Created by Craig Pearlman on 2015-01-16.
//  Copyright (c) 2015 Black Fog Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, BFGCallbackErrorType) {
    BFGCallbackErrorNone = 0,
    BFGCallbackErrorInvalidURL = 400,
    BFGCallbackErrorUnknownScheme = 401,
    BFGCallbackErrorUnknownAction = 402,
    BFGCallbackErrorCannotPerformCallback = 500
};

@interface BFGCallbackError : NSObject

@property (nonatomic) BFGCallbackErrorType error;

- (instancetype)initWithError:(BFGCallbackErrorType)errorType;

+ (instancetype)errorWithError:(BFGCallbackErrorType)errorType;

@end
