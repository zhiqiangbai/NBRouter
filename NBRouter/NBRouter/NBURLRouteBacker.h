//
//  NBURLRouteBacker.h
//  NBRouter
//
//  Created by NapoleonBai on 2017/3/9.
//  Copyright © 2017年 BaiZhiqiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NBURLRouteBacker;

typedef void(^BackerCompletion)();

typedef NBURLRouteBacker *(^Times)(NSUInteger times);
typedef NBURLRouteBacker *(^BackerAnimate)(BOOL animate);
typedef NBURLRouteBacker *(^ToRoot)();



/**
 界面返回时配置管理
 */
@interface NBURLRouteBacker : NSObject

@property(nonatomic,copy,readonly)Times times;///< 界面个数
@property(nonatomic,copy,readonly)BackerAnimate animate;///< 动画
@property(nonatomic,copy,readonly)ToRoot toRoot;///< 去顶层


@property(nonatomic,assign,readonly)BOOL m_animate;///< 动画
@property(nonatomic,assign,readonly)BOOL m_isToRoot;///< 去顶层
@property(nonatomic,assign,readonly)NSUInteger m_times;///< 返回界面个数
@end


@class NBURLRouteDismissBacker;

typedef NBURLRouteDismissBacker *(^BackerCompletionHandler)(BackerCompletion completion);


/**
 dismiss的时候,优先权
 */
@interface NBURLRouteDismissBacker : NBURLRouteBacker

@property(nonatomic,copy,readonly)BackerCompletionHandler completion;///< dismiss时回调
@property(nonatomic,copy,readonly)BackerCompletion m_completion;///< dismiss时支持回调

@end

@class NBURLRoutePopBacker;

typedef NBURLRoutePopBacker *(^ToViewController)(NSString *viewControllerName);

/**
 POP的时候,优先权为: toRoot > viewController > times
 也就是说,如果设置了toRoot,那么就直接回到根控制器
 如果没有设置toRoot,但设置了viewController,那么就退到里根控制器最近的这个控制器
 如果只设置了times,那么就以times为准
 */
@interface NBURLRoutePopBacker : NBURLRouteBacker

@property(nonatomic,copy,readonly)ToViewController viewController;///< 指定控制器

@property(nonatomic,copy,readonly)NSString *m_toViewControllerName;///< 指定控制器

@end
