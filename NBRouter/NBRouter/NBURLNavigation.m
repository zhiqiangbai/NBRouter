//
//  NBURLNavigation.m
//  NBRouter
//
//  Created by NapoleonBai on 16/10/18.
//  Copyright © 2016年 BaiZhiqiang. All rights reserved.
//

#import "NBURLNavigation.h"

@interface NBURLNavigation()

//@property(nonatomic,strong)NSMutableArray<UIViewController *>* viewControllers;
@property(nonatomic,strong)UINavigationController *currentNavigationViewController;
@property(nonatomic,strong,readwrite)UIViewController *currentViewController;


@end

@implementation NBURLNavigation

//- (NSMutableArray<UIViewController *> *)viewControllers{
//    if (!_viewControllers) {
//        _viewControllers = [NSMutableArray new];
//        [self.viewControllers addObject:[[self applicationDelegate] window].rootViewController];
//    }
//    return _viewControllers;
//}

NBSingletonM(NBURLNavigation)

- (UIViewController*)currentViewController {
    UIViewController* rootViewController = self.applicationDelegate.window.rootViewController;
    return [self currentViewControllerFrom:rootViewController];
}

- (UINavigationController*)currentNavigationViewController {
    UIViewController* viewController = self.currentViewController;

    if (viewController.navigationController) {
        return viewController.navigationController;
    }
    
    NSAssert(0, @"当前控制器不是导航栏控制器");
    return nil;
}

- (id<UIApplicationDelegate>)applicationDelegate {
    return [UIApplication sharedApplication].delegate;
}

+ (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (!viewController) {
        NSAssert(0, @"请添加与url相匹配的控制器到plist文件中,或者协议头可能写错了!");
    }else {
//        NBURLNavigation *navigation = [NBURLNavigation sharedNBURLNavigation];
        UINavigationController *navigationController = [NBURLNavigation sharedNBURLNavigation].currentNavigationViewController;
        if (navigationController) {
//            if ([navigation.viewControllers containsObject:navigationController]) {
//                //如果之前存在,就移除
//                [navigation.viewControllers removeObject:navigationController];
//            }
//            //重新加载在末尾
//            [navigation.viewControllers addObject:navigationController];
//            viewController.hidesBottomBarWhenPushed = YES;
            [navigationController pushViewController:viewController animated:animated];
        }else{
            NSAssert(0, @"当前控制器非导航栏控制器,无法进行push操作");
        }
    }
}

+ (void)presentViewController:(UIViewController *)viewController animated: (BOOL)flag completion:(void (^ __nullable)(void))completion
{
    if (!viewController) {
        NSAssert(0, @"请添加与url相匹配的控制器到plist文件中,或者协议头可能写错了!");
    }else {
        UIViewController *currentViewController = [[NBURLNavigation sharedNBURLNavigation] currentViewController];
        if (currentViewController) {
            // 当前控制器存在
            [currentViewController presentViewController:viewController animated:flag completion:completion];
//            [[NBURLNavigation sharedNBURLNavigation].viewControllers addObject:viewController];
        } else {
            NSAssert(0, @"没有找到根控制器,无法进行modal跳转操作");
        }
    }
}

    
// 设置为根控制器
+ (void)setRootViewController:(UIViewController *)viewController
{
    NBURLNavigation *navigation = [NBURLNavigation sharedNBURLNavigation];
    if (!navigation.applicationDelegate.window) {
        navigation.applicationDelegate.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [navigation.applicationDelegate.window makeKeyAndVisible];
    }
    navigation.applicationDelegate.window.rootViewController = viewController;
//    //如果是重新设置,那么就先清空之前的
//    if (navigation.viewControllers.count) {
//        [navigation.viewControllers removeAllObjects];
//    }
//    //重新添加控制器
//    [navigation.viewControllers addObject:viewController];
}


// 通过递归拿到当前控制器
- (UIViewController*)currentViewControllerFrom:(UIViewController*)viewController {
    if ([viewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController* navigationController = (UINavigationController *)viewController;
        return [self currentViewControllerFrom:navigationController.viewControllers.lastObject];
    } // 如果传入的控制器是导航控制器,则返回最后一个
    else if([viewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController* tabBarController = (UITabBarController *)viewController;
        return [self currentViewControllerFrom:tabBarController.selectedViewController];
    } // 如果传入的控制器是tabBar控制器,则返回选中的那个
    else if(viewController.presentedViewController != nil) {
        return [self currentViewControllerFrom:viewController.presentedViewController];
    } // 如果传入的控制器发生了modal,则就可以拿到modal的那个控制器
    else {
        return viewController;
    }
}

+ (void)popTwiceViewControllerAnimated:(BOOL)animated {
    [NBURLNavigation popViewControllerWithTimes:2 animated:YES];
}

+ (void)popViewControllerWithTimes:(NSUInteger)times animated:(BOOL)animated {
    
    UINavigationController *currentViewController = [[NBURLNavigation sharedNBURLNavigation] currentNavigationViewController];

    if(currentViewController){
        NSUInteger count = currentViewController.viewControllers.count;
        if (count > times){
            [currentViewController popToViewController:[currentViewController.viewControllers objectAtIndex:count-1-times] animated:animated];
//            if (count-times==1) {
//                [[NBURLNavigation sharedNBURLNavigation].viewControllers removeLastObject];
//            }
        }else {
            // 如果times大于控制器的数量
            NSAssert(0, @"确定可以pop掉那么多控制器?");
        }
    }
}
+ (void)popToRootViewControllerAnimated:(BOOL)animated {
    [[NBURLNavigation sharedNBURLNavigation].currentNavigationViewController popToRootViewControllerAnimated:animated];
//    [[NBURLNavigation sharedNBURLNavigation].viewControllers removeLastObject];
}


+ (void)dismissTwiceViewControllerAnimated: (BOOL)flag completion: (void (^ __nullable)(void))completion {
    [self dismissViewControllerWithTimes:2 animated:YES completion:completion];
}


+ (void)dismissViewControllerWithTimes:(NSUInteger)times animated: (BOOL)flag completion: (void (^ __nullable)(void))completion {
    UIViewController *rootVC = [[NBURLNavigation sharedNBURLNavigation] currentViewController];
    
    if (rootVC) {
        while (times > 0) {
            rootVC = rootVC.presentingViewController;
            times -= 1;
        }
        [rootVC dismissViewControllerAnimated:YES completion:completion];
        //dismiss 一个则删除一个
//        [[NBURLNavigation sharedNBURLNavigation].viewControllers removeLastObject];
    }
    
    if (!rootVC.presentedViewController) {
        NSAssert(0, @"确定能dismiss掉这么多控制器?");
    }
    
}


+ (void)dismissToRootViewControllerAnimated: (BOOL)flag completion: (void (^ __nullable)(void))completion {
    UIViewController *currentViewController = [[NBURLNavigation sharedNBURLNavigation] currentViewController];
    UIViewController *rootVC = currentViewController;
    while (rootVC.presentingViewController) {
        rootVC = rootVC.presentingViewController;
        [rootVC dismissViewControllerAnimated:YES completion:completion];
//        [[NBURLNavigation sharedNBURLNavigation].viewControllers removeLastObject];
    }
}

@end
