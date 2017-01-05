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


+ (UIViewController *)initFromString:(NSString *)urlString fromConfig:(NSDictionary *)configDict{
    NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    return [UIViewController initFromURL:url withQuery:nil fromConfig:configDict];
}

+ (UIViewController *)initFromString:(NSString *)urlString withQuery:(NSDictionary *)query fromConfig:(NSDictionary *)configDict{
    NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    return [UIViewController initFromURL:url withQuery:query fromConfig:configDict] ;
}

+ (UIViewController *)initFromMaker:(NBURLRouteMaker *)maker fromConfig:(NSDictionary *)configDict{
    NSURL *url = [NSURL URLWithString:[maker.m_urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    UIViewController *VC = nil;
    NSString *home;
    if(url.path == nil){ // 处理url,去掉有可能会拼接的参数
        home = [NSString stringWithFormat:@"%@://%@", url.scheme, url.host];
    }else{
        home = [NSString stringWithFormat:@"%@://%@%@", url.scheme, url.host,url.path];
    }
    if([configDict.allKeys containsObject:url.scheme]){ // 字典中的所有的key是否包含传入的协议头
        id config = [configDict objectForKey:url.scheme]; // 根据协议头取出值
        Class class = nil;
        if([config isKindOfClass:[NSString class]]){ //当协议头是http https的情况
            class =  NSClassFromString(config);
        }else if([config isKindOfClass:[NSDictionary class]]){ // 自定义的url情况
            NSDictionary *dict = (NSDictionary *)config;
            if([dict.allKeys containsObject:home]){
                
                switch (maker.m_loadViewControllerType) {
                    case LoadViewControllerTypeCode:
                    {
                        class =  NSClassFromString([dict objectForKey:home]); // 根据key拿到对应的控制器名称
                        if (class == nil) {
                            // 兼容swift,字符串转类名的时候前面加上命名空间
                            NSString *spaceName = [NSBundle mainBundle].infoDictionary[@"CFBundleExecutable"];
                            class =  NSClassFromString([NSString stringWithFormat:@"%@.%@",spaceName,[dict objectForKey:home]]);
                        }
                    }
                        break;
                        case LoadViewControllerTypeXib:
                            VC = [maker.m_bundle loadNibNamed:[dict objectForKey:home] owner:self options:NULL].lastObject;
                        break;
                    case LoadViewControllerTypeStoryboard:
                    {
                            //获取storyboard: 通过bundle根据storyboard的名字来获取我们的storyboard,
                            UIStoryboard *story = [UIStoryboard storyboardWithName:maker.m_storyboard bundle:maker.m_bundle];
                            //由storyboard根据myView的storyBoardID来获取我们要切换的视图
                            VC = [story instantiateViewControllerWithIdentifier:maker.m_identifier];
                    }
                        break;
                }
                
                if (VC && [VC respondsToSelector:@selector(open:withQuery:)]){
                    [VC open:url withQuery:maker.m_parmas];
                    return VC;
                }
            }
        }
        
        if(class !=nil){
            VC = [[class alloc]init];
            if([VC respondsToSelector:@selector(open:withQuery:)]){
                [VC open:url withQuery:maker.m_parmas];
            }
        }
        
        // 处理网络地址的情况
        if ([url.scheme isEqualToString:[NBURLRouter sharedNBURLRouter].mHttpScheme] || [url.scheme isEqualToString:[NBURLRouter sharedNBURLRouter].mHttpsScheme]) {
            class =  NSClassFromString([configDict objectForKey:url.scheme]);
            VC.params = @{@"urlStr": [url absoluteString]};
        }
    }
    return VC;
}


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

+ (UIViewController *)initFromURL:(NSURL *)url withQuery:(NSDictionary *)query fromConfig:(NSDictionary *)configDict
{
    UIViewController *VC = nil;
    NSString *home;
    if(url.path == nil){ // 处理url,去掉有可能会拼接的参数
        home = [NSString stringWithFormat:@"%@://%@", url.scheme, url.host];
    }else{
        home = [NSString stringWithFormat:@"%@://%@%@", url.scheme, url.host,url.path];
    }
    if([configDict.allKeys containsObject:url.scheme]){ // 字典中的所有的key是否包含传入的协议头
        id config = [configDict objectForKey:url.scheme]; // 根据协议头取出值
        Class class = nil;
        if([config isKindOfClass:[NSString class]]){ //当协议头是http https的情况
            class =  NSClassFromString(config);
        }else if([config isKindOfClass:[NSDictionary class]]){ // 自定义的url情况
            NSDictionary *dict = (NSDictionary *)config;
            if([dict.allKeys containsObject:home]){
                if ([url.scheme isEqualToString:[NBURLRouter sharedNBURLRouter].mNormalScheme]) {
                    class =  NSClassFromString([dict objectForKey:home]); // 根据key拿到对应的控制器名称
                    if (class == nil) {
                        // 兼容swift,字符串转类名的时候前面加上命名空间
                        NSString *spaceName = [NSBundle mainBundle].infoDictionary[@"CFBundleExecutable"];
                        class =  NSClassFromString([NSString stringWithFormat:@"%@.%@",spaceName,[dict objectForKey:home]]);
                    }

                }else if([url.scheme isEqualToString:[NBURLRouter sharedNBURLRouter].mXibScheme]){
                    // 从 xib 中加载
                    VC = [[NSBundle mainBundle] loadNibNamed:[dict objectForKey:home] owner:self options:NULL].lastObject;
                }else{
                    // 从 storyboard 中加载,需要知道storyboard name 以及 viewcontroller identifier
                    NSString *name_identifier;
                    if ([url.path containsString:@"/"]) {
                        name_identifier = [url.path componentsSeparatedByString:@"/"].lastObject;
                    }
                    NSString *storyboardName;
                    NSString *identifier;
                    if (name_identifier && [name_identifier containsString:@"."]) {
                        NSArray *tempArray = [name_identifier componentsSeparatedByString:@"."];
                        storyboardName = tempArray.firstObject;
                        identifier = tempArray.lastObject;
                    }
                    if (storyboardName && identifier) {
                        //获取storyboard: 通过bundle根据storyboard的名字来获取我们的storyboard,
                        UIStoryboard *story = [UIStoryboard storyboardWithName:storyboardName bundle:[NSBundle mainBundle]];
                        //由storyboard根据myView的storyBoardID来获取我们要切换的视图
                        VC = [story instantiateViewControllerWithIdentifier:identifier];
                    }else{
                        NSAssert(0, @"请设置正确的storyboard 名称以及 identifier");
                        return nil;
                    }
                }
                if (VC && [VC respondsToSelector:@selector(open:withQuery:)]){
                    [VC open:url withQuery:query];
                    return VC;
                }
            }
        }
        if(class !=nil){
            VC = [[class alloc]init];
            if([VC respondsToSelector:@selector(open:withQuery:)]){
                [VC open:url withQuery:query];
            }
        }
        // 处理网络地址的情况
        if ([url.scheme isEqualToString:[NBURLRouter sharedNBURLRouter].mHttpScheme] || [url.scheme isEqualToString:[NBURLRouter sharedNBURLRouter].mHttpsScheme]) {
            class =  NSClassFromString([configDict objectForKey:url.scheme]);
            VC.params = @{@"urlStr": [url absoluteString]};
        }
    }
    return VC;
}

/**
 *  将url的参数部分转化成字典
 *
 *  @param url 需要转化的url
 *
 *  @return 字典
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


@end
