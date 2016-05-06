//
//  BFGCallback.h
//  BFGCallbackRouterSample
//
//  Created by Craig Pearlman on 2015-01-16.
//  Copyright (c) 2015 Black Fog Interactive. All rights reserved.
//

@import UIKit;

@interface BFGCallback : NSObject

@property (nonatomic, strong) NSURL *sourceURL;
@property (nonatomic, copy) NSString *action;
@property (nonatomic, copy) NSString *source;
@property (nonatomic, strong) NSURL *onSuccess;
@property (nonatomic, strong) NSURL *onCancel;
@property (nonatomic, strong) NSURL *onError;
@property (nonatomic, copy) NSDictionary *parameters;

- (BOOL)performOnSuccessCallbackWithAdditionalParameters:(NSDictionary *)additionalParameters;
- (BOOL)performOnCancelCallback;
- (BOOL)performOnErrorCallbackWithCode:(NSInteger)code message:(NSString *)message;

@end

@protocol BFGCallbackDelegate <NSObject>

@required
- (void)handleCallback:(BFGCallback *)callback;

@end
