//
//  KZWEnvironmentManager.m
//  KZWFoundation
//
//  Created by Draveness on 8/26/16.
//  Copyright (c) 2015 eleme. All rights reserved.
//

#import "KZWEnvironmentManager.h"

static KZWEnvironment Environment = KZWEnvProduction;

NSString *const KZWNotificationWillChangeEnvironment = @"KZWNotificaitonWillChangeNotification";
NSString *const KZWNotificationDidChangeEnvironment = @"KZWNotificationDidChangeEnvironment";

#define execute_block_on_main_thread($block) \
    if ($block) { \
        if ([[NSThread currentThread] isMainThread]) { \
            $block(); \
        } else { \
            dispatch_sync(dispatch_get_main_queue(), ^{ \
                $block();\
            }); \
        } \
    }

@implementation KZWEnvironmentManager

+ (void)setEnvironment:(KZWEnvironment)environment {
    if (Environment == environment) return;

    execute_block_on_main_thread(^{
        [[NSNotificationCenter defaultCenter] postNotificationName:KZWNotificationWillChangeEnvironment object:nil];
        Environment = environment;
        [[NSNotificationCenter defaultCenter] postNotificationName:KZWNotificationDidChangeEnvironment object:nil];
    });
}

+ (KZWEnvironment)environment {
    return Environment;
}

+ (BOOL)isProduction {
    return Environment == KZWEnvProduction;
}

+ (BOOL)isStaging {
    return Environment == KZWEnvStaging;
}

@end

@implementation KZWEnvironmentManager (KZWEnvironmentManager_Deprecated)

+ (void)setEnv:(KZWEnvironment)environment {
    [self setEnvironment:environment];
}

+ (KZWEnvironment)getEnvironment {
    return [self environment];
}

@end
