//
//  iuiueMoreViewController.m
//  iuiue
//
//  Created by mizilang on 14-5-9.
//  Copyright (c) 2014年 iuiue. All rights reserved.
//

#import "iuiueMoreViewController.h"
#import "iuiueWayForCashViewController.h"
#import "iuiueAboutViewController.h"
#import "iuiueFeedBackViewController.h"
#import "iuiueMyEarningsViewController.h"
#import "iuiueMyAppRaiseViewController.h"
#import "iuiueGetcashiViewController.h"

#import "iuiueSoundSetViewController.h"//声音设置

@interface iuiueMoreViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIAlertViewDelegate>
{
    UITableView *MytableView;
    NSArray *array;
    NSURL* url;
}

@end

@implementation iuiueMoreViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.title = @"设置";
        UIBarButtonItem *item = [[UIBarButtonItem alloc]init];
        self.navigationItem.backBarButtonItem = item;
        item.title = @"返回";
        
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receiveNotification:) name:@"notification" object:nil];
//    self.hidesBottomBarWhenPushed = YES;
    MytableView = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
    MytableView.dataSource = self;
    MytableView.delegate = self;
    MytableView.bounces = NO;//设置tableview不可移动
    array = [NSArray array];
    array = @[@"消息提醒",@"提取现金",@"检查更新",@"用户反馈",@"关于"];
    [self.view addSubview:MytableView];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    else{
        return array.count;//根据当前array的count来加载cell的数量
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseidentifier = @"reuseidentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseidentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseidentifier];
    }
    if (indexPath.section == 0) {
        //button 注销
//        UIButton *logoutbtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 30)];
//        [logoutbtn setTitle:@"注销" forState:UIControlStateNormal];
//        cell.accessoryView = logoutbtn;
//        [logoutbtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//        [logoutbtn addTarget:self action:@selector(logOut:) forControlEvents:UIControlEventTouchUpInside];
        
        //label 注销
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 30)];
        label.textColor = [UIColor grayColor];
        label.text = @"注销";
        cell.accessoryView = label;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSMutableDictionary *usernamepasswordKVPairs = (NSMutableDictionary *)[iuiueCHKeychain load:KEYCHAIN_USERNAMEPASSWORD];
        NSString *username = [NSString stringWithFormat:@"%@",[usernamepasswordKVPairs objectForKey:KEYCHAIN_OWNERNAME]];
//        NSLog(@"username:%@",username);
        //头像设置
        [cell.imageView setImage:[UIImage imageNamed:@"touxiang"]];
        cell.textLabel.text = username;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        switch (indexPath.row) {
               
            case 0:
                [cell.imageView setImage:[UIImage imageNamed:@"sound"]];
                break;

            case 1:
               [cell.imageView setImage:[UIImage imageNamed:@"shouyi"]];
                break;
            case 2:
                [cell.imageView setImage:[UIImage imageNamed:@"btn_update"]];
                break;
            case 3:
                [cell.imageView setImage:[UIImage imageNamed:@"btn_feedback"]];
                break;
            case 4:
                [cell.imageView setImage:[UIImage imageNamed:@"btn_about"]];
                break;
            


                
            default:
                break;
        }
    NSString *string = array[indexPath.row];
    cell.textLabel.text = string;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath: [tableView indexPathForSelectedRow] animated:YES];//点击后恢复白色
    if (indexPath.section == 0) {
        [self logOut];
    }
    else{
        switch (indexPath.row) {
            case 0:{
                iuiueSoundSetViewController *sound = [[iuiueSoundSetViewController alloc]init];
                sound.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:sound animated:YES];
            }
                break;
            case 1:{
                iuiueGetcashiViewController *GetCash = [[iuiueGetcashiViewController alloc]init];
                GetCash.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:GetCash animated:YES];
            }
                break;
            case 2:{
                [self Update1];
                }
                break;
            case 3:{
                iuiueFeedBackViewController *feedBackVC = [[iuiueFeedBackViewController alloc]initWithNibName:@"iuiueFeedBackViewController" bundle:nil];
                feedBackVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:feedBackVC animated:YES];
            }
                break;
            case 4:{
                iuiueAboutViewController *aboutVC = [[iuiueAboutViewController alloc]initWithNibName:@"iuiueAboutViewController" bundle:nil];
                aboutVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:aboutVC animated:YES];
            }
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

            default:
                NSLog(@"点击出现错误cell");
                break;
        }
    }
}

//注销登录，点击出现Actionsheet
-(IBAction)logOut{
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"是否进行以下操作"
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:@"注销"
                                  otherButtonTitles:nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
//    [actionSheet showInView:self.view];
    [actionSheet showInView:[UIApplication sharedApplication].keyWindow ];
//    actionSheet showFromBarButtonItem:<#(UIBarButtonItem *)#> animated:<#(BOOL)#>
//    actionSheet showFromTabBar:<#(UITabBar *)#>
//    actionSheet showFromToolbar:<#(UIToolbar *)#>
    
}

//Actionsheet实现点击方法
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:{
            NSLog(@"点击第一个");
            [iuiueCHKeychain delete:KEYCHAIN_USERNAMEPASSWORD];
            [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
            [self JieBangTokenOfAPNS];
            [self dismissViewControllerAnimated:YES completion:nil];
            NSDictionary *dic = [NSDictionary dictionaryWithObject:@"close" forKey:@"status"];
            [[NSNotificationCenter defaultCenter] postNotificationName:NO_WebSocketStatusChange object:nil userInfo:dic];

            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[UIApplication sharedApplication].keyWindow makeToast:@"已注销"];
            });
        }
            break;
        case 1:
            NSLog(@"点击第二个");
            break;
        case 2:
            NSLog(@"点击第三个");
            break;
        case 3:
            NSLog(@"点击第四个");
            break;
            
        default:
            break;
    }
}

//返回tableview的headerView的高度
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

//返回tableview的footerView的高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
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
        [[UIApplication sharedApplication].keyWindow makeToast:@"已是最新版本！"];
    }
    else{
        [self showView];
        
    }
}

-(void)showView{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"检测到新版本，是否立即升级？" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:@"取消", nil];
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:URL_UPDATE]];
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

-(void)JieBangTokenOfAPNS{
    __weak ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:URL_JIEBANG_TOKEN]];
    
    request.requestMethod = @"POST";
    
    [request addPostValue:MY_TOKEN forKey:@"devicetoken"];
    [request addPostValue:@"1" forKey:@"type"];
    [request addPostValue:@"0" forKey:@"os"];
    
    //    NSLog(@"%@",MY_TOKEN);
    [request setCompletionBlock:^{
        NSLog(@"%@",request.responseString);
        NSError *error;
        NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingAllowFragments error:&error];
        if (!error) {
            if ([resultDict[@"success"] boolValue] ) {
                NSLog(@"解除推送token成功");
                
            }else{
                [[UIApplication sharedApplication].keyWindow makeToast:resultDict[@"error_msg"] duration:1.5 position:@"center"];
            }
        }else{
            NSLog(@"%@",[error localizedDescription]);
        }
    }];
    
    [request setFailedBlock:^{
        //        [hud hide:YES];
        NSLog(@"%@",[request.error localizedDescription]);
        //        [self.view makeToast:@"网络连接失败，请检查网络设置" duration:1.0f position:@"center"];
        
    }];
    [request startAsynchronous];
}

- (void)receiveNotification:(NSString *) str{
    NSLog(@"%@",str);
}

@end
