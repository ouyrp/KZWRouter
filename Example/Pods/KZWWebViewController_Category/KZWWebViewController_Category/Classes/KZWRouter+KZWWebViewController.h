//
//  KZWRouter+KZWWebViewController.h
//  KZWRouter
//
//  Created by yang ou on 2018/12/18.
//

#import <KZWRouter/KZWRouter.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KZWRouter (KZWWebViewController)

- (UIViewController *)kzw_KZWWebViewController:(NSString *)urlString callBackHandle:(void (^)(NSString *))callBackHandle;

@end

NS_ASSUME_NONNULL_END
