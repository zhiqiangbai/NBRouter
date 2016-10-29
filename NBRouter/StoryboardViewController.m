//
//  StoryboardViewController.m
//  NBRouter
//
//  Created by NapoleonBai on 16/10/18.
//  Copyright © 2016年 BaiZhiqiang. All rights reserved.
//

#import "StoryboardViewController.h"
#import "NBRouterHeader.h"

@interface StoryboardViewController ()

@property(assign,nonatomic)BOOL isPush;
@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation StoryboardViewController

- (BOOL)isPush{
    return [self.params[@"isPush"] boolValue];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.label.text = [NSString stringWithFormat:@"点击屏幕,回到上一页\n\n 传递参数为:\nuserName = %@, pwd = %@",self.params[@"userName"],self.params[@"pwd"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (self.isPush) {
        [NBURLRouter popViewControllerAnimated:YES];
    }else{
        [NBURLRouter dismissViewControllerAnimated:YES completion:nil];
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
