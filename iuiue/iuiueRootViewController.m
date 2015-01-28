//
//  iuiueRootViewController.m
//  iuiue
//
//  Created by mizilang on 14-5-8.
//  Copyright (c) 2014年 iuiue. All rights reserved.
//

#import "iuiueRootViewController.h"
#import "iuiueOrderViewController.h"
#import "iuiueOrderTableViewController.h"
#import "iuiueGetcashiViewController.h"
#import "iuiueMoreViewController.h"
#import "iuiueRoomSelectViewController.h"
#import "iuiueAddOrderTableViewController.h"
#import "iuiueBegForRentViewController.h"


#import "iuiueChatListViewController.h"//聊天控制器


@interface iuiueRootViewController ()<TransmitProtocol>
{
    UIWebView *phoneCallWebView;
     NSURL* url;
}

@end

@implementation iuiueRootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.title = @"木鸟房东助手";
        self.navigationItem.hidesBackButton = YES;
        UIBarButtonItem *item = [[UIBarButtonItem alloc]init];
//        [[UINavigationBar appearance] setBarTintColor:[UIColor orangeColor]];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        self.navigationItem.backBarButtonItem = item;
        item.title = @"返回";
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"聊天" style:UIBarButtonItemStyleBordered target:self action:@selector(TurnToChatList:)];
        
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
       
    //米黄色
    self.view.backgroundColor = [UIColor colorWithRed:250.0/255.0 green:240.0/255.0 blue:230.0/255.0 alpha:1];
    [self Update1];//检查更新
//    [self getarr1];//判断uid zend 超时
    float hight,width;
    float scale = [UIScreen mainScreen].bounds.size.height;
    float scale1 = [UIScreen mainScreen].bounds.size.width;
    hight = (scale-64) / (568 -64);
    width = scale1/320;
    NSLog(@"%f",scale);
    UIView *myview = [[UIView alloc]initWithFrame:CGRectMake(0, 64, 320 * width, scale - 64)];
    
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"woodbird"]];
       [imageView setFrame:CGRectMake(40* width, 30, 240*width, 140*hight)];
