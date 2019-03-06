//
//  BKJFWeakScriptMessageDelegate.m
//  ApolloApp
//
//  Created by bkjk on 2018/8/27.
//  Copyright © 2018年 xuyangjiang. All rights reserved.
//

#import "KZWWeakScriptMessageDelegate.h"

@implementation KZWWeakScriptMessageDelegate

- (instancetype)initWithDelegate:(id<WKScriptMessageHandler>)scriptDelegate {
    self = [super init];
    if (self) {
        _scriptDelegate = scriptDelegate;
    }
    return self;
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    if ([self.scriptDelegate respondsToSelector:@selector(userContentController:didReceiveScriptMessage:)]) {
        [self.scriptDelegate userContentController:userContentController didReceiveScriptMessage:message];
    }
}

@end
