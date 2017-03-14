//
//  NBURLNavigation.h
//  NBRouter
//
//  Created by NapoleonBai on 16/10/18.
//  Copyright © 2016年 BaiZhiqiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NBSingleton.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * 实现页面间跳转与管理等
 *
 */
@interface NBURLNavigation : NSObject

@property(nonatomic,strong,readonly)UIViewController *currentViewController;

NBSingletonH(NBURLNavigation)
/**
 *  设置根控制器
 *
 *  @param viewController 控制器对象
 */
+ (void)setRootViewController:(UIViewController *)viewController;

/**
 *  通过Push方式跳转,在有导航栏情况下才支持
 *
 */
+ (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated;
/**
 *  通过modal方式跳转,支持任何的控制器之间跳转
 *
 */
+ (void)presentViewController:(UIViewController *)viewController animated: (BOOL)flag completion:(void (^ __nullable)(void))completion;

/**
 *  导航栏跳转时,一次倒退两个界面
 *
 */
+ (void)popTwiceViewControllerAnimated:(BOOL)animated;
/**
 *  导航栏跳转时,一次性倒退指定个界面
 *
 */
+ (void)popViewControllerWithTimes:(NSUInteger)times animated:(BOOL)animated;
/**
 *  pop到指定控制器
 *
 *  @param viewController 指定控制器
 *  @param animated       动画
 */
+ (void)popToViewController:(UIViewController *)viewController animated:(BOOL)animated;

/**
 *  导航栏跳转,回到第一个界面
 *
 */
+ (void)popToRootViewControllerAnimated:(BOOL)animated;
/**
 *  modal跳转时,一次性倒退指定个控制器
 *
 */
+ (void)dismissViewControllerWithTimes:(NSUInteger)times animated: (BOOL)flag completion: (void (^ __nullable)(void))completion;
/**
 *  modal跳转时,一次性倒退到根控制器
 *
 */
+ (void)dismissToRootViewControllerAnimated: (BOOL)animate completion: (void (^ __nullable)(void))completion;

@end

NS_ASSUME_NONNULL_END

