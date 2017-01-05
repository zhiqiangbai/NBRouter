//
//  NBURLRouter.m
//  NBRouter
//
//  Created by NapoleonBai on 16/10/16.
//  Copyright © 2016年 BaiZhiqiang. All rights reserved.
//

#import "NBURLRouter.h"
#import "NBURLNavigation.h"
#import "NBURLRouteMaker.h"

@interface NBURLRouter()

@property(nonatomic,strong) NSDictionary *configDict; ///< 存储读取的plist文件数据
@property(nonatomic,strong,readwrite)NSString *mHttpScheme;         ///< http协议头
@property(nonatomic,strong,readwrite)NSString *mHttpsScheme;        ///< https协议头
@property(nonatomic,strong,readwrite)NSString *mNormalScheme;       ///< 常规方式协议头
@property(nonatomic,strong,readwrite)NSString *mXibScheme;          ///< xib方式协议头
@property(nonatomic,strong,readwrite)NSString *mStoryBoardScheme;   ///< stroyboard方式协议头
@property(nonatomic,strong,readwrite)UIViewController *currentViewController; ///< 当前控制器

@end

@implementation NBURLRouter

- (UIViewController *)currentViewController{
    return [NBURLNavigation sharedNBURLNavigation].currentViewController;
}

- (NSString *)mHttpScheme{
    if (!_mHttpScheme) {
        _mHttpScheme = @"http";
    }
    return _mHttpScheme;
}

- (NSString *)mHttpsScheme{
    if (!_mHttpsScheme) {
        _mHttpsScheme = @"https";
    }
    return _mHttpsScheme;
}

NBSingletonM(NBURLRouter)

- (instancetype)init{
    if (self = [super init]) {
        self.hideBottomBarWhenPushed = YES;
    }
    return self;
}

+ (void)setSchemeFromCodeViewController:(NSString *)scheme{
    [NBURLRouter sharedNBURLRouter].mNormalScheme = scheme;
}

+ (void)setSchemeFromXibLoadViewController:(NSString *)scheme{
    [NBURLRouter sharedNBURLRouter].mXibScheme = scheme;
}
+ (void)setSchemeFromStoryboardLoadViewController:(NSString *)scheme{
    [NBURLRouter sharedNBURLRouter].mStoryBoardScheme = scheme;
}

+ (void)loadConfigDictFromPlist:(NSString *)plistName{
    NSString *path = [[NSBundle mainBundle] pathForResource:plistName ofType:nil];
    NSDictionary *configDict = [NSDictionary dictionaryWithContentsOfFile:path];
    if (configDict) {
        [NBURLRouter sharedNBURLRouter].configDict = configDict;
    }else {
        NSAssert(0, @"请按照说明添加对应的plist文件");
    }
}
    
+ (void)setRootURLString:(NSString *)urlString{
    [NBURLRouter setRootURLString:urlString withNavigationClass:[NSNull class]];
}
    
+ (void)setRootURLString:(NSString *)urlString withNavigationClass:(Class)classType{
    UIViewController *viewController = [UIViewController initFromString:urlString fromConfig:[NBURLRouter sharedNBURLRouter].configDict];
    if ([classType isSubclassOfClass:[UINavigationController class]]) {
        UINavigationController *nav =  [[classType alloc]initWithRootViewController:viewController];
        [NBURLNavigation setRootViewController:nav];
    }else{
        //说明并没有设置导航栏
        [NBURLNavigation setRootViewController:viewController];
    }
}

+ (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    viewController.hidesBottomBarWhenPushed = [NBURLRouter sharedNBURLRouter].hideBottomBarWhenPushed;
    [NBURLNavigation pushViewController:viewController animated:animated];
}

