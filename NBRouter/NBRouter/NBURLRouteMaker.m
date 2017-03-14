//
//  NBURLRouteMaker.m
//  NBRouter
//
//  Created by NapoleonBai on 2017/1/5.
//  Copyright © 2017年 BaiZhiqiang. All rights reserved.
//

#import "NBURLRouteMaker.h"
#import "NBURLRouter.h"

@interface NBURLRouteMaker()

@property(nonatomic,copy,readwrite)NSString * m_storyboard;///< storyboard name
@property(nonatomic,copy,readwrite)NSString * m_xib;///< xib name
@property(nonatomic,copy,readwrite)NSString * m_identifier;///< identifier
@property(nonatomic,strong,readwrite)NSBundle * m_bundle;///< bundle , 默认为:[NSBundle mainBundle]
@property(nonatomic,assign,readwrite)BOOL m_hideBottomBarWhenPush;///< push时是否隐藏底部栏,默认不隐藏
@property(nonatomic,copy,readwrite)NSString * m_urlStr;///< 跳转url
@property(nonatomic,assign,readwrite)BOOL m_animate;///< 跳转动画
@property(nonatomic,copy,readwrite)NSDictionary * m_parmas;///< 跳转参数
@property(nonatomic,copy,readwrite)BackHandler m_handler;///< 跳转url
@property(nonatomic,copy,readwrite)Class m_navigationClass;///< 跳转后设置的导航栏类
@property(nonatomic,copy,readwrite)UIViewController *m_viewController;
@property(nonatomic,assign,readwrite)LoadViewControllerType m_loadViewControllerType;
@property(nonatomic,copy,readwrite)Completion m_completion;///< 模态跳转时回调
@property(nonatomic,assign,readwrite)struct NBURLRouteMakerStatus status;/// < 配置状态


@end

@implementation NBURLRouteMaker
@synthesize storyboardName = _storyboardName;
@synthesize xibName = _xibName;
@synthesize bundle = _bundle;
@synthesize identifier = _identifier;
@synthesize hidesBottomBarWhenPushed = _hidesBottomBarWhenPushed;
@synthesize intentUrlStr = _intentUrlStr;
@synthesize animate = _animate;
@synthesize handler = _handler;
@synthesize parmas = _parmas;
@synthesize navigationClass = _navigationClass;
@synthesize viewController = _viewController;
@synthesize completion = _completion;

- (instancetype)init{
    if (self = [super init]) {
        self.m_hideBottomBarWhenPush = YES;
        self.m_loadViewControllerType = LoadViewControllerTypeCode;
        self.m_bundle = [NSBundle mainBundle];
    }
    return self;
}

- (LoadStoryboardName)storyboardName{
    if (!_storyboardName) {
        __weak typeof(self) weakSelf = self;
        _storyboardName = ^(NSString *storyboardName) {
            weakSelf.m_storyboard = storyboardName;
            weakSelf.m_loadViewControllerType = LoadViewControllerTypeStoryboard;
            return weakSelf;
        };
    }
    return _storyboardName;
}

- (LoadXibName)xibName{
    if (!_xibName) {
         __weak typeof(self) weakSelf = self;
        _xibName = ^(NSString *xibName) {
            weakSelf.m_xib = xibName;
            weakSelf.m_loadViewControllerType = LoadViewControllerTypeXib;
            return weakSelf;
        };
    }
    return _xibName;
}

- (LoadIdentifier)identifier{
    if (!_identifier) {
        __weak typeof(self) weakSelf = self;
        _identifier = ^(NSString *identifier) {
            weakSelf.m_identifier = identifier;
            return weakSelf;
        };
    }
    return _identifier;
}

- (FromBundle)bundle{
    if (!_bundle) {
        __weak typeof (self) weakSelf = self;
        _bundle = ^(NSBundle * bundle) {
            weakSelf.m_bundle = bundle;
            return weakSelf;
        };
    }
    return _bundle;
}

