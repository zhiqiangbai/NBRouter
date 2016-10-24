//
//  ViewController.m
//  NBRouter
//
//  Created by NapoleonBai on 16/10/16.
//  Copyright © 2016年 BaiZhiqiang. All rights reserved.
//

#import "ViewController.h"

#import "NBURLRouter.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        ViewController *vc = [ViewController new];
//        [self.navigationController pushViewController:vc animated:YES];
//    });
//    
}
- (IBAction)onClick:(id)sender {
    [NBURLRouter pushURLString:@"bzqnormal://firstvc?id=2332&name=张三" animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
