//
//  iuiueNotFundOrderViewController.m
//  iuiue
//
//  Created by 赵中良 on 14-5-20.
//  Copyright (c) 2014年 iuiue. All rights reserved.
//

#import "iuiueNotFundOrderViewController.h"

@interface iuiueNotFundOrderViewController ()

@end

@implementation iuiueNotFundOrderViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UIBarButtonItem *item = [[UIBarButtonItem alloc]init];
        self.navigationItem.backBarButtonItem = item;
        item.title = @"返回";
        self.navigationItem.title = @"订单列表";
        // Custom initialization
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

@end