//     [imageView setFrame:CGRectMake(0, 0, 320, 182*f)];
    
    
    
    //
        UIButton *btn1 = [[UIButton alloc]init];
        [btn1 setTag:1];
        [btn1 setFrame:CGRectMake(5, 187*hight, 170, 180*hight)];
        
        [btn1 addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *btn2 = [[UIButton alloc]init];
        [btn2 setTag:2];
        [btn2 setFrame:CGRectMake(180 * width, 187 * hight, 135 * width, 115 * hight)];
        
        [btn2 addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *btn3 = [[UIButton alloc]init];
        [btn3 setTag:3];
        [btn3 setFrame:CGRectMake(180 * width,307*hight, 135 * width, 115*hight)];
        
        [btn3 addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *btn4 = [[UIButton alloc]init];
        [btn4 setTag:4];
        [btn4 setFrame:CGRectMake(5 * width, 372*hight, 170 * width, 125*hight)];
        
        [btn4 addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *leftButton = [[UIButton alloc]initWithFrame:CGRectMake(btn4.left, btn4.top, (btn4.width-5)/2, btn4.height)];
    [leftButton setTitle:@"增加销量" forState:UIControlStateNormal];
    leftButton.backgroundColor = [UIColor blueColor];
    [leftButton setTag:7];
    [leftButton addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [myview addSubview:leftButton];
    
    UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(leftButton.right + 5, leftButton.top, leftButton.width, leftButton.height)];
    [rightButton setTitle:@"抢生意" forState:UIControlStateNormal];
    rightButton.backgroundColor = [UIColor orangeColor];
    [rightButton setTag:8];
    [rightButton addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [myview addSubview:rightButton];
    
    
    UIButton *btn5 = [[UIButton alloc]init];
    [btn5 setTag:5];
    [btn5 setFrame:CGRectMake(180 * width, 427*hight, 65 *width, 70*hight)];
    
    [btn5 addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btn6 = [[UIButton alloc]init];
    [btn6 setTag:6];
    [btn6 setFrame:CGRectMake(250*width,427*hight, 65 * width, 70*hight)];
    
    [btn6 addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [btn5 setImage:[UIImage imageNamed:@"more"] forState:UIControlStateNormal];
    [btn6 setImage:[UIImage imageNamed:@"service"] forState:UIControlStateNormal];
    
    if ([UIScreen mainScreen].bounds.size.height == 568) {
        [btn1 setImage:[UIImage imageNamed:@"ordermanage"] forState:UIControlStateNormal];
        [btn2 setImage:[UIImage imageNamed:@"btn_paiqi1"] forState:UIControlStateNormal];
        [btn3 setImage:[UIImage imageNamed:@"btn_jiage1"] forState:UIControlStateNormal];
        [btn4 setImage:[UIImage imageNamed:@"getcash"] forState:UIControlStateNormal];
        [leftButton setImage:[UIImage imageNamed:@"btn_glroom_in_L"] forState:UIControlStateNormal];
        [rightButton setImage:[UIImage imageNamed:@"btn_qiuzu_in_L"] forState:UIControlStateNormal];

    }
    else{
        [imageView setImage:[UIImage imageNamed:@"woodbird"]];
        [btn1 setImage:[UIImage imageNamed:@"btn_dingdan_in"] forState:UIControlStateNormal];
        [btn2 setImage:[UIImage imageNamed:@"btn_fangtai"] forState:UIControlStateNormal];
        [btn3 setImage:[UIImage imageNamed:@"btn_jiage"] forState:UIControlStateNormal];
        [btn4 setImage:[UIImage imageNamed:@"btn_tixian_in"] forState:UIControlStateNormal];
        [leftButton setImage:[UIImage imageNamed:@"btn_glroom_in"] forState:UIControlStateNormal];
        [rightButton setImage:[UIImage imageNamed:@"btn_qiuzu_in"] forState:UIControlStateNormal];

    }
    NSLog(@"%f",btn6.frame.origin.y+btn6.frame.size.height);
    NSLog(@"%f",myview.frame.origin.y + myview.frame.size.height);
    [self.view addSubview:myview];
    [myview addSubview:btn1];
    [myview addSubview:imageView];
    [myview addSubview:btn2];
    [myview addSubview:btn3];
//    [myview addSubview:btn4];
    [myview addSubview:btn5];
    [myview addSubview:btn6];
    
    
    NSLog(@"btn1:%f||btn2:%f||btn3:%f||btn4:%f||btn5:%f||btn6:%f",btn1.frame.size.height,btn2.frame.size.height,btn3.frame.size.height,btn4.frame.size.height,btn5.frame.size.height,btn6.frame.size.height);
    

    // Do any additional setup after loading the view from its nib.
    
    
}


//判断登陆超时
-(BOOL)getarr1{
    
    __weak ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:URL_NEW_ORDER]];
    request.requestMethod = @"POST";
    [request addPostValue:MY_UID forKey:@"uid"];
    [request addPostValue:MY_ZEND forKey:@"zend"];
    
    [request setCompletionBlock:^{
        NSLog(@"%@",request.responseString);
        NSError *error;
        NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingAllowFragments error:&error];
        if (!error) {
            switch ([resultDict[@"status"] integerValue]) {
                case 0:
                    NSLog(@"%d",[resultDict[@"status"] integerValue]);
                    break;
                case 90:{
                    [iuiueCHKeychain delete:KEYCHAIN_USERNAMEPASSWORD];
                    [[NSNotificationCenter defaultCenter]postNotificationName:NO_APNS_JB object:nil];
                    [self dismissViewControllerAnimated:YES completion:nil];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [[UIApplication sharedApplication].keyWindow makeToast:@"距上次登录时间过长，请重新登录！"];
                    });
                }
                    break;
                default:{
                    [[UIApplication sharedApplication].keyWindow makeToast:@"订单总列表信息错误"];
                }
                    break;
            }
        }else{
            NSLog(@"%@",[error localizedDescription]);
        }
    }];
    
    [request setFailedBlock:^{
        NSLog(@"%@",[request.error localizedDescription]);
    
        
    }];
    //    hud.detailsLabelText = @"正在登录，请稍后....";
    [request startSynchronous];
    
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickBtn:(id)sender {
    UIButton * btn;
    btn = (UIButton *)sender;
    
    iuiueAllService *service = [[iuiueAllService alloc]init];
    if (![service isConnectionAvailable]) {
        [[UIApplication sharedApplication].keyWindow makeToast:@"当前网络不可用，请检查网络连接"];
        return;
    }
    switch (btn.tag) {
        case 1:{
            iuiueOrderViewController *ordervc = [[iuiueOrderViewController alloc]initWithNibName:@"iuiueOrderViewController" bundle:nil];
//            [self.navigationController pushViewController:ordervc animated:YES];
            //翻转效果
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:ordervc];
            nav.navigationBar.barTintColor = [UIColor whiteColor];
            [self.navigationController flipToViewController:nav fromView:sender withCompletion:nil];
//            [self.navigationController flipToViewController:nav fromView:sender asChildWithSize:CGSizeMake(200, 300) withCompletion:nil];
        }
            break;
        case 2:{
            //房态修改
            iuiueRoomSelectViewController *roomvc = [[iuiueRoomSelectViewController alloc]init];
            roomvc.title = @"我的房间";
//            [self.navigationController pushViewController:roomvc animated:YES];
            //翻转效果
             UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:roomvc];
            nav.navigationBar.barTintColor = [UIColor whiteColor];
            roomvc.delegate = self;
            [self flipToViewController:nav fromView:sender withCompletion:nil];
        }
            break;

        case 3:{
            //价格修改
            iuiueOrderTableViewController *roomvc = [[iuiueOrderTableViewController alloc]init];
            roomvc.title = @"我的房间";
            roomvc.number = 9;
//            [self.navigationController pushViewController:roomvc animated:YES];
             UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:roomvc];
            nav.navigationBar.barTintColor = [UIColor whiteColor];
            [self flipToViewController:nav fromView:sender withCompletion:nil];
            
//            iuiueMassageViewController *massagevc = [[iuiueMassageViewController alloc]initWithNibName:@"iuiueMassageViewController" bundle:nil];
//            [self.navigationController pushViewController:massagevc animated:YES];
        }
            break;

        case 4:{
            iuiueGetcashiViewController *getcashvc = [[iuiueGetcashiViewController alloc]init];
            
//            [self.navigationController pushViewController:getcashvc animated:YES];
            
             UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:getcashvc];
            nav.navigationBar.barTintColor = [UIColor whiteColor];
            [self flipToViewController:nav fromView:sender withCompletion:nil];
//            iuiueAddOrderTableViewController *getcashvc = [[iuiueAddOrderTableViewController alloc]init];
//            
//            //            [self.navigationController pushViewController:getcashvc animated:YES];
//            
//            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:getcashvc];
//            [self flipToViewController:nav fromView:sender withCompletion:nil];

        }
            break;

        case 5:{
            iuiueMoreViewController *morevc = [[iuiueMoreViewController alloc]initWithNibName:@"iuiueMoreViewController" bundle:nil];
            [self.navigationController pushViewController:morevc animated:YES];
        }
            break;

        case 6:{
            //播电话
            NSString *phoneNum = @"400-056-0055";// 电话号码
            NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",phoneNum]];
            if ( !phoneCallWebView ) {
                phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];// 这个webView只是一个后台的View 不需要add到页面上来  效果跟方法二一样 但是这个方法是合法的
            }
            [phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
        }
            break;
        case 7:{
            //增加销量
            iuiueAddOrderTableViewController *roomvc = [[iuiueAddOrderTableViewController alloc]init];
            //            [self.navigationController pushViewController:roomvc animated:YES];
            //翻转效果
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:roomvc];
            nav.navigationBar.barTintColor = [UIColor whiteColor];
            [self flipToViewController:nav fromView:sender withCompletion:nil];
        }
            break;
        case 8:{
            //求租
            iuiueBegForRentViewController *roomvc = [[iuiueBegForRentViewController alloc]init];
            //            [self.navigationController pushViewController:roomvc animated:YES];
            //翻转效果
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:roomvc];
            nav.navigationBar.barTintColor = [UIColor whiteColor];
            [self flipToViewController:nav fromView:sender withCompletion:nil];
        }
            break;

            
        default:
            break;
    }
}
-(void)Transmit:(NSString *)string{
    [[UIApplication sharedApplication].keyWindow makeToast:string];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //修改成异步
//    [self Update1];
    [self getarr1];
    
}

