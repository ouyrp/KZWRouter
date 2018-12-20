//
//  KZWRouter.m
//  KZWRouter
//
//  Created by yang ou on 2018/12/12.
//

#import "KZWRouter.h"

NSString * const KZWMediatorParamsKeySwiftTargetModuleName = @"KZWMediatorParamsKeySwiftTargetModuleName";

@interface KZWRouter ()

@property (nonatomic, strong) NSMutableDictionary *cachedTarget;

@end

@implementation KZWRouter

+ (instancetype)sharedRouter {
    static KZWRouter *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[super alloc] init];
    });
    return sharedInstance;
}

- (void)open:(NSString *)url {
    [self open:url animated:YES];
}

- (void)open:(NSString *)url animated:(BOOL)animated {
    [self open:url animated:animated showStyle:KZWPageShowStylePush];
}

- (void)open:(NSString *)url animated:(BOOL)animated showStyle:(KZWPageShowStyle)showStyle {
    UIViewController *controller = [self controllerForUrl:url];
    UINavigationController *hostNav = nil;
    UIViewController *visibleController = [self getVisibleViewControllerFrom:self.hostViewController];
    hostNav = visibleController.navigationController;
    
    UINavigationController *wrappedNav = wrapperControllerInNav(self.navigationClass, controller);
    
    if (!hostNav) {
        [visibleController presentViewController:wrappedNav animated:animated completion:nil];
        return;
    }
    
    switch (showStyle) {
        case KZWPageShowStylePush:
            [hostNav pushViewController:controller animated:animated];
            return;
        case KZWPageShowStylePresent:
            [hostNav.visibleViewController presentViewController:wrappedNav animated:animated completion:nil];
            return;
        default:
            [NSException raise:@"not supporte here" format:@"Not Support here, pls check"];
            break;
    }
}

- (id)performActionWithUrl:(NSURL *)url completion:(void (^)(NSDictionary *))completion {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    NSString *urlString = [url query];
    for (NSString *param in [urlString componentsSeparatedByString:@"&"]) {
        NSArray *elts = [param componentsSeparatedByString:@"="];
        if([elts count] < 2) continue;
        [params setObject:[elts lastObject] forKey:[elts firstObject]];
    }
    
    NSString *actionName = [url.path stringByReplacingOccurrencesOfString:@"/" withString:@""];
    if ([actionName hasPrefix:@"native"]) {
        return @(NO);
    }
    
    id result = [self performTarget:url.host action:actionName params:params shouldCacheTarget:NO];
    if (completion) {
        if (result) {
            completion(@{@"result":result});
        } else {
            completion(nil);
        }
    }
    return result;
}

- (id)performTarget:(NSString *)targetName action:(NSString *)actionName params:(NSDictionary *)params shouldCacheTarget:(BOOL)shouldCacheTarget {
    NSString *swiftModuleName = params[KZWMediatorParamsKeySwiftTargetModuleName];
    
    NSString *targetClassString = nil;
    if (swiftModuleName.length > 0) {
        targetClassString = [NSString stringWithFormat:@"%@.%@", swiftModuleName, targetName];
    } else {
        targetClassString = [NSString stringWithFormat:@"%@", targetName];
    }
    NSObject *target = self.cachedTarget[targetClassString];
    if (target == nil) {
        Class targetClass = NSClassFromString(targetClassString);
        target = [[targetClass alloc] init];
    }
    
    NSString *actionString = @"";
    if (params) {
        actionString = [NSString stringWithFormat:@"%@:", actionName];
    } else {
        actionString = actionName;
    }
    SEL action = NSSelectorFromString(actionString);
    
    if (target == nil) {
        [NSException raise:@"target can't nil" format:@"Not Support here, pls check"];
        return nil;
    }
    
    if (shouldCacheTarget) {
        self.cachedTarget[targetClassString] = target;
    }
    
    if ([target respondsToSelector:action]) {
        return [self safePerformAction:action target:target params:params];
    } else {
        [NSException raise:@"action name is not right" format:@"Not Support here, pls check"];
        return nil;
    }
}

- (void)releaseCachedTargetWithTargetName:(NSString *)targetName {
    [self.cachedTarget removeObjectForKey:targetName];
}

