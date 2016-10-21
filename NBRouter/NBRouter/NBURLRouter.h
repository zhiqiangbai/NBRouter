//
//  NBURLRouter.h
//  NBRouter
//
//  Created by NapoleonBai on 16/10/16.
//  Copyright © 2016年 BaiZhiqiang. All rights reserved.
//

#import "NBSingleton.h"
#import "UIViewController+NBURLRouter.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * 配置跳转相关设置等信息,使用时,请先设置协议头,以及加载配置文件(plist)
 *
 */
@interface NBURLRouter : NSObject


@property(nonatomic,strong,readonly)NSString *mHttpScheme;          ///< http协议头
@property(nonatomic,strong,readonly)NSString *mHttpsScheme;         ///< https协议头
@property(nonatomic,strong,readonly)NSString *mNormalScheme;        ///< 代码创建控制器协议头
@property(nonatomic,strong,readonly)NSString *mXibScheme;           ///< xib加载控制器协议头
@property(nonatomic,strong,readonly)NSString *mStoryBoardScheme;    ///< storyboard 加载控制器协议头

    
NBSingletonH(NBURLRouter)

/**
 *  如果有从Xib中加载控制器的跳转,就需要设置,加载的xib文件名必须与控制器名相同
 */
+ (void)setSchemeFromXibLoadViewController:(NSString *)scheme;
/**
 *  如果有从storyboard中加载控制器的跳转,就需要设置, 
 *  此类url按照此种格式设计, eg:fromsb://xxxxx/storyboardFileName.viewControllerIdentifier,主要是提供storyboardName 以及 控制器的 identifier
 */
+ (void)setSchemeFromStoryboardLoadViewController:(NSString *)scheme;
/**
 *  如果有代码直接创建控制器的跳转,就需要设置
 */
+ (void)setSchemeFromCodeViewController:(NSString *)scheme;


/**
 *  加载plist文件中的URL配置信息
 *
 *  @param plistName plist文件名称,不用加后缀
 *
 *  plist文件格式可参考NBRouter.plist
 *
 */
+ (void)loadConfigDictFromPlist:(NSString *)plistName;

/**
 *  设置RootViewController
 *
 *  @param urlString 自定义的URL
 *  @param classType 需要添加的导航控制器 eg.[UINavigationController class]
 */
+ (void)setRootURLString:(NSString *)urlString withNavigationClass:(Class)classType;
/**
 *  设置RootViewController
 *
 *  @param urlString 自定义的URL
 */
+ (void)setRootURLString:(NSString *)urlString;

    
#pragma mark --------  push控制器 --------
/**
 *  push控制器
 *
 *  @param urlString 自定义的URL,可以拼接参数
 */
+ (void)pushURLString:(NSString *)urlString animated:(BOOL)animated;
    
/**
 *  push控制器
 *
 *  @param urlString 自定义URL,也可以拼接参数,但会被下面的query替换掉
 *  @param query     存放参数
 */
+ (void)pushURLString:(NSString *)urlString query:(NSDictionary *)query animated:(BOOL)animated;
    
#pragma mark --------  pop控制器 --------
    
/** pop掉一层控制器 */
+ (void)popViewControllerAnimated:(BOOL)animated;
/** pop掉两层控制器 */
+ (void)popTwiceViewControllerAnimated:(BOOL)animated;
/** pop掉times层控制器 */
+ (void)popViewControllerWithTimes:(NSUInteger)times animated:(BOOL)animated;
/** pop到根层控制器 */
+ (void)popToRootViewControllerAnimated:(BOOL)animated;
/** pop到指定控制器 */
+ (void)popToViewController:(UIViewController *)viewController animated:(BOOL)animated;
    
#pragma mark --------  modal控制器 --------
    
/**
 *  modal控制器
 *
 *  @param viewControllerToPresent 目标控制器
 */
+ (void)presentViewController:(UIViewController *)viewControllerToPresent animated: (BOOL)flag completion:(void (^ __nullable)(void))completion;
    
/**
 *  modal控制器
 *
 *  @param viewControllerToPresent 目标控制器
 *  @param classType               需要添加的导航控制器 eg.[UINavigationController class]
 */
+ (void)presentViewController:(UIViewController *)viewControllerToPresent animated: (BOOL)flag withNavigationClass:(Class)classType completion:(void (^ __nullable)(void))completion;
    
/**
 *  modal控制器
 *
 *  @param urlString 自定义的URL,可以拼接参数
 */
+ (void)presentURLString:(NSString *)urlString animated:(BOOL)animated completion:(void (^ __nullable)(void))completion;
    
/**
 *  modal控制器
 *
 *  @param urlString 自定义URL,也可以拼接参数,但会被下面的query替换掉
 *  @param query     存放参数
 */
+ (void)presentURLString:(NSString *)urlString query:(NSDictionary *)query animated:(BOOL)animated completion:(void (^ __nullable)(void))completion;
    
/**
 *  modal控制器,并且给modal出来的控制器添加一个导航控制器
 *
 *  @param urlString 自定义的URL,可以拼接参数
 *  @param classType     需要添加的导航控制器 eg.[UINavigationController class]
 */
+ (void)presentURLString:(NSString *)urlString animated:(BOOL)animated withNavigationClass:(Class)classType completion:(void (^ __nullable)(void))completion;
    
/**
 *  modal控制器,并且给modal出来的控制器添加一个导航控制器
 *
 *  @param urlString 自定义URL,也可以拼接参数,但会被下面的query替换掉
 *  @param query     存放参数
 *  @param clazz     需要添加的导航控制器 eg.[UINavigationController class]
 */
+ (void)presentURLString:(NSString *)urlString query:(NSDictionary *)query animated:(BOOL)animated withNavigationClass:(Class)clazz completion:(void (^ __nullable)(void))completion;
    
#pragma mark --------  dismiss控制器 --------
    /** dismiss掉1层控制器 */
+ (void)dismissViewControllerAnimated: (BOOL)flag completion: (void (^ __nullable)(void))completion;
    /** dismiss掉2层控制器 */
+ (void)dismissTwiceViewControllerAnimated: (BOOL)flag completion: (void (^ __nullable)(void))completion;
    /** dismiss掉times层控制器 */
+ (void)dismissViewControllerWithTimes:(NSUInteger)times animated: (BOOL)flag completion: (void (^ __nullable)(void))completion;
    /** dismiss到根层控制器 */
+ (void)dismissToRootViewControllerAnimated: (BOOL)flag completion: (void (^ __nullable)(void))completion;
    
    NS_ASSUME_NONNULL_END

@end
