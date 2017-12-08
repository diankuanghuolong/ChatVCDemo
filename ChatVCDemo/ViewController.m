//
//  ViewController.m
//  ChatVCDemo
//
//  Created by Ios_Developer on 2017/12/8.
//  Copyright © 2017年 hai. All rights reserved.
//

#import "ViewController.h"

#import "MessageVC.h"
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *gotoChatVCBtn = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 100)/2, 100, 100, 30)];
    gotoChatVCBtn.backgroundColor = [UIColor greenColor];
    [gotoChatVCBtn setTitle:@"进入消息页面" forState:UIControlStateNormal];
    [gotoChatVCBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    gotoChatVCBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    gotoChatVCBtn.layer.cornerRadius = 10;
    gotoChatVCBtn.layer.masksToBounds = YES;
    [gotoChatVCBtn addTarget:self action:@selector(gotoChatVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:gotoChatVCBtn];
}

#pragma mark  ===== action  =====
-(void)gotoChatVC:(id)sender
{
    MessageVC *messageVC = [MessageVC new];
    [self.navigationController pushViewController:messageVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
