//
//  NBURLRouteBacker.m
//  NBRouter
//
//  Created by NapoleonBai on 2017/3/9.
//  Copyright © 2017年 BaiZhiqiang. All rights reserved.
//

#import "NBURLRouteBacker.h"

@interface NBURLRouteBacker()

@property(nonatomic,copy,readwrite)Times times;///< 界面个数
@property(nonatomic,copy,readwrite)BackerAnimate animate;///< 动画
@property(nonatomic,copy,readwrite)ToRoot toRoot;///< 去顶层


@property(nonatomic,assign,readwrite)BOOL m_animate;///< 动画
@property(nonatomic,assign,readwrite)BOOL m_isToRoot;///< 去顶层
@property(nonatomic,assign,readwrite)NSUInteger m_times;///< 返回界面个数

@end

@implementation NBURLRouteBacker

- (instancetype)init{
    self = [super init];
    if (self) {
        self.m_animate = YES;
        self.m_times = 1;
        self.m_isToRoot = NO;
    }
    return self;
}


- (BackerAnimate)animate{
    if (!_animate) {
        __weak typeof(self) weakSelf = self;
        _animate = ^(BOOL animate) {
            weakSelf.m_animate = animate;
            return weakSelf;
        };
    }
    return _animate;
}
- (ToRoot)toRoot{
    if (!_toRoot) {
        __weak typeof(self) weakSelf = self;
        _toRoot = ^() {
            weakSelf.m_isToRoot = YES;
            return weakSelf;
        };
    }
    return _toRoot;
}

- (Times)times{
    if (!_times) {
        __weak typeof(self) weakSelf = self;
        _times = ^(NSUInteger times) {
            weakSelf.m_times = times;
            return weakSelf;
        };
    }
    return _times;
}


@end

@interface NBURLRouteDismissBacker()

@property(nonatomic,copy,readwrite)BackerCompletionHandler completion;///< dismiss时回调

@property(nonatomic,copy,readwrite)BackerCompletion m_completion;///< dismiss时支持回调

@end

@implementation NBURLRouteDismissBacker

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.m_completion = NULL;
    }
    return self;
}

- (BackerCompletionHandler)completion{
    if (!_completion) {
        __weak typeof(self) weakSelf = self;
        _completion =  ^(BackerCompletion completion) {
            weakSelf.m_completion = completion;
            return weakSelf;
        };
    }
    return _completion;
}

@end


@interface NBURLRoutePopBacker()

@property(nonatomic,copy,readwrite)ToViewController viewController;///< 指定控制器

@property(nonatomic,copy,readwrite)NSString *m_toViewControllerName;///< 指定控制器
@end

@implementation NBURLRoutePopBacker

- (ToViewController)viewController{
    if (!_viewController) {
        __weak typeof(self) weakSelf = self;
        _viewController =  ^(NSString * viewControllerName) {
            weakSelf.m_toViewControllerName = viewControllerName;
            return weakSelf;
        };
    }
    return _viewController;
}

@end