#pragma mark - private methods
- (id)safePerformAction:(SEL)action target:(id)target params:(NSDictionary *)params {
    NSMethodSignature* methodSig = [target methodSignatureForSelector:action];
    if(methodSig == nil) {
        return nil;
    }
    const char* retType = [methodSig methodReturnType];
    
    if (strcmp(retType, @encode(void)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
        if (params) {
            [invocation setArgument:&params atIndex:2];
        }
        [invocation setSelector:action];
        [invocation setTarget:target];
        [invocation invoke];
        return nil;
    }
    
    if (strcmp(retType, @encode(NSInteger)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
        if (params) {
            [invocation setArgument:&params atIndex:2];
        }
        [invocation setSelector:action];
        [invocation setTarget:target];
        [invocation invoke];
        NSInteger result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }
    
    if (strcmp(retType, @encode(BOOL)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
        if (params) {
            [invocation setArgument:&params atIndex:2];
        }
        [invocation setSelector:action];
        [invocation setTarget:target];
        [invocation invoke];
        BOOL result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }
    
    if (strcmp(retType, @encode(CGFloat)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
        if (params) {
            [invocation setArgument:&params atIndex:2];
        }
        [invocation setSelector:action];
        [invocation setTarget:target];
        [invocation invoke];
        CGFloat result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }
    
    if (strcmp(retType, @encode(NSUInteger)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
        if (params) {
            [invocation setArgument:&params atIndex:2];
        }
        [invocation setSelector:action];
        [invocation setTarget:target];
        [invocation invoke];
        NSUInteger result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    if (params) {
        return [target performSelector:action withObject:params];
    }
    return [target performSelector:action];
#pragma clang diagnostic pop
}

- (NSMutableDictionary *)cachedTarget {
    if (_cachedTarget == nil) {
        _cachedTarget = [[NSMutableDictionary alloc] init];
    }
    return _cachedTarget;
}

UINavigationController *wrapperControllerInNav(Class naviClass, UIViewController *viewController) {
    if ([viewController isKindOfClass:[UINavigationController class]]) {
        return (UINavigationController *)viewController;
    } else {
        if (naviClass) {
            return [[naviClass alloc] initWithRootViewController:viewController];
        }
        return [[UINavigationController alloc] initWithRootViewController:viewController];
    }
}

- (UIWindow *)window {
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(window in windows) {
            if (window.windowLevel == UIWindowLevelNormal) {
                break;
            }
        }
    }
    return window;
}

- (UIViewController *)hostViewController {
    if (!_hostViewController) {
        return [self window].rootViewController;
    }
    return _hostViewController;
}

- (UIViewController *)getVisibleViewControllerFrom:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self getVisibleViewControllerFrom:[((UINavigationController *)vc) visibleViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self getVisibleViewControllerFrom:[((UITabBarController *)vc) selectedViewController]];
    } else {
        if (vc.presentedViewController) {
            return [self getVisibleViewControllerFrom:vc.presentedViewController];
        } else {
            return vc;
        }
    }
}

#define HINT_TEXT @"class you give is %@, but the class must be subclass of `UINavigationController`"
- (void)setNavigationClass:(Class)navigationClass {
    if (_navigationClass == navigationClass) {
        return;
    }
    if (![navigationClass isSubclassOfClass:[UINavigationController class]]) {
        [NSException raise:@"navigation class is not right" format:HINT_TEXT, navigationClass];
    }
    _navigationClass = navigationClass;
}
#undef HINT_TEXT

- (UIViewController *)controllerForUrl:(NSString *)url {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    NSString *urlString = [[NSURL URLWithString:url] query];
    for (NSString *param in [urlString componentsSeparatedByString:@"&"]) {
        NSArray *elts = [param componentsSeparatedByString:@"="];
        if([elts count] < 2) continue;
        [params setObject:[elts lastObject] forKey:[elts firstObject]];
    }
    
    NSString *tagetName = nil;
    if ([url containsString:@":"]) {
        tagetName = [url componentsSeparatedByString:@":"].firstObject;
    }
    
    NSString *actionName = nil;
    if ([url containsString:@":"]) {
        NSString *pathString = [[NSURL URLWithString:url].path stringByReplacingOccurrencesOfString:@"/" withString:@""];
        actionName = [pathString componentsSeparatedByString:@":"][1];
    }
    
    id result = [self performTarget:tagetName action:actionName params:params.count > 0 ? params : nil shouldCacheTarget:NO];
    return result;
}

@end
