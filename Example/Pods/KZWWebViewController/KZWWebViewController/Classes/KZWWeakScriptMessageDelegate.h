//
//  BKJFWeakScriptMessageDelegate.h
//  ApolloApp
//
//  Created by bkjk on 2018/8/27.
//  Copyright © 2018年 xuyangjiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

@interface KZWWeakScriptMessageDelegate : NSObject<WKScriptMessageHandler>

@property (nonatomic, weak) id<WKScriptMessageHandler> scriptDelegate;
- (instancetype)initWithDelegate:(id<WKScriptMessageHandler>)scriptDelegate;

@end
