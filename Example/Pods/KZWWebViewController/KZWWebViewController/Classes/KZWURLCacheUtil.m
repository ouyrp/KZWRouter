//
//  BKJFURLCacheUtil.m
//  BKJFWebViewController
//
//  Created by hong on 2018/4/27.
//

#import "KZWURLCacheUtil.h"

@interface KZWURLCacheUtil ()

@property(nonatomic) NSLock *lock;
@property(nonatomic) NSInteger maxCacheCount;
// key:url value:上次阅读的位置
@property(nonatomic) NSMutableDictionary<NSString *, NSNumber *> *urlPositionMap;
@end

@implementation KZWURLCacheUtil

+ (instancetype)sharedInstance {
    static KZWURLCacheUtil *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [KZWURLCacheUtil new];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _lock = [NSLock new];
        _maxCacheCount = 50;
        _urlPositionMap = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)insertURL:(NSString *)url yPosition:(CGFloat)yPosition {
    if (!url || url.length == 0) {
        return;
    }
    if ([self.lock tryLock]) {
        if (self.urlPositionMap.count == self.maxCacheCount) {
            int index = 0;
            for (NSString *url in self.urlPositionMap) {
                if (index++ < 10) {
                    [self.urlPositionMap removeObjectForKey:url];
                }
            }
        }
        self.urlPositionMap[url] = [NSNumber numberWithFloat:yPosition];
        [self.lock unlock];
    }
}

- (CGFloat)getYPositionForURL:(NSString *)url {
    if (!url || url.length == 0) {
        return 0;
    }
    return [self.urlPositionMap[url] floatValue] ?: 0;
}


@end
