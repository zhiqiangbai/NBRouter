//
//  PushSecondViewController.m
//  NBRouter
//
//  Created by NapoleonBai on 16/10/16.
//  Copyright © 2016年 BaiZhiqiang. All rights reserved.
//

#import "PushSecondViewController.h"

#import "NBRouter.h"

@interface PushSecondViewController ()

@property(nonatomic,assign)NSInteger index;


@end

@implementation PushSecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    [self.view addSubview:label];
    
    self.index = [self.params[@"index"] integerValue];

    label.text = [NSString stringWithFormat:@"点击屏幕,前往下一页\n\n 传递参数为:\nuserName = %@, pwd = %@ \n 第 %ld 页",self.params[@"userName"],self.params[@"pwd"],self.index];
    
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
    // 采用对象传参, 当然默认是隐藏了底部控制栏的,如果不想隐藏,设为NO即可
    [NBURLRouter push:^(NBURLRouteMaker * _Nonnull maker) {
        maker.intentUrlStr(@"nbrouter://pushsecond").parmas(@{@"userName":@"张三",
                                                                                                         @"pwd":@"123456",
                                                                                                         @"index":@(self.index+1)}).animate(YES);
    }];
}


- (void)pop{
    if (self.callBackHandler) {
        self.callBackHandler(@{@"userName":@"李四",@"pwd":@"qwertasdf"});
    }
    [NBURLRouter pop:^(NBURLRoutePopBacker * backer) {
        if (self.index % 4 == 0) {
            // 回退到根界面
            backer.toRoot();
        }else if(self.index %3 == 0){
            backer.viewController(@"PushSecondViewController");
        }else{
            // 这里是测试回退到某个界面
            NSUInteger times = arc4random()%self.index;
            backer.times( times == 0 ? 1 : times);
        }

    }];
}

@end
