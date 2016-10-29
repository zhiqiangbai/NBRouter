//
//  ModalHomeViewController.h
//  NBRouter
//
//  Created by NapoleonBai on 16/10/18.
//  Copyright © 2016年 BaiZhiqiang. All rights reserved.
//

#import "ModalHomeViewController.h"
#import "NBURLRouter.h"

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
    //MODAL 跳转方式,从code ,从xib , 从 storyboard 中加载都是一样的,区别不同就是要定义好自己的协议即可,按照规范书写就好了
    self.label.text = @"显示返回数据";
    __weak typeof(self) weakSelf = self;
    switch (indexPath.row) {
        case 0:
            [NBURLRouter presentURLString:@"bzqnormal://nbrouter/modalchildviewcontroller?userName=张三&pwd=123456" animated:YES completion:nil];
            break;
        case 1:
            
            [NBURLRouter presentURLString:@"bzqnormal://nbrouter/modalchildviewcontroller" query:@{@"userName":@"张三",@"pwd":@"123456"} animated:YES completion:nil];
            break;
            
        case 2:
        {
            [NBURLRouter presentURLString:@"bzqnormal://nbrouter/modalchildviewcontroller?userName=张三&pwd=123456" animated:YES completion:nil callBackHandler:^(NSDictionary *dict) {
                NSLog(@"返回数据===>>>>%@ = %@",dict[@"userName"],dict[@"pwd"]);
                weakSelf.label.text = [NSString stringWithFormat:@"返回值为:\nuserName = %@, pwd = %@",dict[@"userName"],dict[@"pwd"]];
            }];
        }
            break;
        case 3:
            //UINavigationController 是系统的导航栏控制器,如果自己定义,也是可以的,只要继承自UINavigationController就可
            [NBURLRouter presentURLString:@"bzqnormal://nbrouter/modalchildviewcontroller?userName=张三&pwd=123456" animated:YES withNavigationClass:[UINavigationController class] completion:nil];
            break;
    }
}

@end
