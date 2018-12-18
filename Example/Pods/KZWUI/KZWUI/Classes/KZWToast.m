//
//  KZWToast.m
//  KZWWidgets
//
//  Created by yin linlin on 2018/7/17.
//

#import "KZWToast.h"
#import <MBProgressHUD/MBProgressHUD.h>

#define HUDDefaultView [UIApplication sharedApplication].keyWindow

@implementation KZWToast

#pragma mark - Class methods


+ (void)show {
    [self show:nil animated:YES];
}

+ (void)show:(NSString *)content {
    [self show:content animated:NO];
}

+ (void)show:(NSString *)content animated:(BOOL)animated {
    MBProgressHUD *hud = [MBProgressHUD HUDForView:HUDDefaultView];
    if (!hud) {
        hud = [[MBProgressHUD alloc] initWithView:HUDDefaultView];
    }
    hud.mode = animated ? MBProgressHUDModeIndeterminate : MBProgressHUDModeText;
    hud.label.text = content;
    [HUDDefaultView addSubview:hud];
    [hud showAnimated:NO];
    [hud hideAnimated:NO afterDelay:4];
}

+ (void)show:(NSString *)content interval:(NSTimeInterval)interval {
    [self show:content animated:NO interval:interval];
}

+ (void)show:(NSString *)content animated:(BOOL)animated interval:(NSTimeInterval)interval {
    MBProgressHUD *hud = [MBProgressHUD HUDForView:HUDDefaultView];
    if (!hud) {
        hud = [[MBProgressHUD alloc] initWithView:HUDDefaultView];
    }
    hud.mode = animated ? MBProgressHUDModeIndeterminate : MBProgressHUDModeText;
    hud.label.text = content;
    [HUDDefaultView addSubview:hud];
    [hud showAnimated:NO];
    [hud hideAnimated:NO afterDelay:interval];
}

+ (void)hide {
    MBProgressHUD *hud = [MBProgressHUD HUDForView:HUDDefaultView];
    if (hud) {
        [hud hideAnimated:NO];
    }
}

@end
