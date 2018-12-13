//
//  KZWRouter.h
//  KZWRouter
//
//  Created by yang ou on 2018/12/12.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, KZWPageShowStyle) {
    KZWPageShowStylePush,
    KZWPageShowStylePresent
};

extern NSString * const KZWMediatorParamsKeySwiftTargetModuleName;

@interface KZWRouter : NSObject

/**
 * The `UIViewController` instance which will be used to determine whether to push or present a
 * routed view controller, if the `hostViewController`'s navigationController is nil, the routed
 * view controller will be presented, if the `hostViewController`'s navigationController is not nil,
 * the push or modal behaviour will be dependent on `ELMRouterOptions` instance which you use when you
 * map a view controller.
 *
 * hostViewController 默认是window的root ViewController ，你可以设置为你认为合适的controller，当设置为nil时，重置为默认的控制器
 */
@property (nonatomic, strong) UIViewController *hostViewController;

/**
 *  The `navigationClass` is used to custom navigation controller which is used to wrap the content
 *  View Controller you mapped to. And if you want to set this, it must be a sublclass of `UINavigationController`.
 */
@property (nonatomic, strong) Class navigationClass;

///-------------------------------
/// @name Get instances from URLs
///-------------------------------

/**
 *  return the mapped controller for the url
 *
 *  @param url A URL format (i.e. "user?id=xxxx" or "logout")
 *
 *  @return a `UIViewController` if the url to which the controller is mapped do exists, nil otherwise.
 */
- (UIViewController *)controllerForUrl:(NSString *)url;


///-------------------------------
/// @name Opening URLs
///-------------------------------

/**
 * Triggers the appropriate functionality for a mapped URL, such as an anonymous function or opening a `UIViewController`
 *
 * @param url The URL being opened (i.e. "user?id=xxx")
 */
- (void)open:(NSString *)url;

/**
 *  Triggers the appropriate functionality for a mapped URL, such as an anonymous function or opening a `UIViewController`
 *
 *  @param url      The URL being opened (i.e. "user")
 *  @param animated Whether or not `UIViewController` transitions are animated.
 
 */
- (void)open:(NSString *)url animated:(BOOL)animated;

/**
 *  Triggers the appropriate functionality for a mapped URL, such as an anonymous function or opening a `UIViewController`
 *
 *  @param url       The URL being opened (i.e. "user")
 *  @param animated  Whether or not `UIViewController` transitions are animated.
 *  @param showStyle The `KZWPageShowStyle` used to show the page
 */
- (void)open:(NSString *)url animated:(BOOL)animated showStyle:(KZWPageShowStyle)showStyle;

/**
 *  远程App调用入口
 *
 *  @param url       The URL being opened (i.e. "user")
 *  @param completion  The CallBack
 */
- (id)performActionWithUrl:(NSURL *)url completion:(void(^)(NSDictionary *info))completion;

/**
 *  本地组件调用入口
 *
 *  @param targetName  The targetName
 *  @param actionName  The actionName
 *  @param params  The params 参数
 *  @param shouldCacheTarget  The shouldCacheTarget 是否缓存
 */
- (id)performTarget:(NSString *)targetName action:(NSString *)actionName params:(NSDictionary *)params shouldCacheTarget:(BOOL)shouldCacheTarget;

/**
 *  清楚Targe缓存
 *
 *  @param targetName  The targetName
 */
- (void)releaseCachedTargetWithTargetName:(NSString *)targetName;

/**
 * A singleton instance of `KZWRouter` which can be accessed anywhere in the app.
 * @return A singleton instance of `KZWRouter`.
 */
+ (instancetype)sharedRouter;

@end

NS_ASSUME_NONNULL_END
