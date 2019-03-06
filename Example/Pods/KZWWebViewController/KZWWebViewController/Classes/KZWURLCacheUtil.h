//
//  BKJFURLCacheUtil.h
//  BKJFWebViewController
//
//  Created by hong on 2018/4/27.
//

#import <Foundation/Foundation.h>

@interface KZWURLCacheUtil : NSObject

+ (instancetype)sharedInstance;

- (CGFloat)getYPositionForURL:(NSString *)url;

- (void)insertURL:(NSString *)url yPosition:(CGFloat)yPosition;

@end
