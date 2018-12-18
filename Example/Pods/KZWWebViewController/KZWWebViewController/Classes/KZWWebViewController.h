//
//  KZWWebViewController.h
//  KZWfinancial
//
//  Created by ouy on 2017/3/15.
//  Copyright © 2017年 ouy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface KZWWebViewController : UIViewController

- (instancetype)initWithUrl:(NSString *)urlString;

- (instancetype)initWithRequest:(NSURLRequest *)request;

- (instancetype)initHTMLString:(NSString *)htmlString baseURL:(NSString *)baseURL;

- (instancetype)initWithUrl:(NSString *)urlString callBackHandle:(void (^)(NSString *))callBackHandle;

@end
