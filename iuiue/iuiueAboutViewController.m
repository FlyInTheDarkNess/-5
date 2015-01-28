//
//  iuiueAboutViewController.m
//  iuiue
//
//  Created by 赵中良 on 14-5-27.
//  Copyright (c) 2014年 iuiue. All rights reserved.
//

#import "iuiueAboutViewController.h"

@interface iuiueAboutViewController (){
    UIWebView *phoneCallWebView;
}

@end

@implementation iuiueAboutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationItem.title =@"关于";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)call:(id)sender {
    UIButton *btn = (UIButton *)sender;
    
    NSString *phoneNum = btn.titleLabel.text;// 电话号码
    NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",phoneNum]];
    if ( !phoneCallWebView ) {
        phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];// 这个webView只是一个后台的View 不需要add到页面上来  
    }
    [phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
}
@end
