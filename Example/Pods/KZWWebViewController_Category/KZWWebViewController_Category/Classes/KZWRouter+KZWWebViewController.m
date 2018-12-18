//
//  KZWRouter+KZWWebViewController.m
//  KZWRouter
//
//  Created by yang ou on 2018/12/18.
//

#import "KZWRouter+KZWWebViewController.h"

@implementation KZWRouter (KZWWebViewController)

- (UIViewController *)kzw_KZWWebViewController:(NSString *)urlString callBackHandle:(void (^)(NSString *))callBackHandle {
     NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"callBack"] = callBackHandle;
    params[@"urlString"] = urlString;
    return [self performTarget:@"KZWRouter_KZWWebViewController" action:@"KZWWebViewController" params:params shouldCacheTarget:NO];
}

@end
