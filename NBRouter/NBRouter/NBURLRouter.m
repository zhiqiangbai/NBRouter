//
//  NBURLRouter.m
//  NBRouter
//
//  Created by NapoleonBai on 16/10/16.
//  Copyright © 2016年 BaiZhiqiang. All rights reserved.
//

#import "NBURLRouter.h"
#import "NBURLNavigation.h"


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
    
    [NBURLNavigation pushViewController:viewController animated:animated];
}

+ (void)pushURLString:(NSString *)urlString animated:(BOOL)animated {
    
    UIViewController *viewController = [UIViewController initFromString:urlString fromConfig:[NBURLRouter sharedNBURLRouter].configDict];
    [NBURLNavigation pushViewController:viewController animated:animated];
}

+ (void)pushURLString:(NSString *)urlString query:(NSDictionary *)query animated:(BOOL)animated{
    UIViewController *viewController = [UIViewController initFromString:urlString withQuery:query fromConfig:[NBURLRouter sharedNBURLRouter].configDict];
    [NBURLNavigation pushViewController:viewController animated:animated];
}

+ (void)presentViewController:(UIViewController *)viewControllerToPresent animated: (BOOL)flag completion:(void (^ __nullable)(void))completion {
    [NBURLNavigation presentViewController:viewControllerToPresent animated:flag completion:completion];
}

+ (void)presentViewController:(UIViewController *)viewControllerToPresent animated: (BOOL)flag withNavigationClass:(Class)classType completion:(void (^ __nullable)(void))completion {
    
    if ([classType isSubclassOfClass:[UINavigationController class]]) {
        UINavigationController *nav =  [[classType alloc]initWithRootViewController:viewControllerToPresent];
        [NBURLNavigation presentViewController:nav animated:flag completion:completion];
    }
}

+ (void)presentURLString:(NSString *)urlString animated:(BOOL)animated completion:(void (^ __nullable)(void))completion{
    UIViewController *viewController = [UIViewController initFromString:urlString fromConfig:[NBURLRouter sharedNBURLRouter].configDict];
    [NBURLNavigation presentViewController:viewController animated:animated completion:completion];
}


+ (void)presentURLString:(NSString *)urlString query:(NSDictionary *)query animated:(BOOL)animated completion:(void (^ __nullable)(void))completion{
    UIViewController *viewController = [UIViewController initFromString:urlString withQuery:query fromConfig:[NBURLRouter sharedNBURLRouter].configDict];
    [NBURLNavigation presentViewController:viewController animated:animated completion:completion];
}


+ (void)pushURLString:(NSString *)urlString query:(NSDictionary *)query animated:(BOOL)animated replace:(BOOL)replace{
    UIViewController *viewController = [UIViewController initFromString:urlString withQuery:query fromConfig:[NBURLRouter sharedNBURLRouter].configDict];
    [NBURLNavigation pushViewController:viewController animated:animated];
}


+ (void)presentURLString:(NSString *)urlString animated:(BOOL)animated withNavigationClass:(Class)classType completion:(void (^ __nullable)(void))completion{
    
    UIViewController *viewController = [UIViewController initFromString:urlString fromConfig:[NBURLRouter sharedNBURLRouter].configDict];
    if ([classType isSubclassOfClass:[UINavigationController class]]) {
        UINavigationController *nav =  [[classType alloc]initWithRootViewController:viewController];
        [NBURLNavigation presentViewController:nav animated:animated completion:completion];
    }
}

+ (void)presentURLString:(NSString *)urlString query:(NSDictionary *)query animated:(BOOL)animated withNavigationClass:(Class)clazz completion:(void (^ __nullable)(void))completion{
    UIViewController *viewController = [UIViewController initFromString:urlString withQuery:query fromConfig:[NBURLRouter sharedNBURLRouter].configDict];
    if ([clazz isSubclassOfClass:[UINavigationController class]]) {
        UINavigationController *nav =  [[clazz alloc]initWithRootViewController:viewController];
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


+ (void)dismissViewControllerAnimated: (BOOL)flag completion: (void (^ __nullable)(void))completion {
    [NBURLNavigation dismissViewControllerWithTimes:1 animated:flag completion:completion];
}
+ (void)dismissTwiceViewControllerAnimated: (BOOL)flag completion: (void (^ __nullable)(void))completion {
    [NBURLNavigation dismissTwiceViewControllerAnimated:flag completion:completion];
}

+ (void)dismissViewControllerWithTimes:(NSUInteger)times animated: (BOOL)flag completion: (void (^ __nullable)(void))completion {
    [NBURLNavigation dismissViewControllerWithTimes:times animated:flag completion:completion];
}

+ (void)dismissToRootViewControllerAnimated: (BOOL)flag completion: (void (^ __nullable)(void))completion {
    [NBURLNavigation dismissToRootViewControllerAnimated:flag completion:completion];
}



@end