+ (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated callBackHandler:(CallBackHandler)handler{
    viewController.callBackHandler = handler;
    viewController.hidesBottomBarWhenPushed = [NBURLRouter sharedNBURLRouter].hideBottomBarWhenPushed;
    [NBURLNavigation pushViewController:viewController animated:animated];
}


+ (void)pushURLString:(NSString *)urlString animated:(BOOL)animated {
    
    UIViewController *viewController = [UIViewController initFromString:urlString fromConfig:[NBURLRouter sharedNBURLRouter].configDict];
    viewController.hidesBottomBarWhenPushed = [NBURLRouter sharedNBURLRouter].hideBottomBarWhenPushed;
    [NBURLNavigation pushViewController:viewController animated:animated];
}

+ (void)pushURLString:(NSString *)urlString animated:(BOOL)animated callBackHandler:(CallBackHandler)handler{
    UIViewController *viewController = [UIViewController initFromString:urlString fromConfig:[NBURLRouter sharedNBURLRouter].configDict];
    viewController.callBackHandler = handler;
    viewController.hidesBottomBarWhenPushed = [NBURLRouter sharedNBURLRouter].hideBottomBarWhenPushed;
    [NBURLNavigation pushViewController:viewController animated:animated];
}


+ (void)pushURLString:(NSString *)urlString query:(NSDictionary *)query animated:(BOOL)animated{
    UIViewController *viewController = [UIViewController initFromString:urlString withQuery:query fromConfig:[NBURLRouter sharedNBURLRouter].configDict];
    viewController.hidesBottomBarWhenPushed = [NBURLRouter sharedNBURLRouter].hideBottomBarWhenPushed;
    [NBURLNavigation pushViewController:viewController animated:animated];
}

+ (void)pushURLString:(NSString *)urlString query:(NSDictionary *)query animated:(BOOL)animated callBackHandler:(CallBackHandler)handler{
    UIViewController *viewController = [UIViewController initFromString:urlString withQuery:query fromConfig:[NBURLRouter sharedNBURLRouter].configDict];
    viewController.hidesBottomBarWhenPushed = [NBURLRouter sharedNBURLRouter].hideBottomBarWhenPushed;
    viewController.callBackHandler = handler;
    [NBURLNavigation pushViewController:viewController animated:animated];
}

+ (void)presentViewController:(UIViewController *)viewControllerToPresent animated: (BOOL)animated completion:(void (^ __nullable)(void))completion {
    [NBURLRouter presentViewController:viewControllerToPresent animated:animated completion:completion callBackHandler:nil];
}

+ (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)animated completion:(void (^)(void))completion callBackHandler:(CallBackHandler)handler{
    if (handler) {
        viewControllerToPresent.callBackHandler = handler;
    }
    [NBURLNavigation presentViewController:viewControllerToPresent animated:animated completion:completion];
}

+ (void)presentViewController:(UIViewController *)viewControllerToPresent animated: (BOOL)animated withNavigationClass:(Class)classType completion:(void (^ __nullable)(void))completion {
    
    [NBURLRouter presentViewController:viewControllerToPresent animated:animated withNavigationClass:classType completion:completion callBackHandler:nil];
}

+ (void)presentViewController:(UIViewController *)viewControllerToPresent animated: (BOOL)animated withNavigationClass:(Class)classType completion:(void (^ __nullable)(void))completion callBackHandler:(CallBackHandler)handler{
    if (handler) {
        viewControllerToPresent.callBackHandler = handler;
    }
    if ([classType isSubclassOfClass:[UINavigationController class]]) {
        UINavigationController *nav =  [[classType alloc]initWithRootViewController:viewControllerToPresent];
        [NBURLNavigation presentViewController:nav animated:animated completion:completion];
    }
}


+ (void)presentURLString:(NSString *)urlString animated:(BOOL)animated completion:(void (^ __nullable)(void))completion{
    [NBURLRouter presentURLString:urlString animated:animated completion:completion callBackHandler:nil];
}

+ (void)presentURLString:(NSString *)urlString animated:(BOOL)animated completion:(void (^ __nullable)(void))completion callBackHandler:(CallBackHandler)handler{
    
    UIViewController *viewController = [UIViewController initFromString:urlString fromConfig:[NBURLRouter sharedNBURLRouter].configDict];
    if (handler) {
        viewController.callBackHandler = handler;
    }
    [NBURLNavigation presentViewController:viewController animated:animated completion:completion];
}

+ (void)presentURLString:(NSString *)urlString query:(NSDictionary *)query animated:(BOOL)animated completion:(void (^ __nullable)(void))completion{
    [NBURLRouter presentURLString:urlString query:query animated:animated completion:completion callBackHandler:nil];
}

+ (void)presentURLString:(NSString *)urlString query:(NSDictionary *)query animated:(BOOL)animated completion:(void (^ __nullable)(void))completion callBackHandler:(CallBackHandler)handler{
    UIViewController *viewController = [UIViewController initFromString:urlString withQuery:query fromConfig:[NBURLRouter sharedNBURLRouter].configDict];
    if (handler) {
        viewController.callBackHandler = handler;
    }
    [NBURLNavigation presentViewController:viewController animated:animated completion:completion];

}

+ (void)presentURLString:(NSString *)urlString animated:(BOOL)animated withNavigationClass:(Class)classType completion:(void (^ __nullable)(void))completion{
    [NBURLRouter presentURLString:urlString animated:animated withNavigationClass:classType completion:completion callBackHandler:nil];
}

+ (void)presentURLString:(NSString *)urlString animated:(BOOL)animated withNavigationClass:(Class)classType completion:(void (^ __nullable)(void))completion callBackHandler:(CallBackHandler)handler{
    UIViewController *viewController = [UIViewController initFromString:urlString fromConfig:[NBURLRouter sharedNBURLRouter].configDict];
    if (handler) {
        viewController.callBackHandler = handler;
    }
    if ([classType isSubclassOfClass:[UINavigationController class]]) {
        UINavigationController *nav =  [[classType alloc]initWithRootViewController:viewController];
        [NBURLNavigation presentViewController:nav animated:animated completion:completion];
    }
}

+ (void)presentURLString:(NSString *)urlString query:(NSDictionary *)query animated:(BOOL)animated withNavigationClass:(Class)classType completion:(void (^ __nullable)(void))completion{
    [NBURLRouter presentURLString:urlString query:query animated:animated withNavigationClass:classType completion:completion callBackHandler:nil];
}
+ (void)presentURLString:(NSString *)urlString query:(NSDictionary *)query animated:(BOOL)animated withNavigationClass:(Class)classType completion:(void (^ __nullable)(void))completion callBackHandler:(CallBackHandler)handler{
    UIViewController *viewController = [UIViewController initFromString:urlString withQuery:query fromConfig:[NBURLRouter sharedNBURLRouter].configDict];
    if (handler) {
        viewController.callBackHandler = handler;
    }
    if ([classType isSubclassOfClass:[UINavigationController class]]) {
        UINavigationController *nav =  [[classType alloc]initWithRootViewController:viewController];
        [NBURLNavigation presentViewController:nav animated:animated completion:completion];
    }
}

+ (void)popViewControllerAnimated:(BOOL)animated {
    [NBURLNavigation popViewControllerWithTimes:1 animated:animated];
}

+ (void)popTwiceViewControllerAnimated:(BOOL)animated {
    [NBURLNavigation popTwiceViewControllerAnimated:animated];
}
+ (void)popViewControllerWithTimes:(NSUInteger)times animated:(BOOL)animated {
    [NBURLNavigation popViewControllerWithTimes:times animated:animated];
}

+ (void)popToViewController:(UIViewController *)viewController animated:(BOOL)animated{
    [NBURLNavigation popToViewController:viewController animated:animated];
}

+ (void)popToRootViewControllerAnimated:(BOOL)animated {
    [NBURLNavigation popToRootViewControllerAnimated:animated];
}


+ (void)dismissViewControllerAnimated: (BOOL)animated completion: (void (^ __nullable)(void))completion {
    [NBURLNavigation dismissViewControllerWithTimes:1 animated:animated completion:completion];
}
+ (void)dismissTwiceViewControllerAnimated: (BOOL)animated completion: (void (^ __nullable)(void))completion {
    [NBURLNavigation dismissTwiceViewControllerAnimated:animated completion:completion];
}

+ (void)dismissViewControllerWithTimes:(NSUInteger)times animated: (BOOL)animated completion: (void (^ __nullable)(void))completion {
    [NBURLNavigation dismissViewControllerWithTimes:times animated:animated completion:completion];
}

+ (void)dismissToRootViewControllerAnimated: (BOOL)animated completion: (void (^ __nullable)(void))completion {
    [NBURLNavigation dismissToRootViewControllerAnimated:animated completion:completion];
}

+ (void)IntentToMaker:(NBURLRouteMaker *)maker{
    UIViewController *viewController = maker.m_viewController;
    if (!viewController) {
        viewController = [UIViewController initFromMaker:maker fromConfig:[NBURLRouter sharedNBURLRouter].configDict];
    }
    if (viewController) {
        //是否隐藏底部工具栏
        viewController.hidesBottomBarWhenPushed = maker.m_hideBottomBarWhenPush;
        viewController.callBackHandler = maker.m_handler;
        if ([maker.m_navigationClass isSubclassOfClass:[UINavigationController class]]) {
            UINavigationController *nav =  [[maker.m_navigationClass alloc]initWithRootViewController:viewController];
            if (maker.m_intentType == IntentTypePresent) {
                [NBURLNavigation presentViewController:nav animated:maker.m_animate completion:maker.m_completion];
            }else{
                NSAssert(0, @"抱歉,导航栏跳转不支持自定义设置导航栏");
            }
        }else{
            //直接忽视,不设置导航栏控制器
            if (maker.m_intentType == IntentTypePush) {
                [NBURLNavigation pushViewController:viewController animated:maker.m_animate];
            }else{
                [NBURLNavigation presentViewController:viewController animated:maker.m_animate completion:maker.m_completion];
            }
        }
    }else{
        NSAssert(0, @"请正确设置目标控制器");
    }
}

+ (void)IntentTo:(void (^)(NBURLRouteMaker * _Nonnull))block{
    NBURLRouteMaker *maker = [NBURLRouteMaker new];
    block(maker);
    [NBURLRouter IntentToMaker:maker];
}

@end
