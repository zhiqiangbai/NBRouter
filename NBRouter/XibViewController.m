//
//  XibViewController.m
//  NBRouter
//
//  Created by NapoleonBai on 16/10/18.
//  Copyright © 2016年 BaiZhiqiang. All rights reserved.
//

#import "XibViewController.h"

#import "NBRouter.h"

#import "objc/runtime.h"

@interface XibViewController ()
@property (weak, nonatomic) IBOutlet UILabel *desLabel;

@property(assign,nonatomic)BOOL isPush;

@end

@implementation XibViewController

- (BOOL)isPush{
    return [self.params[@"isPush"] boolValue];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //如果需要监听系统自带返回按钮,自行设置即可
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    self.desLabel.text = [NSString stringWithFormat:@"点击屏幕,回到上一页\n\n 传递参数为:\nuserName = %@, pwd = %@",self.params[@"userName"],self.params[@"pwd"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (self.isPush) {
        [NBURLRouter pop:^(NBURLRoutePopBacker * _Nonnull backer) {
        }];
    }else{
        [NBURLRouter dismiss:^(NBURLRouteDismissBacker * _Nonnull backer) {
            
        }];
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
