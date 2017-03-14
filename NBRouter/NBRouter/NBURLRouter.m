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

@property(nonatomic,copy) NSDictionary *configDict; ///< 存储读取的plist文件数据
@property(nonatomic,copy,readwrite)NSString *mHttpScheme;         ///< http协议头
@property(nonatomic,copy,readwrite)NSString *mHttpsScheme;        ///< https协议头
//@property(nonatomic,copy,readwrite)NSArray *mCustomSchemes;     ///< 自定义协议头

@property(nonatomic,strong,readwrite)UIViewController *currentViewController; ///< 当前控制器

@end

@implementation NBURLRouter

- (UIViewController *)currentViewController{
    return [NBURLNavigation sharedNBURLNavigation].currentViewController;
}

//+ (void)setCustomSchemes:(NSArray *)schemes{
//    [NBURLRouter sharedNBURLRouter].mCustomSchemes = schemes;
//}

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

+ (void)setUrlsConfigDict:(NSDictionary *)urlsDict{
    [NBURLRouter sharedNBURLRouter].configDict = urlsDict;
}

+ (void)setRootViewControllerForMaker:(void (^)(NBURLRouteMaker * _Nonnull maker))makerBlock{
    NBURLRouteMaker *maker = [NBURLRouteMaker new];
    makerBlock(maker);
    UIViewController *viewController = [UIViewController initFromMaker:maker fromConfig:[NBURLRouter sharedNBURLRouter].configDict];
    //如果设置了导航栏
    if (maker.m_navigationClass && [maker.m_navigationClass isSubclassOfClass:[UINavigationController class]]) {
        UINavigationController *nav =  [[maker.m_navigationClass alloc]initWithRootViewController:viewController];
        [NBURLNavigation setRootViewController:nav];
    }else{
        //没有设置导航栏
        [NBURLNavigation setRootViewController:viewController];
    }
}

+ (void)push:(void (^)(NBURLRouteMaker * _Nonnull maker))makerBlock{
    NBURLRouteMaker *maker = [NBURLRouteMaker new];
    makerBlock(maker);
    UIViewController *viewController = [UIViewController initFromMaker:maker fromConfig:[NBURLRouter sharedNBURLRouter].configDict];
    viewController.hidesBottomBarWhenPushed = maker.m_hideBottomBarWhenPush;
    viewController.callBackHandler = maker.m_handler;
    // 如果导航栏跳转还设置了导航栏,直接进入此
    if (maker.m_navigationClass) {
        NSAssert(0, @"抱歉,导航栏跳转不支持自定义设置导航栏");
    }else{
        [NBURLNavigation pushViewController:viewController animated:maker.m_animate];
    }
}

+ (void)present:(void (^)(NBURLRouteMaker * _Nonnull maker))makerBlock{
    NBURLRouteMaker *maker = [NBURLRouteMaker new];
    makerBlock(maker);
    UIViewController *viewController = [UIViewController initFromMaker:maker fromConfig:[NBURLRouter sharedNBURLRouter].configDict];
    viewController.hidesBottomBarWhenPushed = maker.m_hideBottomBarWhenPush;
    viewController.callBackHandler = maker.m_handler;
    // 如果设置了导航栏
    if ([maker.m_navigationClass isSubclassOfClass:[UINavigationController class]]) {
        UINavigationController *nav =  [[maker.m_navigationClass alloc]initWithRootViewController:viewController];
        [NBURLNavigation presentViewController:nav animated:maker.m_animate completion:maker.m_completion];
    }else{
        [NBURLNavigation presentViewController:viewController animated:maker.m_animate completion:maker.m_completion];
    }
}

+ (void)pop{
    [NBURLRouter pop:nil];
}

+ (void)pop:(void (^  _Nullable)(NBURLRoutePopBacker * _Nonnull backer))backerBlock{
    NBURLRoutePopBacker *backer = [NBURLRoutePopBacker new];
    backerBlock(backer);
    // 如果设置了root,那么以root为准,如果没设置,就以times为准
    if (backer.m_isToRoot) {
        [NBURLNavigation popToRootViewControllerAnimated:backer.m_animate];
    }else{
        if (backer.m_toViewControllerName && [NSClassFromString(backer.m_toViewControllerName) isKindOfClass:[UIViewController class]]) {
            Class class = NSClassFromString(backer.m_toViewControllerName);
            if ( [class isKindOfClass:[UIViewController class]]) {
                //说明是跳转到指定控制器
                [NBURLNavigation popToViewController:(UIViewController *)class animated:backer.m_animate];
            }else{
                NSAssert(0, @"请正确设置目标控制器 %@ 不是UIViewController的子类",backer.m_toViewControllerName);
            }
        }else{
            if (backer.m_times<=0) {
                NSAssert(0, @"请正确设置times");
            }else{
                [NBURLNavigation popViewControllerWithTimes:backer.m_times animated:backer.m_animate];
            }
        }
    }
}

+ (void)dismiss{
    [NBURLRouter dismiss:nil];
}

+ (void)dismiss:(void (^  _Nullable)(NBURLRouteDismissBacker * _Nonnull backer))backerBlock{
    NBURLRouteDismissBacker *backer = [NBURLRouteDismissBacker new];
    backerBlock(backer);
    // 如果设置了root,那么以root为准,如果没设置,就以times为准
    if (backer.m_isToRoot) {
        [NBURLNavigation dismissToRootViewControllerAnimated:backer.m_animate completion:backer.m_completion];
    }else{
        if (backer.m_times<=0) {
            NSAssert(0, @"请正确设置times");
        }else{
            [NBURLNavigation dismissViewControllerWithTimes:backer.m_times animated:backer.m_animate completion:backer.m_completion];
        }
    }
}

@end
