//
//  KZWToast.h
//  KZWWidgets
//
//  Created by yin linlin on 2018/7/17.
//

#import <Foundation/Foundation.h>

@interface KZWToast : NSObject

+ (void)show;

+ (void)show:(NSString *)content;

+ (void)show:(NSString *)content animated:(BOOL)animated;

+ (void)show:(NSString *)content interval:(NSTimeInterval)interval;

+ (void)show:(NSString *)content animated:(BOOL)animated interval:(NSTimeInterval)interval;

+ (void)hide;

@end
