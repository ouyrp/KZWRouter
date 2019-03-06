//
//  KZWWebViewService.m
//  AFNetworking
//
//  Created by yang ou on 2019/3/6.
//

#import "KZWWebViewService.h"
#import "KZWWebViewController.h"

@implementation KZWWebViewService

- (UIViewController *)kzw_KZWWebViewController:(NSString *)urlString callBackHandle:(void (^)(NSString *))callBackHandle {
    KZWWebViewController *controller = [[KZWWebViewController alloc] initWithUrl:urlString callBackHandle:callBackHandle];
    return controller;
}

@end