-(void)Update:(float)NewVersion{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // 当前应用名称
    NSString *appCurName = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    NSLog(@"当前应用名称：%@",appCurName);
    // 当前应用软件版本  比如：1.0.1
    NSString *appCurVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSLog(@"当前应用软件版本:%@",appCurVersion);
    // 当前应用版本号码   int类型
    NSString *appCurVersionNum = [infoDictionary objectForKey:@"CFBundleVersion"];
    NSLog(@"当前应用版本号码：%@",appCurVersionNum);
    
    if (NewVersion <= [appCurVersion floatValue]) {
//            [[UIApplication sharedApplication].keyWindow makeToast:@"已是最新版本！"];
        }
        else{
            url =[NSURL URLWithString:URL_UPDATE];
            NSLog(@"url");
            [self showView];
            
        }
}

-(void)showView{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"检测到新版本，是否立即升级？" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:@"取消", nil];
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        [[UIApplication sharedApplication]openURL:url];
    }
    else{
        
    }
}

//
-(void)Update1{
    __weak ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:URL_APPSTORE_VERSION]];
    
    [request setCompletionBlock:^{
        NSLog(@"%@",request.responseString);
        NSError *error;
        NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingAllowFragments error:&error];
        if (!error) {
                NSLog(@"%@",resultDict[@"results"]);
                NSArray *arr = resultDict[@"results"];
                NSDictionary *dic = arr.lastObject;
               
                NSString *NewVersion = dic[@"version"];
                NSLog(@"dic：%@",NewVersion);
            [self Update:[NewVersion floatValue]];
        }
    }
     ];
    [request setFailedBlock:^{
        
        [[UIApplication sharedApplication].keyWindow makeToast:@"网络连接失败，请检查网络设置"];
    }];
    [request startAsynchronous];
    
}

//添加清理缓存，有问题
/*
-(void)qinglihuancun{
    dispatch_async(
                   dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
                   , ^{
                       NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
 
                       NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
                       NSLog(@"files :%d",[files count]);
                       for (NSString *p in files) {
                           NSError *error;
                           NSString *path = [cachPath stringByAppendingPathComponent:p];
                           if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                               [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
                           }
                       }
                       [self performSelectorOnMainThread:@selector(clearCacheSuccess) withObject:nil waitUntilDone:YES];});
    
  }
-(void)clearCacheSuccess
{
    NSLog(@"清理成功");
}
*/


//跳转到好友列表页面
-(IBAction)TurnToChatList:(id)sender{
    iuiueChatListViewController *ChatList = [[iuiueChatListViewController alloc]init];
    ChatList.title = @"好友列表";
    [self.navigationController pushViewController:ChatList animated:YES];
}

@end
