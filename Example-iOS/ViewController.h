//
//  ViewController.h
//  BFGCallbackRouterSample
//
//  Created by Craig Pearlman on 2015-01-16.
//  Copyright (c) 2015 Black Fog Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BFGCallback.h"

FOUNDATION_EXTERN NSString * const ApplicationDidReceiveEchoNotification;

@interface ViewController : UIViewController <BFGCallbackDelegate>

@property (nonatomic, weak) IBOutlet UILabel *label;

@end

