//
//  UIViewController+NBURLRouter.h
//  NBRouter
//
//  Created by NapoleonBai on 16/10/18.
//  Copyright © 2016年 BaiZhiqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
/**
 *  对页面跳转设置的分类,主要设置参数,创建控制器等
 */
@interface UIViewController (NBURLRouter)

/** 跳转后控制器能拿到的url */
@property(nonatomic, strong) NSURL *originUrl;

/** url路径 */
@property(nonatomic,copy) NSString *path;

/** 跳转后控制器能拿到的参数 */
@property(nonatomic,strong) NSDictionary *params;

// 根据参数创建控制器
+ (UIViewController *)initFromString:(NSString *)urlString fromConfig:(NSDictionary *)configDict;
// 根据参数创建控制器
+ (UIViewController *)initFromString:(NSString *)urlString withQuery:(NSDictionary *)query fromConfig:(NSDictionary *)configDict;


@end
NS_ASSUME_NONNULL_END
