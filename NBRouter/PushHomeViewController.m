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
    NBURLRouteMaker *maker = [NBURLRouteMaker new];
    self.label.text = @"显示返回数据";
    __weak typeof(self) weakSelf = self;
    switch (indexPath.row) {

        case 0:
           [NBURLRouter pushURLString:@"bzqnormal://nbrouter/pushsecondviewcontroller?userName=张三&pwd=123456" animated:YES];
            break;
        case 1:
            //隐藏tabbar
            self.hidesBottomBarWhenPushed = YES;
            [NBURLRouter pushURLString:@"bzqnormal://nbrouter/pushsecondviewcontroller" query:@{@"userName":@"张三",
                        @"pwd":@"123456"}
             animated:YES];
            
            self.hidesBottomBarWhenPushed = NO;
            break;
            
        case 2:
        {
            [NBURLRouter pushURLString:@"bzqnormal://nbrouter/pushsecondviewcontroller?userName=张三&pwd=123456" animated:YES callBackHandler:^(NSDictionary *dict) {
                NSLog(@"返回数据===>>>>%@ = %@",dict[@"userName"],dict[@"pwd"]);
                weakSelf.label.text = [NSString stringWithFormat:@"返回值为:\nuserName = %@, pwd = %@",dict[@"userName"],dict[@"pwd"]];
            }];
        }
            break;
        //case 3 是从xib中加载控制器, 是否传递参数以及是否需要返回值,与code方式一样,没啥不同之处
        case 3:
            [NBURLRouter pushURLString:@"bzqxib://nbrouter/xibviewcontroller?userName=xib跳转&pwd=1234565&isPush=YES" animated:YES];
            break;
        case 4:
            //唯一需要注意的是:xxx://xxx/xx   ,最后一个"/" 后面,必须按照规范给出 storyboardName.storyboardId, eg:Main.StoryboardViewController , 其他与上面一致
            [NBURLRouter pushURLString:@"bzqsb://nbrouter/Main.StoryboardViewController?userName=xib跳转&pwd=1234565&isPush=YES" animated:YES];
            break;
        case 5:
            //http 也是类似
            self.hidesBottomBarWhenPushed = YES;
            [NBURLRouter pushURLString:@"https://www.baidu.com" animated:YES];
            self.hidesBottomBarWhenPushed = NO;
            break;
        case 6:
            maker.intentUrlStr(@"bzqnormal://nbrouter/pushsecondviewcontroller?userName=张三&pwd=123456").hidesBottomBarWhenPushed(YES).animate(YES).push();
            break;
        case 7:
            maker.intentUrlStr(@"bzqnormal://nbrouter/pushsecondviewcontroller").hidesBottomBarWhenPushed(YES).animate(YES).parmas(@{@"userName":@"张三",
                                                                                                                                      @"pwd":@"123456"}).push();
            break;
            
        case 8:
        {
            maker.intentUrlStr(@"bzqnormal://nbrouter/pushsecondviewcontroller?userName=张三&pwd=123456").hidesBottomBarWhenPushed(YES).animate(YES).handler(^(NSDictionary *dict) {
                NSLog(@"返回数据===>>>>%@ = %@",dict[@"userName"],dict[@"pwd"]);
                weakSelf.label.text = [NSString stringWithFormat:@"返回值为:\nuserName = %@, pwd = %@",dict[@"userName"],dict[@"pwd"]];
            }).push();
        }
            break;
            //case 3 是从xib中加载控制器, 是否传递参数以及是否需要返回值,与code方式一样,没啥不同之处
        case 9:
            maker.intentUrlStr(@"bzqxib://nbrouter/xibviewcontroller?userName=xib跳转&pwd=1234565&isPush=YES").hidesBottomBarWhenPushed(YES).xibName(@"XibViewController").animate(YES).push();
            break;
        case 10:
            maker.intentUrlStr(@"bzqsb://nbrouter/Main.StoryboardViewController?userName=xib跳转&pwd=1234565&isPush=YES").hidesBottomBarWhenPushed(YES).storyboardName(@"Main").identifier(@"StoryboardViewController").animate(YES).push();
            break;
        case 11:
            //http 也是类似
            maker.intentUrlStr(@"https://www.baidu.com").push();

            break;

    }
}

@end
