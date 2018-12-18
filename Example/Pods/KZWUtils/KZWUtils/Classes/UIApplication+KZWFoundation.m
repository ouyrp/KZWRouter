//
//  UIApplication+KZWFoundation.m
//  KZWFoundation
//
//  Created by Andy on 4/20/15.
//  Copyright (c) 2015 eleme. All rights reserved.
//

#import "UIApplication+KZWFoundation.h"

@implementation UIApplication (KZWFoundation)

+ (NSString *)KZW_version {
  return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
}

+ (NSString *)KZW_bundleID {
  return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"];
}

+ (NSString *)KZW_userAgent{
    return  [NSMutableString stringWithString:[[UIWebView new] stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"]];
}

+ (void)KZW_clearAllLocalNotifications {
  [[UIApplication sharedApplication] setApplicationIconBadgeNumber:1];
  [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
  [[UIApplication sharedApplication] cancelAllLocalNotifications];
}


@end
