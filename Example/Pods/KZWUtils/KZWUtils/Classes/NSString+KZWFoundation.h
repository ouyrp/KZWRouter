//
//  NSString+KZWFoundation.h
//  KZWFoundation
//
//  Created by 0oneo on 6/2/15.
//  Copyright (c) 2015 eleme. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (KZWFoundation)

+ (BOOL)KZW_isBlank:(NSString *)string;

- (NSString *)KZW_trim;

// JSON

- (NSDictionary *)KZW_JSON;

- (NSString *)KZW_URLEncodedString;

- (NSString *)KZW_URLDecodedString;

- (NSString *)lpd_urlEncode;

- (NSString *)lpd_urlDecode;

+ (NSString *)notRounding:(float)price afterPoint:(int)position;


@end
