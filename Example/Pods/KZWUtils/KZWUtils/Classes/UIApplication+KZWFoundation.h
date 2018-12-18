//
//  UIApplication+KZWFoundation.h
//  KZWFoundation
//
//  Created by Andy on 4/20/15.
//  Copyright (c) 2015 eleme. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIApplication (KZWFoundation)

+ (NSString *)KZW_version;

+ (NSString *)KZW_bundleID;

+ (NSString *)KZW_userAgent;

+ (void)KZW_clearAllLocalNotifications NS_EXTENSION_UNAVAILABLE_IOS("");

@end
