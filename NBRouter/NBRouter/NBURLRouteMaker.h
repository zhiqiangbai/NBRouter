//
//  NBURLRouteMaker.h
//  NBRouter
//
//  Created by NapoleonBai on 2017/1/5.
//  Copyright © 2017年 BaiZhiqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, IntentType) {
    IntentTypeNull,///< 没有设置跳转
    IntentTypePush,///< 导航栏跳转
    IntentTypePresent,///< 模态跳转
};

typedef NS_ENUM(NSUInteger, LoadViewControllerType) {
    LoadViewControllerTypeCode,///< 纯代码加载
    LoadViewControllerTypeXib,///< 从xib中加载
    LoadViewControllerTypeStoryboard,///< 从storyboard中加载
};



typedef void(^BackHandler)(id parmas);
typedef void(^Completion)();

@class NBURLRouteMaker;

typedef NBURLRouteMaker *(^LoadStoryboardName)(NSString *storyboardName);
typedef NBURLRouteMaker *(^LoadXibName)(NSString *xibName);
typedef NBURLRouteMaker *(^LoadIdentifier)(NSString *identifier);
typedef NBURLRouteMaker *(^FromBundle)(NSBundle *bundle);
typedef NBURLRouteMaker *(^IntentUrl)(NSString *intentUrlStr);
typedef NBURLRouteMaker *(^NavigationClass)(Class classType);
typedef NBURLRouteMaker *(^IntentViewController)(UIViewController *viewController);
typedef NBURLRouteMaker *(^Parmas)(NSDictionary *parmas);
typedef NBURLRouteMaker *(^Handler)(BackHandler handler);
typedef NBURLRouteMaker *(^CompletionHandler)(Completion completion);
typedef NBURLRouteMaker *(^Animate)(BOOL animate);
typedef NBURLRouteMaker *(^HidesBottomBarWhenPushed)(BOOL hidesBottomBarWhenPushed);
typedef void (^Push)();
typedef void (^Present)();


@interface NBURLRouteMaker : NSObject

@property(nonatomic,copy,readonly)LoadStoryboardName storyboardName;///< storyboard name
@property(nonatomic,copy,readonly)LoadXibName xibName;///< xib name
@property(nonatomic,copy,readonly)LoadIdentifier identifier;///< identifier
@property(nonatomic,copy,readonly)FromBundle bundle;///< bundle , 默认为:[NSBundle mainBundle]
@property(nonatomic,copy,readonly)HidesBottomBarWhenPushed hidesBottomBarWhenPushed;///< push时是否隐藏底部栏,默认不隐藏
@property(nonatomic,copy,readonly)IntentUrl intentUrlStr;///< 跳转url
@property(nonatomic,copy,readonly)Animate animate;///< 动画
@property(nonatomic,copy,readonly)NavigationClass navigationClass;///< 自定义导航栏Class
@property(nonatomic,copy,readonly)IntentViewController viewController;///< 直接跳转到对应ViewController
@property(nonatomic,copy,readonly)Parmas parmas;///< 跳转时携带参数
@property(nonatomic,copy,readonly)Handler handler;///< 回调(页面返回时调用传参数)
@property(nonatomic,copy,readonly)CompletionHandler completion;///< 模态跳转时回调
@property(nonatomic,copy,readonly)Push push;///< 导航栏跳转
@property(nonatomic,copy,readonly)Present present;///< 模态跳转


@property(nonatomic,copy,readonly)NSString * m_storyboard;///< storyboard name
@property(nonatomic,copy,readonly)NSString * m_xib;///< xib name
@property(nonatomic,copy,readonly)NSString * m_identifier;///< identifier
@property(nonatomic,strong,readonly)NSBundle * m_bundle;///< bundle , 默认为:[NSBundle mainBundle]
@property(nonatomic,assign,readonly)BOOL m_hideBottomBarWhenPush;///< push时是否隐藏底部栏,默认不隐藏
@property(nonatomic,copy,readonly)NSString * m_urlStr;///< 跳转url
@property(nonatomic,assign,readonly)BOOL m_animate;///< 跳转动画
@property(nonatomic,copy,readonly)NSDictionary * m_parmas;///< 跳转参数
@property(nonatomic,copy,readonly)BackHandler m_handler;///< 回调(页面返回时调用传参数)
@property(nonatomic,copy,readonly)Completion m_completion;///< 模态跳转时回调
@property(nonatomic,copy,readonly)Class m_navigationClass;///< 跳转后设置的导航栏类
@property(nonatomic,copy,readonly)UIViewController *m_viewController;
@property(nonatomic,assign,readonly)IntentType m_intentType;
@property(nonatomic,assign,readonly)LoadViewControllerType m_loadViewControllerType;

@end
