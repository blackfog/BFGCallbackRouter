//
//  ViewController.m
//  BFGCallbackRouterSample
//
//  Created by Craig Pearlman on 2015-01-16.
//  Copyright (c) 2015 Black Fog Interactive. All rights reserved.
//

#import "ViewController.h"

NSString * const ApplicationDidReceiveEchoNotification = @"ApplicationDidReceiveEchoNotification";

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    [[NSNotificationCenter defaultCenter] addObserverForName:ApplicationDidReceiveEchoNotification
                                                      object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification *notification) {
                                                      BFGCallback *callback = notification.object;
                                                      self.label.text = [NSString stringWithFormat:@"Params: %@", callback.parameters];
                                                  }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)observeNotification:(NSString *)notificationName block:(void (^)(NSNotification *note))block {
    [[NSNotificationCenter defaultCenter] addObserverForName:notificationName
                                                      object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:block];
}

- (void)handleCallback:(BFGCallback *)callback {
    self.label.text = [NSString stringWithFormat:@"Callback from “%@”", callback.source];
    BOOL succeeded = NO;

    if (callback.parameters[@"type"]) {
        if ([callback.parameters[@"type"] isEqualToString:@"success"]) {
            succeeded = [callback performOnSuccessCallbackWithAdditionalParameters:@{ @"x": @"1" }];
        }
        else if ([callback.parameters[@"type"] isEqualToString:@"cancel"]) {
            succeeded = [callback performOnCancelCallback];
        }
        else if ([callback.parameters[@"type"] isEqualToString:@"error"]) {
            succeeded = [callback performOnErrorCallbackWithCode:999 message:@"test"];
        }
    }
    
    if (!succeeded) {
        [self showAlertWithTitle:@"Callback Error"
                         message:@"Syntax error or callback action failed to execute."];
    }
}

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:NULL]];
    
    [self presentViewController:alert animated:YES completion:NULL];
}

@end
