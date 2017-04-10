//
//  NBRouterTests.m
//  NBRouterTests
//
//  Created by NapoleonBai on 16/10/16.
//  Copyright © 2016年 BaiZhiqiang. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NBRouter.h"

@interface NBRouterTests : XCTestCase

@end

@implementation NBRouterTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

- (void)testPush{
    // 这里没有通过测试是因为需要导航栏控制器,在代码中已经 设置了 NSAssert,所以没通过,可以参考界面点击
    // 代码方式
    [NBURLRouter push:^(NBURLRouteMaker * _Nonnull maker) {
        maker.intentUrlStr(@"nbrouter://storyboard").animate(YES);
    }];
    // 没有设置url
    [NBURLRouter push:^(NBURLRouteMaker * _Nonnull maker) {
        maker.intentUrlStr(@"").animate(YES);
    }];
}

- (void)testPop{
    // 直接到第一页
    [NBURLRouter pop:^(NBURLRoutePopBacker * _Nonnull backer) {
        backer.toRoot();
    }];
    // 向上退指定数量的界面
    [NBURLRouter pop:^(NBURLRoutePopBacker * _Nonnull backer) {
        backer.times(2);
    }];
    // 退到指定控制器界面(离根控制器最近的一个)
    [NBURLRouter pop:^(NBURLRoutePopBacker * _Nonnull backer) {
        backer.viewController(@"UIViewController");
    }];
}

- (void)testPresent{
    // 不存在的链接
    [NBURLRouter present:^(NBURLRouteMaker * _Nonnull maker) {
        maker.intentUrlStr(@"test://profile");
    }];
}

- (void)testDismiss{
    // 倒退指定个界面
    [NBURLRouter dismiss:^(NBURLRouteDismissBacker * _Nonnull backer) {
        backer.times(2);
    }];
    
    [NBURLRouter dismiss:nil];
}


@end
