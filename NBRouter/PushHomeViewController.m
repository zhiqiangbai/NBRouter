//
//  PushHomeViewController.m
//  NBRouter
//
//  Created by NapoleonBai on 16/10/18.
//  Copyright © 2016年 BaiZhiqiang. All rights reserved.
//

#import "PushHomeViewController.h"
#import "NBURLRouter.h"
#import "AppDelegate.h"
#import "NBURLRouteMaker.h"

@interface PushHomeViewController ()
@property(weak,nonatomic)UILabel *label;

@end

@implementation PushHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.label = [self.view viewWithTag:10];
    

    
//    [NBURLRouter pushString:@"这是一个测试" maker:^(NBURLConfigMaker * maker) {
//        maker.storyboardName(@"storyboardName").identifier(@"identifier name ???").xibName(@"这是啥????");
//    }];
//    
 //   NBURLRouteMaker *route = [NBURLRouteMaker new];
 //   route.storyboardName(@"测试storyboardName").identifier(@"测试identifier").xibName(@"测试 xibName").push();

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.label.text = @"显示返回数据";
    switch (indexPath.row) {

        case 0:
            // 普通的代码创建控制器跳转
            [NBURLRouter push:^(NBURLRouteMaker * _Nonnull maker) {
                maker.intentUrlStr(@"nbrouter://pushsecond?userName=张三&pwd=123456&index=1").animate(YES);
            }];
            break;
        case 1:
            // 采用对象传参, 当然默认是隐藏了底部控制栏的,如果不想隐藏,设为NO即可
            [NBURLRouter push:^(NBURLRouteMaker * _Nonnull maker) {
                maker.intentUrlStr(@"nbrouter://pushsecond").hidesBottomBarWhenPushed(NO).parmas(@{@"userName":@"张三",
                                                                                                                 @"pwd":@"123456",
                                                                                                                 @"index":@1}).animate(YES);
            }];
            break;
            
        case 2:
        {
            // 接收返回值,并不一定就是 NSdictionary类型,这个根据目标控制器返回时的参数类型确定
            [NBURLRouter push:^(NBURLRouteMaker * _Nonnull maker) {
                maker.intentUrlStr(@"nbrouter://pushsecond?userName=张三&pwd=123456&index=1").animate(YES).handler(^(NSDictionary *dict) {
                    NSLog(@"返回数据===>>>>%@ = %@",dict[@"userName"],dict[@"pwd"]);
                    self.label.text = [NSString stringWithFormat:@"返回值为:\nuserName = %@, pwd = %@",dict[@"userName"],dict[@"pwd"]];
                });
            }];
        }
            break;
        case 3:
            // 从xib中加载,唯一与code方式不同的是需要传入一个xibName,当然这里采用的协议是  other
            [NBURLRouter push:^(NBURLRouteMaker * _Nonnull maker) {
                maker.intentUrlStr(@"xibviewcontroller?userName=xib跳转&pwd=1234565&isPush=YES").hidesBottomBarWhenPushed(YES).xibName(@"XibViewController").animate(YES);
            }];
            break;
        case 4:
            // 从storyboard中加载控制器,需要指定 storyboardName 以及 identifier
            [NBURLRouter push:^(NBURLRouteMaker * _Nonnull maker) {
                maker.intentUrlStr(@"nbrouter://storyboard?userName=张三&pwd=123456&index=1&isPush=YES").animate(YES).storyboardName(@"Main").identifier(@"StoryboardViewController");
            }];

            break;
        case 5:
            // 网页链接跳转
            [NBURLRouter push:^(NBURLRouteMaker * _Nonnull maker) {
                maker.intentUrlStr(@"https://www.baidu.com");
            }];
            break;
        case 6:
            // 错误设置 1:设置错误的链接
            [NBURLRouter push:^(NBURLRouteMaker * _Nonnull maker) {
                maker.intentUrlStr(@"未定义URL");
            }];
            break;
        case 7:
            // 错误设置 2:设置空的字符串链接 (跟去掉maker.intentUrlStr(@"").animate(YES);效果一致)
            [NBURLRouter push:^(NBURLRouteMaker * _Nonnull maker) {
                maker.intentUrlStr(@"").animate(YES);
            }];
            break;
        case 8:
            //错误设置 3:从storyboard中加载,并未设置storyboard name , 如果不设置storyboard name ,也就是说不调用 storyboardName这个属性,会创建一个另外的普通控制器,因为加载不了storyboard 中的这个控制器, storyboardName 及 identifier 必须同时设置,方可加载成功
            [NBURLRouter push:^(NBURLRouteMaker * _Nonnull maker) {
                maker.intentUrlStr(@"nbrouter://storyboard?userName=张三&pwd=123456").animate(YES).storyboardName(@"").identifier(@"");
            }];

            break;
        case 9:
            //错误设置 4: 从Xib中加载,不设置XibName
            [NBURLRouter push:^(NBURLRouteMaker * _Nonnull maker) {
                maker.intentUrlStr(@"xibviewcontroller?userName=xib跳转&pwd=1234565&isPush=YES").hidesBottomBarWhenPushed(YES).xibName(@"").animate(YES);
            }];
            break;
    }
}

@end
