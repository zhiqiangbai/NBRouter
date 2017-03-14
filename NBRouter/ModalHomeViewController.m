//
//  ModalHomeViewController.h
//  NBRouter
//
//  Created by NapoleonBai on 16/10/18.
//  Copyright © 2016年 BaiZhiqiang. All rights reserved.
//

#import "ModalHomeViewController.h"
#import "NBRouter.h"

@interface ModalHomeViewController ()

@property(weak,nonatomic)UILabel *label;

@end

@implementation ModalHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.label = [self.view viewWithTag:10];

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
            // 普通的代码创建控制器跳转  <从 xib / storyboard 中加载都与push类似>
            [NBURLRouter present:^(NBURLRouteMaker * _Nonnull maker) {
                maker.intentUrlStr(@"nbrouter://modalchild?userName=张三&pwd=123456&index=1").navigationClass([UINavigationController class]).animate(YES);
            }];
            break;
        case 1:
            // 字典传递参数
            [NBURLRouter present:^(NBURLRouteMaker * _Nonnull maker) {
                maker.intentUrlStr(@"nbrouter://modalchild").navigationClass([UINavigationController class]).parmas(@{@"userName":@"张三",
                                                                                    @"pwd":@"123456",
                                                                                    @"index":@1}).animate(YES);;
            }];
            break;
            
        case 2:
        {
            // 接收返回值
            [NBURLRouter present:^(NBURLRouteMaker * _Nonnull maker) {
                maker.intentUrlStr(@"nbrouter://modalchild").navigationClass([UINavigationController class]).parmas(@{@"userName":@"张三",
                                                                                    @"pwd":@"123456",
                                                                                    @"index":@1}).animate(YES).handler(^(NSDictionary *dict) {
                    NSLog(@"返回数据===>>>>%@ = %@",dict[@"userName"],dict[@"pwd"]);
                    self.label.text = [NSString stringWithFormat:@"返回值为:\nuserName = %@, pwd = %@",dict[@"userName"],dict[@"pwd"]];
                });
            }];
        }
            break;
        case 3:
            //UINavigationController 是系统的导航栏控制器,如果自己定义,也是可以的,只要继承自UINavigationController就可
            [NBURLRouter present:^(NBURLRouteMaker * _Nonnull maker) {
                maker.intentUrlStr(@"nbrouter://modalchild").navigationClass([UINavigationController class]).parmas(@{@"userName":@"张三",
                                                                                                                                    @"pwd":@"123456",
                                                                                                                                    @"index":@1}).animate(YES);;
            }];
            break;
        case 4:
            // 网页链接跳转
            [NBURLRouter present:^(NBURLRouteMaker * _Nonnull maker) {
                maker.intentUrlStr(@"http://www.baidu.com");
            }];
            break;
    }
}

@end
