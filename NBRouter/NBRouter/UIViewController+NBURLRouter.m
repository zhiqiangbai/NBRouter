//
//  UIViewController+NBURLRouter.m
//  NBRouter
//
//  Created by NapoleonBai on 16/10/18.
//  Copyright © 2016年 BaiZhiqiang. All rights reserved.
//

#import "UIViewController+NBURLRouter.h"
#import "NBURLRouter.h"
#import "NBURLRouteMaker.h"
#import <objc/runtime.h>


static void * URLoriginUrl = (void *)@"URLoriginUrl";
static void * URLpath = (void *)@"URLpath";
static void * URLparams = (void *)@"URLparams";
static void * URLHandler = (void *)@"URLHandler";



@implementation UIViewController (NBURLRouter)

- (void)setOriginUrl:(NSURL *)originUrl {
    // 为分类设置属性值
    objc_setAssociatedObject(self, URLoriginUrl,
                             originUrl,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSURL *)originUrl {
    // 获取分类的属性值
    return objc_getAssociatedObject(self, URLoriginUrl);
}

- (void)setPath:(NSURL *)path{
    objc_setAssociatedObject(self, URLpath,
                             path,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)path {
    return objc_getAssociatedObject(self, URLpath);
}


- (void)setParams:(NSDictionary *)params{
    objc_setAssociatedObject(self, URLparams,
                             params,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSDictionary *)params {
    return objc_getAssociatedObject(self, URLparams);
}


- (void)setCallBackHandler:(CallBackHandler)handler{
    objc_setAssociatedObject(self, URLHandler,
                             handler,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CallBackHandler)callBackHandler{
    return objc_getAssociatedObject(self, URLHandler);
}


+ (UIViewController *)initFromMaker:(NBURLRouteMaker *)maker fromConfig:(NSDictionary *)configDict{
    //如果设置了目标控制器,则直接使用
    if (maker.m_viewController) {
        //配置参数及回调块
        maker.m_viewController.params = maker.m_parmas;
        return maker.m_viewController;
    }
    

    if (maker.status.isError) {
        // 返回失败的界面
        return [UIViewController infoViewController:maker.status.statusMsg];

    }
    
    NSURL *url = [NSURL URLWithString:[maker.m_urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];

    
    
    UIViewController *intentViewController = nil;
    // 处理url,去掉有可能会拼接的参数
    NSString *intentKey = [NSString stringWithFormat:@"%@%@%@",
                           url.scheme==nil ? @"" : [NSString stringWithFormat:@"%@://",url.scheme],
                           url.host == nil ? @"" : url.host,
                           url.path == nil ? @"" : url.path];

    // 字典中的所有的key是否包含传入的协议头
    if([configDict.allKeys containsObject:url.scheme]){
        // 根据协议头取出值
        id config = [configDict objectForKey:url.scheme];
        //当此链接的协议头为http / https
        if([config isKindOfClass:[NSString class]]){
            intentViewController = [UIViewController viewControllerMaker:maker withViewControllerName:config];
        }else if([config isKindOfClass:[NSDictionary class]]){
            // 多为自定义协议头
            NSDictionary *dict = (NSDictionary *)config;
            if([dict.allKeys containsObject:intentKey]){
                intentViewController = [UIViewController viewControllerMaker:maker withViewControllerName:[dict objectForKey:intentKey]];
            }else{
                // 为了格式规范,如果存在该协议头,直接提示移动到协议下面
                NSAssert(0, @"你可能将链接没有存放在对应的协议下面,赶紧趁协议不注意,移过去吧!");
            }
        }
    }else{
        // 没有该协议或者说没有协议头进入
        if ([configDict.allKeys containsObject:intentKey]) {
            // 说明找到了目标
            intentViewController = [UIViewController viewControllerMaker:maker withViewControllerName:[configDict objectForKey:intentKey]];
        }else{
            // 说明链接有误
            // 展示错误界面
            NSString * infoStr = [NSString stringWithFormat:@"错误的链接: %@",url];
            intentViewController = [UIViewController infoViewController:infoStr];
        }
    }
    
    if (intentViewController && [intentViewController respondsToSelector:@selector(open:withQuery:)]){
        [intentViewController open:url withQuery:maker.m_parmas];
    }

    return intentViewController;
}


/**
 将链接后置参数与字传参进行取舍,目前优先采用query参入的参数

 @param url url链接
 @param query 字典方式传入参数
 */
- (void)open:(NSURL *)url withQuery:(NSDictionary *)query{
    self.path = [url path];
    self.originUrl = url;
    if (query) {
        // 如果自定义url后面有拼接参数,而且又通过query传入了参数,那么优先query传入了参数
        self.params = query;
    }else {
        self.params = [self paramsURL:url];
    }
}


/**
 根据maker和控制器名称得到控制器对象

 @param maker maker对象
 @param viewControllerName 控制器名称
 @return 控制器对象
 */
+ (UIViewController *)viewControllerMaker:(NBURLRouteMaker *)maker withViewControllerName:(NSString *)viewControllerName{
    UIViewController *intentViewController = nil;
    switch (maker.m_loadViewControllerType) {
        case LoadViewControllerTypeCode:
        {
            Class class =  NSClassFromString(viewControllerName); // 根据key拿到对应的控制器名称
            if (class == nil) {
                // 兼容swift,字符串转类名的时候前面加上命名空间
                NSString *spaceName = maker.m_bundle.infoDictionary[@"CFBundleExecutable"];
                class =  NSClassFromString([NSString stringWithFormat:@"%@.%@",spaceName,viewControllerName]);
            }
            intentViewController = [[class alloc]init];
        }
            break;
        case LoadViewControllerTypeXib:
            intentViewController = [maker.m_bundle loadNibNamed:viewControllerName owner:self options:NULL].lastObject;
            break;
        case LoadViewControllerTypeStoryboard:
        {
            //获取storyboard: 通过bundle根据storyboard的名字来获取我们的storyboard,
            UIStoryboard *story = [UIStoryboard storyboardWithName:maker.m_storyboard bundle:maker.m_bundle];
            //由storyboard根据myView的storyBoardID来获取我们要切换的视图
            intentViewController = [story instantiateViewControllerWithIdentifier:maker.m_identifier];
        }
            break;
    }
    return intentViewController;
}

/**
 将url的参数部分转化为字典

 @param url 需要转化的url
 @return 生成的字典
 */
- (NSDictionary *)paramsURL:(NSURL *)url {
    
    NSMutableDictionary* pairs = [NSMutableDictionary dictionary];
    if (NSNotFound != [url.absoluteString rangeOfString:@"?"].location) {
        NSString *paramString = [url.absoluteString substringFromIndex:
                                 ([url.absoluteString rangeOfString:@"?"].location + 1)];
        NSCharacterSet* delimiterSet = [NSCharacterSet characterSetWithCharactersInString:@"&"];
        NSScanner* scanner = [[NSScanner alloc] initWithString:paramString];
        while (![scanner isAtEnd]) {
            NSString* pairString = nil;
            [scanner scanUpToCharactersFromSet:delimiterSet intoString:&pairString];
            [scanner scanCharactersFromSet:delimiterSet intoString:NULL];
            NSArray* kvPair = [pairString componentsSeparatedByString:@"="];
            if (kvPair.count == 2) {
                NSString* key = [[kvPair objectAtIndex:0] stringByRemovingPercentEncoding];
                NSString* value = [[kvPair objectAtIndex:1] stringByRemovingPercentEncoding];
                [pairs setValue:value forKey:key];
            }
        }
    }
    return [NSDictionary dictionaryWithDictionary:pairs];
}

/**
 信息展示控制器

 @param infoStr 提示信息
 @return 控制器
 */
+ (UIViewController *)infoViewController:(NSString *)infoStr{
    UIViewController *viewController = [UIViewController new];
    viewController.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    UILabel *label = [[UILabel alloc]initWithFrame:viewController.view.frame];
    label.textColor = [UIColor redColor];
    label.text = infoStr;
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    [viewController.view addSubview:label];
    
    return viewController;
}


@end
