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

@property(nonatomic,assign)NSInteger index;

@end

@implementation ModalChildViewController


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

- (NSString *)nb_viewControllerLink{
    return @"这是很厉害的协议方法 ";
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
    // 接收返回值
    [NBURLRouter present:^(NBURLRouteMaker * _Nonnull maker) {
        maker.intentUrlStr(@"nbrouter://modalchild").navigationClass([UINavigationController class]).parmas(@{@"userName":@"张三",
                                                                            @"pwd":@"123456",
                                                                            @"index":@(self.index+1)}).animate(YES).handler(^(NSDictionary *dict) {
            printf("返回数据===>>>>%s = %s",[dict[@"userName"] UTF8String],[dict[@"pwd"] UTF8String]);
            
        });
    }];
}


- (void)dismiss{
    //这里根据自身情况是放在外面还是block里面
    if (self.callBackHandler) {
        self.callBackHandler(@{@"userName":@"李四",@"pwd":@"qwertasdf"});
    }
    
    [NBURLRouter dismiss:^(NBURLRouteDismissBacker * _Nonnull backer) {
        
        if (self.index % 6 == 0) {
            // 回退到根界面
            backer.toRoot();
        }else{
            // 这里是测试回退到某个界面
            NSUInteger times = arc4random()%self.index;
            backer.times( times == 0 ? 1 : times);
        }
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
