//
//  BFGCallback.h
//  BFGCallbackRouterSample
//
//  Created by Craig Pearlman on 2015-01-16.
//  Copyright (c) 2015 Black Fog Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BFGCallbackAction;
@class BFGCallbackError;

@interface BFGCallback : NSObject

@property (nonatomic, strong) NSURL *sourceURL;
@property (nonatomic, copy) NSString *action;
@property (nonatomic, copy) NSString *source;
@property (nonatomic, strong) NSURL *onSuccess;
@property (nonatomic, strong) NSURL *onCancel;
@property (nonatomic, strong) NSURL *onError;
@property (nonatomic, strong) NSDictionary *parameters;

- (BFGCallbackError *)performOnSuccessCallbackWithAdditionalParameters:(NSDictionary *)additionalParameters;
- (BFGCallbackError *)performOnCancelCallback;
- (BFGCallbackError *)performOnErrorCallbackWithCode:(NSInteger)code message:(NSString *)message;

@end
