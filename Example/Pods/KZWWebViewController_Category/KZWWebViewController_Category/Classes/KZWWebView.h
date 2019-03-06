//
//  KZWWebView.h
//  AFNetworking
//
//  Created by yang ou on 2019/3/6.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol KZWWebView <NSObject>

@optional

- (UIViewController *)kzw_KZWWebViewController:(NSString *)urlString callBackHandle:(void (^)(NSString *))callBackHandle;

@end

NS_ASSUME_NONNULL_END