- (HidesBottomBarWhenPushed)hidesBottomBarWhenPushed{
    if (!_hidesBottomBarWhenPushed) {
        __weak typeof(self) weakSelf = self;
        _hidesBottomBarWhenPushed =  ^(BOOL hide) {
            weakSelf.m_hideBottomBarWhenPush = hide;
            return weakSelf;
        };
    }
    return _hidesBottomBarWhenPushed;
}

- (IntentUrl)intentUrlStr{
    if (!_intentUrlStr) {
        __weak typeof(self) weakSelf = self;
        _intentUrlStr =  ^(NSString *urlStr) {
            weakSelf.m_urlStr = urlStr;
            return weakSelf;
        };
    }
    return _intentUrlStr;
}

- (Animate)animate{
    if (!_animate) {
        __weak typeof(self) weakSelf = self;
        _animate = ^(BOOL animate) {
            weakSelf.m_animate = animate;
            return weakSelf;
        };
    }
    return _animate;
}

- (Parmas)parmas{
    if (!_parmas) {
        __weak typeof(self) weakSelf = self;
        _parmas =  ^(NSDictionary *parmas) {
            weakSelf.m_parmas = parmas;
            return weakSelf;
        };
    }
    return _parmas;
}

- (Handler)handler{
    if (!_handler) {
        __weak typeof(self) weakSelf = self;
        _handler =  ^(BackHandler handler) {
            weakSelf.m_handler = handler;
            return weakSelf;
        };
    }
    return _handler;
}

- (CompletionHandler)completion{
    if (!_completion) {
        __weak typeof(self) weakSelf = self;
        _completion =  ^(Completion completion) {
            weakSelf.m_completion = completion;
            return weakSelf;
        };
    }
    return _completion;
}

- (NavigationClass)navigationClass{
    if (!_navigationClass) {
        __weak typeof(self) weakSelf = self;
        _navigationClass =  ^(Class class){
            weakSelf.m_navigationClass = class;
            return weakSelf;
        };
    }
    return _navigationClass;
}
- (IntentViewController)viewController{
    if (!_viewController) {
        __weak typeof(self) weakSelf = self;
        _viewController = ^(UIViewController *viewController){
            weakSelf.m_viewController = viewController;
            return weakSelf;
        };
    }
    return _viewController;
}

- (struct NBURLRouteMakerStatus)status{
    if (!_status.statusMsg) {
        _status = (struct NBURLRouteMakerStatus){@"",NO};
        if ([self emptyStr:_m_urlStr]) {
            return _status =  (struct NBURLRouteMakerStatus){@"NBURLRouteMaker:跳转URL不应该是空的!,eg: maker.intentUrlStr(@\"router://config\")",YES};
        }
        //如果是从storyboard中加载
        if(self.m_loadViewControllerType == LoadViewControllerTypeStoryboard) {
            if ([self emptyStr:_m_storyboard]) {
                return _status = (struct NBURLRouteMakerStatus){@"NBURLRouteMaker:storyboardName不应该是空的!,eg: maker.storyboardName(@\"storyboard\")",YES};
            }
            if ([self emptyStr:_m_identifier]) {
                return _status = (struct NBURLRouteMakerStatus){@"NBURLRouteMaker:identifier不应该是空的!,eg: maker.identifier(@\"identifier\")",YES};
            }
        }else if(self.m_loadViewControllerType == LoadViewControllerTypeXib){
            if ([self emptyStr:_m_xib]) {
                return _status = (struct NBURLRouteMakerStatus){@"NBURLRouteMaker:xibName不应该是空的!,eg: maker.xibName(@\"xibname\")",YES};
            }
        }
    }
    return _status;
}

- (BOOL)emptyStr:(NSString *)str{
    // 判断是否为空对象
    if (str == nil || [str isEqual:[NSNull null]] || [str isKindOfClass:[NSNull class]]) {
        return YES;
    }
    
    if ([[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0) {
        return YES;
    }
    return NO;
}

@end
