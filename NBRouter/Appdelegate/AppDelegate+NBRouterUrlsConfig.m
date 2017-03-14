//
//  AppDelegate+NBRouterUrlsConfig.m
//  NBRouter
//
//  Created by NapoleonBai on 2017/3/14.
//  Copyright © 2017年 BaiZhiqiang. All rights reserved.
//

#import "AppDelegate+NBRouterUrlsConfig.h"
#import "NBRouter.h"

@implementation AppDelegate (NBRouterUrlsConfig)

- (void)setupRouter{
//    [NBURLRouter setUrlsConfigDict:[self loadUrlsFromPlist]];
    [NBURLRouter setUrlsConfigDict:[self loadUrls]];

}

- (NSDictionary *)loadUrlsFromPlist{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"NBRouter" ofType:@"plist"];
    NSDictionary *configDict = [NSDictionary dictionaryWithContentsOfFile:path];
    return configDict;
}

- (NSDictionary *)loadUrls{
    return @{
             @"http":@"NBWebViewController",
             @"https":@"NBWebViewController",
             @"nbrouter":@{
                         @"nbrouter://home":@"UITabbarController",
                         @"nbrouter://storyboard":@"StoryboardViewController",
                         @"nbrouter://modalchild":@"ModalChildViewController",
                         @"nbrouter://pushsecond":@"PushSecondViewController"
                     },
             @"xibviewcontroller":@"XibViewController"
             };
}

@end
