//
//  NSURL+KZWFoundation.m
//  KZWFoundation
//
//  Created by Andy on 5/14/15.
//  Copyright (c) 2015 eleme. All rights reserved.
//

#import "NSURL+KZWFoundation.h"

static NSString * KZWQueryStringFromParametersWithEncoding(NSDictionary *parameters, NSStringEncoding stringEncoding);

@implementation NSURL (KZWFoundation)

/**
 * copy from AFNetworking, copyright AFNetworking.
 */
+ (NSString *)KZW_queryStringFromParameters:(NSDictionary *)paramters {
  return KZWQueryStringFromParametersWithEncoding(paramters, NSUTF8StringEncoding);
}

- (NSURL *)URLByAppendingQueryString:(NSString *)queryString {
    if (![queryString length]) {
        return self;
    }
    
    NSString *URLString = [[NSString alloc] initWithFormat:@"%@%@%@", [self absoluteString],
                           [self query] ? @"&" : @"?", queryString];
    NSURL *theURL = [NSURL URLWithString:URLString];
    return theURL;
}

@end

@interface KZWQueryStringPair : NSObject
@property (readwrite, nonatomic, strong) id field;
@property (readwrite, nonatomic, strong) id value;

- (id)initWithField:(id)field value:(id)value;

- (NSString *)URLEncodedStringValueWithEncoding:(NSStringEncoding)stringEncoding;

@end

@implementation KZWQueryStringPair

- (id)initWithField:(id)field value:(id)value {
  self = [super init];
  if (!self) {
    return nil;
  }
  self.field = field;
  self.value = value;
  return self;
}


static NSString * const kKZWCharactersToBeEscapedInQueryString = @":/?&=;+!@#$()',*";

static NSString * KZWPercentEscapedQueryStringKeyFromStringWithEncoding(NSString *string, NSStringEncoding encoding) {
  static NSString * const kKZWCharactersToLeaveUnescapedInQueryStringPairKey = @"[].";
  
  return (__bridge_transfer  NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)string, (__bridge CFStringRef)kKZWCharactersToLeaveUnescapedInQueryStringPairKey, (__bridge CFStringRef)kKZWCharactersToBeEscapedInQueryString, CFStringConvertNSStringEncodingToEncoding(encoding));
}

static NSString * KZWPercentEscapedQueryStringValueFromStringWithEncoding(NSString *string, NSStringEncoding encoding) {
  return (__bridge_transfer  NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)string, NULL, (__bridge CFStringRef)kKZWCharactersToBeEscapedInQueryString, CFStringConvertNSStringEncodingToEncoding(encoding));
}

- (NSString *)URLEncodedStringValueWithEncoding:(NSStringEncoding)stringEncoding {
  if (!self.value || [self.value isEqual:[NSNull null]]) {
    return KZWPercentEscapedQueryStringKeyFromStringWithEncoding([self.field description], stringEncoding);
  } else {
    return [NSString stringWithFormat:@"%@=%@", KZWPercentEscapedQueryStringKeyFromStringWithEncoding([self.field description], stringEncoding), KZWPercentEscapedQueryStringValueFromStringWithEncoding([self.value description], stringEncoding)];
  }
}

@end

#pragma mark -

extern NSArray * KZWQueryStringPairsFromDictionary(NSDictionary *dictionary);
extern NSArray * KZWQueryStringPairsFromKeyAndValue(NSString *key, id value);

static NSString * KZWQueryStringFromParametersWithEncoding(NSDictionary *parameters, NSStringEncoding stringEncoding) {
  NSMutableArray *mutablePairs = [NSMutableArray array];
  for (KZWQueryStringPair *pair in KZWQueryStringPairsFromDictionary(parameters)) {
    [mutablePairs addObject:[pair URLEncodedStringValueWithEncoding:stringEncoding]];
  }
  
  return [mutablePairs componentsJoinedByString:@"&"];
}

NSArray * KZWQueryStringPairsFromDictionary(NSDictionary *dictionary) {
  return KZWQueryStringPairsFromKeyAndValue(nil, dictionary);
}

NSArray * KZWQueryStringPairsFromKeyAndValue(NSString *key, id value) {
  NSMutableArray *mutableQueryStringComponents = [NSMutableArray array];
  
  NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"description" ascending:YES selector:@selector(compare:)];
  
  if ([value isKindOfClass:[NSDictionary class]]) {
    NSDictionary *dictionary = value;
    // Sort dictionary keys to ensure consistent ordering in query string, which is important when deserializing potentially ambiguous sequences, such as an array of dictionaries
    for (id nestedKey in [dictionary.allKeys sortedArrayUsingDescriptors:@[ sortDescriptor ]]) {
      id nestedValue = [dictionary objectForKey:nestedKey];
      if (nestedValue) {
        [mutableQueryStringComponents addObjectsFromArray:KZWQueryStringPairsFromKeyAndValue((key ? [NSString stringWithFormat:@"%@[%@]", key, nestedKey] : nestedKey), nestedValue)];
      }
    }
  } else if ([value isKindOfClass:[NSArray class]]) {
    NSArray *array = value;
    for (id nestedValue in array) {
      [mutableQueryStringComponents addObjectsFromArray:KZWQueryStringPairsFromKeyAndValue([NSString stringWithFormat:@"%@[]", key], nestedValue)];
    }
  } else if ([value isKindOfClass:[NSSet class]]) {
    NSSet *set = value;
    for (id obj in [set sortedArrayUsingDescriptors:@[ sortDescriptor ]]) {
      [mutableQueryStringComponents addObjectsFromArray:KZWQueryStringPairsFromKeyAndValue(key, obj)];
    }
  } else {
    [mutableQueryStringComponents addObject:[[KZWQueryStringPair alloc] initWithField:key value:value]];
  }
  
  return mutableQueryStringComponents;
}
