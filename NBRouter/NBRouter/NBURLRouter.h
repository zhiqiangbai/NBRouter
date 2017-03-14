//
//  NBURLRouter.h
//  NBRouter
//
//  Created by NapoleonBai on 16/10/16.
//  Copyright © 2016年 BaiZhiqiang. All rights reserved.
//

#import "NBSingleton.h"
#import "UIViewController+NBURLRouter.h"
#import "NBURLRouteBacker.h"

@class NBURLRouteMaker;

NS_ASSUME_NONNULL_BEGIN

/**
 * 配置跳转相关设置等信息,使用时,请先设置协议头,以及加载配置文件(plist)
 *
 */
@interface NBURLRouter : NSObject


@property(nonatomic,copy,readonly)NSString *mHttpScheme;          ///< http协议头
@property(nonatomic,copy,readonly)NSString *mHttpsScheme;         ///< https协议头
//@property(nonatomic,copy,readonly)NSArray *mCustomSchemes;        ///< 自定义协议头

@property(nonatomic,strong,readonly)UIViewController *currentViewController; ///< 当前控制器
@property(nonatomic,assign)BOOL hideBottomBarWhenPushed;///< 导航栏跳转时,是否隐藏菜单栏
    
NBSingletonH(NBURLRouter)

/**
 设置自定义协议

 @param schemes 自定义协议数组
 */
//+ (void)setCustomSchemes:(NSArray *)schemes;


/**
 设置urls数据.
 格式:
    1. 如果是采用http / https 协议的url,目前必须设置为这样, 其中NBWebViewController是指对应要跳转的控制器名称,拼写不能错误
    @"http" : @"NBWebViewController"
    @"https" : @"NBWebViewController"
    2. 如果采用的是自定义协议,比如router://
    @"router" : {
        @"router://home" : @"HomeViewController",
        ...
    }
    3. 如果没有采用协议或者说采用了协议都可以使用:
    @"router://home" : @"HomeViewController",
    @"router://profile" : @"ProfileViewController",
    @"setting" : @"SettingViewController"
 
    当然,非常建议使用协议内子集方式.这里后面出现的控制器名称必须与目标控制器名称一一对应.
 完整版:
    {
        @"http" : @"",
        @"https" : @"",
        @"router" : {
                    @"router://home" : @"HomeViewController",
                    ...
                    }
        @"other" : @"OtherViewController"
    }

 @param urlsDict 键值对数据
 */
+ (void)setUrlsConfigDict:(NSDictionary *)urlsDict;

/**
 模态跳转dismiss

 @param backerBlock 回调配置backer参数
 */
+ (void)dismiss:(void(^ _Nullable)(NBURLRouteDismissBacker * backer))backerBlock;

/**
 向上退一层
 */
+ (void)dismiss;

/**
 导航栏跳转pop

 @param backerBlock 回调皮遏制backer参数
 */
+ (void)pop:( void(^ _Nullable)(NBURLRoutePopBacker * backer))backerBlock;

/**
 向上退一层
 */
+ (void)pop;


/**
 设置根控制器

 @param makerBlock 回调配置maker参数
 */
+ (void)setRootViewControllerForMaker:(void(^)(NBURLRouteMaker * maker))makerBlock;

/**
 导航栏跳转时使用

 @param makerBlock 回调配置maker参数
 */
+ (void)push:(void(^)(NBURLRouteMaker * maker))makerBlock;

/**
 模态跳转时使用

 @param makerBlock 回调配置maker参数
 */
+ (void)present:(void(^)(NBURLRouteMaker * maker))makerBlock;

NS_ASSUME_NONNULL_END

@end
