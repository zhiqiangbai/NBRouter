//
//  PushSecondViewController.m
//  NBRouter
//
//  Created by NapoleonBai on 16/10/16.
//  Copyright © 2016年 BaiZhiqiang. All rights reserved.
//

#import "PushSecondViewController.h"

#import "NBURLRouter.h"

@interface PushSecondViewController ()

@end

@implementation PushSecondViewController

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
    
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"back" style:UIBarButtonItemStylePlain target:self action:@selector(pop)]];
    self.navigationItem.hidesBackButton = YES;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self pop];
}


- (void)pop{
    if (self.callBackHandler) {
        self.callBackHandler(@{@"userName":@"李四",@"pwd":@"qwertasdf"});
    }
    [NBURLRouter popViewControllerAnimated:YES];
}

@end
