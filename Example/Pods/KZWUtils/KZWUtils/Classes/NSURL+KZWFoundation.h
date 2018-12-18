//
//  NSURL+KZWFoundation.h
//  KZWFoundation
//
//  Created by Andy on 5/14/15.
//  Copyright (c) 2015 eleme. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (KZWFoundation)

+ (NSString *)KZW_queryStringFromParameters:(NSDictionary *)paramters;

- (NSURL *)URLByAppendingQueryString:(NSString *)queryString;

@end
