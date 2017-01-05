//
//  ModalChildViewController.m
//  NBRouter
//
//  Created by NapoleonBai on 16/10/18.
//  Copyright © 2016年 BaiZhiqiang. All rights reserved.
//

#import "ModalChildViewController.h"
#import "NBRouter.h"

@interface ModalChildViewController ()

@end

@implementation ModalChildViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    [self.view addSubview:label];
    
    
    label.text = [NSString stringWithFormat:@"点击屏幕,回到上一页\n\n 传递参数为:\nuserName = %@, pwd = %@",self.params[@"userName"],self.params[@"pwd"]];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"back" style:UIBarButtonItemStylePlain target:self action:@selector(dismiss)]];
    self.navigationItem.hidesBackButton = YES;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self dismiss];
}


- (void)dismiss{
    //这里根据自身情况是放在外面还是block里面
    if (self.callBackHandler) {
        self.callBackHandler(@{@"userName":@"李四",@"pwd":@"qwertasdf"});
    }
    [NBURLRouter dismissViewControllerAnimated:YES completion:^{
    }];
}/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
