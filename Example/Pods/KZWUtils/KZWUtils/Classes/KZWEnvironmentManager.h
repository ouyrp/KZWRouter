//
//  KZWEnvironmentManager.h
//  KZWFoundation
//
//  Created by Draveness on 8/26/16.
//  Copyright (c) 2016 eleme. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, KZWEnv) {
    KZWEnvTesting = 1,
    KZWEnvStaging,
    KZWEnvBeta,
    KZWEnvAlpha,
    KZWEnvProduction,
};

typedef KZWEnv KZWEnvironment;

/**
 *  `KZWNotificationWillChangeEnvironment` will fire before global environment changes.
 */
extern NSString *const KZWNotificationWillChangeEnvironment;


/**
 *  `KZWNotificationDidChangeEnvironment` will fire after global environment changes.
 */
extern NSString *const KZWNotificationDidChangeEnvironment;

/**
 *  KZWEnvironmentManager manages a global environemnt variable which indicates current
 *  application's environment is production, testing or alpha and etc. You will receive
 *  two different notifications before and after global environment changes.
 */
@interface KZWEnvironmentManager : NSObject

/**
 *  Change global environment, different notifications will fire before and after set
 *  global static variable. Default is `KZWEnvProduction`.
 *
 *  @param environment KZWEnvironment
 */
+ (void)setEnvironment:(KZWEnvironment)environment;

/**
 *  Return current environment.
 *
 *  @return Return a enum value which is an KZWEnvironment
 */
+ (KZWEnvironment)environment;

/**
 *  Whether the current environment is `KZWEnvProduction` or not.
 *
 *  @return A bool value indicates the current environment is `KZWEnvProduction` or not
 */
+ (BOOL)isProduction;

/**
 *  Whether the current environment is `KZWEnvStaging` or not.
 *
 *  @return A bool value indicates the current environment is `KZWEnvStaging` or not
 */
+ (BOOL)isStaging;

@end

@interface KZWEnvironmentManager (KZWEnvironmentManager_Deprecated)

+ (void)setEnv:(KZWEnv)environment __deprecated_msg("Use `+ setEnvironment:` instead of current method, will remove in 2.0.0");

+ (KZWEnv)getEnvironment __deprecated_msg("Use `+ environment` instead of current method, will remove in 2.0.0");

@end
