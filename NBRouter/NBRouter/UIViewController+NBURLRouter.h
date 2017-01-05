//
//  UIViewController+NBURLRouter.h
//  NBRouter
//
//  Created by NapoleonBai on 16/10/18.
//  Copyright © 2016年 BaiZhiqiang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NBURLRouteMaker;

NS_ASSUME_NONNULL_BEGIN
/**
 * 此block作为向上回传信息所用
 */
typedef void(^ __nullable CallBackHandler)(id parmas);

/**
 *  对页面跳转设置的分类,主要设置参数,创建控制器等
 */
@interface UIViewController (NBURLRouter)


@property (nonatomic,strong) NSURL           *originUrl;///< 跳转后控制器能拿到的url
@property (nonatomic,copy  ) NSString        *path;///< url路径
@property (nonatomic,strong) NSDictionary    *params;///< 跳转后控制器能拿到的参数
@property (nonatomic,weak  ) CallBackHandler callBackHandler;///< 返回上一个控制器时,如果有需要传递的参数,可以通过这个回传

// 根据参数创建控制器
+ (UIViewController *)initFromString:(NSString *)urlString fromConfig:(NSDictionary *)configDict;
// 根据参数创建控制器
+ (UIViewController *)initFromString:(NSString *)urlString withQuery:(NSDictionary *)query fromConfig:(NSDictionary *)configDict;

+ (UIViewController *)initFromMaker:(NBURLRouteMaker *)maker fromConfig:(NSDictionary *)configDict;
@end
NS_ASSUME_NONNULL_END
