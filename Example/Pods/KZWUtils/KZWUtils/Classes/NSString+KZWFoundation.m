//
//  NSString+KZWFoundation.m
//  KZWFoundation
//
//  Created by 0oneo on 6/2/15.
//  Copyright (c) 2015 eleme. All rights reserved.
//

#import "NSString+KZWFoundation.h"
#import "KZWEnvironmentManager.h"

@implementation NSString (KZWFoundation)

+ (BOOL)KZW_isBlank:(NSString *)string {
    return string == nil
    || ![string isKindOfClass:[NSString class]]
    || [string isEqualToString:@""]
    || [[string KZW_trim] isEqualToString:@""];
}

- (NSString *)KZW_trim {
    NSCharacterSet *whiteCharSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    return [self stringByTrimmingCharactersInSet:whiteCharSet];
}

// JSON
- (NSDictionary *)KZW_JSON {
    NSData *JSONData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err = nil;
    NSDictionary *JSONObject = [NSJSONSerialization JSONObjectWithData:JSONData options:0 error:&err];
    if (err) {
#ifdef DEBUG
        NSLog(@"json string format error. error: %@, string: %@", err, self);
#endif
        return nil;
    }
    return JSONObject;
}


- (NSString *)KZW_URLEncodedString
{
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)self, NULL, CFSTR("!*'();:@&=+$,/?%#[]"), kCFStringEncodingUTF8));
    return result;
}

- (NSString *)KZW_URLDecodedString
{
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault, (CFStringRef)self, CFSTR(""), kCFStringEncodingUTF8));
    return result;
}

- (NSString *)lpd_urlEncode {
    return [self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

- (NSString *)lpd_urlDecode {
    return [self stringByRemovingPercentEncoding];
}

+ (NSString *)notRounding:(float)price afterPoint:(int)position {
    NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:position raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber *ouncesDecimal;
    NSDecimalNumber *roundedOunces;
    
    ouncesDecimal = [[NSDecimalNumber alloc] initWithFloat:price];
    roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    return [NSString stringWithFormat:@"%@",roundedOunces];
}

@end
