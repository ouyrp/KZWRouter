//
//  KZWDSJavaScripInterface.m
//  kongzhongfinancial
//
//  Created by ouyang on 2018/5/4.
//  Copyright © 2018年 ouy. All rights reserved.
//

#import "KZWJavaScripInterface.h"
#import <FMWebViewJavascriptBridge/NSObject+FMAnnotation.h>

@implementation KZWJavaScripInterface

FM_EXPORT_METHOD(@selector(testData:))
- (void)testData:(id)data {
    NSLog(@"data class: %@, body is %@",[data class], [data debugDescription]);
}

@end
