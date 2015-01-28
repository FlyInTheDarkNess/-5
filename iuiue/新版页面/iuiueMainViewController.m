//
//  iuiueMainViewController.m
//  木鸟房东助手
//
//  Created by 赵中良 on 14/12/9.
//  Copyright (c) 2014年 iuiue. All rights reserved.
//
#define MJCollectionViewCellIdentifier (@"cell")
#import "iuiueMainViewController.h"
#import "iuiueOrderViewController.h"
#import "iuiueOrderTableViewController.h"
#import "iuiueGetcashiViewController.h"
#import "iuiueMoreViewController.h"
#import "iuiueRoomSelectViewController.h"//
#import "iuiueAddOrderTableViewController.h"//抢生意
#import "iuiueBegForRentViewController.h"//求租
#import "iuiueMyEarningsViewController.h"//我的收益
#import "iuiueMyAppRaiseViewController.h"//房东回评
#import "iuiueWayForCashViewController.h"//收款方式
#import "iuiueFeedBackViewController.h"//反馈信息

#import "iuiueChatListViewController.h"//聊天控制器
#import "iuiueRemindViewController.h"
#import "OrderDetailViewController.h"

@interface iuiueMainViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>{
    UIScrollView *MyScrollView;
    UIWebView *phoneCallWebView;
    UILabel *leftlabelT;
    UILabel *rightlabelT;
}

@end

@implementation iuiueMainViewController

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:APNS_SHUA object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    UIImageView *Image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"房东助手首页页面.jpg"]];
//    [Image setFrame:MY_SCREEN];
//    [self.view addSubview:Image];
    
    //设置背景颜色暗灰色（不透明）
    self.view.backgroundColor = [UIColor whiteColor];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(MainViewRefresh:) name:APNS_SHUA object:nil];
    //push到新的页面时隐藏tabbar
//    self.hidesBottomBarWhenPushed = YES;
    
    MyScrollView = [[UIScrollView alloc]initWithFrame:MY_SCREEN];
    
    
    UIImageView *ImV = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, MY_WIDTH - 20, 150)];
    if (MY_WIDTH > 320 &&MY_WIDTH < 400) {
        [ImV setFrame:CGRectMake(10, 10, MY_WIDTH - 20, 200)];
    }else if(MY_WIDTH > 400){
        [ImV setFrame:CGRectMake(10, 10, MY_WIDTH - 20, 240)];
    }
    ImV.image = [UIImage imageNamed:@"木鸟短租.jpg"];
    ImV.layer.masksToBounds = YES;
    ImV.layer.cornerRadius = 10;
    
    
    //待处理订单按钮初始化并创建
    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, ImV.bottom + 10, (MY_WIDTH - 30)/2, 80)];
    leftBtn.layer.masksToBounds = YES;
    leftBtn.layer.cornerRadius = 10;
    leftBtn.tag = 11;
    [leftBtn addTarget:self action:@selector(PressBtn:) forControlEvents:UIControlEventTouchUpInside];
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"btn_gray"] forState:UIControlStateNormal];
    
    UILabel *leftlabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, leftBtn.width, 20)];
    leftlabel.text = @"待确认订单";
    leftlabel.textColor = [UIColor grayColor];
    leftlabel.font = [UIFont systemFontOfSize:15];
    leftlabel.textAlignment = NSTextAlignmentCenter;
    leftlabelT = [[UILabel alloc]initWithFrame:CGRectMake(0, leftlabel.bottom + 5, leftBtn.width, 30)];
    leftlabelT.text = @"0";
    leftlabelT.textColor = [UIColor orangeColor];
    leftlabelT.font = [UIFont systemFontOfSize:30];
    leftlabelT.textAlignment = NSTextAlignmentCenter;
    [leftBtn addSubviews:@[leftlabel,leftlabelT]];
    
    //待处理消息按钮初始化并创建
    UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(leftBtn.right + 10, leftBtn.top, leftBtn.width, leftBtn.height)];
    rightBtn.tag = 12;
    rightBtn.layer.masksToBounds = YES;
    rightBtn.layer.cornerRadius = 10;
    rightBtn.layer.borderWidth = 2.0f;
    rightBtn.layer.borderColor = (__bridge CGColorRef)([UIColor blackColor]);
     [rightBtn addTarget:self action:@selector(PressBtn:) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"btn_gray"] forState:UIControlStateNormal];
    UILabel *rightlabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, rightBtn.width, 20)];
    rightlabel.text = @"待处理消息";
    rightlabel.textColor = [UIColor grayColor];
    rightlabel.font = [UIFont systemFontOfSize:15];
    rightlabel.textAlignment = NSTextAlignmentCenter;
    rightlabelT = [[UILabel alloc]initWithFrame:CGRectMake(0, rightlabel.bottom + 5, rightBtn.width, 30)];
    rightlabelT.text = @"0";
    rightlabelT.textColor = [UIColor orangeColor];
    rightlabelT.font = [UIFont systemFontOfSize:30];
    rightlabelT.textAlignment = NSTextAlignmentCenter;
    [rightBtn addSubviews:@[rightlabel,rightlabelT]];
    
    
    //创建CollectionView
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake((MY_WIDTH - 20)/4,(MY_WIDTH - 20)/4);
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    
    UICollectionView *Collection = [[UICollectionView alloc]initWithFrame:CGRectMake(10, leftBtn.bottom + 5, MY_WIDTH - 20, (MY_WIDTH - 20)/4 * 3) collectionViewLayout:layout];
    Collection.layer.cornerRadius = 10.5f;
    Collection.bounces = NO;
    Collection.scrollEnabled = NO;
    Collection.delegate = self;
    Collection.dataSource = self;
    
    Collection.backgroundColor = [UIColor groupTableViewBackgroundColor];
    Collection.alwaysBounceVertical = YES;
    [Collection registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:MJCollectionViewCellIdentifier];
    [MyScrollView addSubview:Collection];
    [MyScrollView setContentSize:CGSizeMake(MY_WIDTH, Collection.bottom + 10)];
    
    [MyScrollView addSubviews:@[ImV,leftBtn,rightBtn]];
    MyScrollView.bounces = NO;
    
    [self.view addSubview:MyScrollView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getarr];
    [self GetOrderTongzhiList];
    self.navigationController.navigationBarHidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

#pragma mark - collection数据源代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 12;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MJCollectionViewCellIdentifier forIndexPath:indexPath];
//    cell.contentView.layer.cornerRadius = 5.0f;
//    NSLog(@"%d",cell.subviews.count);
    
    
    //根据cell子视图数量来判断是否初始化
    if (cell.subviews.count<2) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, (MY_WIDTH - 20)/4, (MY_WIDTH - 20)/4)];
        
        NSString *ImgStr;
        switch (indexPath.row) {
            case 0:
                ImgStr = @"order_manage";
                break;
            case 1:
                ImgStr = @"add_order";
                break;
            case 2:
                ImgStr = @"change_room";
                break;
            case 3:
                ImgStr = @"change_price";
                break;
            case 4:
                ImgStr = @"beg_order";
                break;
            case 5:
                ImgStr = @"reraise";
                break;
            case 6:
                ImgStr = @"myearn";
                break;
            case 7:
                ImgStr = @"cash_way";
                break;
            case 8:
                ImgStr = @"feedback";
                break;
            case 9:
                ImgStr = @"call";
                break;
            case 10:
                ImgStr = @"more";
                break;
            case 11:{
                ImgStr = @"none";
                btn.hidden = YES;
                UIImageView *imag= [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, (MY_WIDTH - 20)/4,(MY_WIDTH - 20)/4)];
                imag.image=[UIImage imageNamed:@"none"];
                [cell addSubview:imag];
            }
                break;
                
            default:
                break;
        }
        [btn setBackgroundImage:[UIImage imageNamed:ImgStr] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(PressBtn:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = indexPath.row;
        [cell addSubview:btn];
    }
    cell.contentView.backgroundColor = [UIColor grayColor];
    cell.backgroundColor = [UIColor clearColor];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0,0, 100, 100)];
    view.backgroundColor = [UIColor redColor];
    cell.selectedBackgroundView = view;
    
//    NSLog(@"%d",cell.subviews.count);
    return cell;
}

-(IBAction)PressBtn:(id)sender{
    UIButton *btn = (UIButton *)sender;
    switch (btn.tag) {
        case 0:
        {
            //订单管理
            iuiueOrderViewController *Order = [[iuiueOrderViewController alloc]init];
            Order.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:Order animated:YES];
        }
            break;
        case 1:
        {
            //增加销量
            iuiueAddOrderTableViewController *roomvc = [[iuiueAddOrderTableViewController alloc]init];
            roomvc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:roomvc animated:YES];

        }
            break;
        case 2:
        {
            //修改房态
            iuiueRoomSelectViewController *roomvc = [[iuiueRoomSelectViewController alloc]init];
            roomvc.hidesBottomBarWhenPushed = YES;
            roomvc.title = @"我的房间";
            [self.navigationController pushViewController:roomvc animated:YES];
        }
            break;
        case 3:
        {
            //修改价格
            iuiueOrderTableViewController *roomvc = [[iuiueOrderTableViewController alloc]init];
            roomvc.hidesBottomBarWhenPushed = YES;
            roomvc.title = @"我的房间";
            roomvc.number = 9;
            [self.navigationController pushViewController:roomvc animated:YES];
            
           
        }
            break;
        case 4:
        {
            //抢生意
            iuiueBegForRentViewController *begForRent = [[iuiueBegForRentViewController alloc]init];
            begForRent.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:begForRent animated:YES];
            
        }
            break;
        case 5:
        {
            //我的评价
            iuiueMyAppRaiseViewController *AppRaise = [[iuiueMyAppRaiseViewController alloc]init];
            AppRaise.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:AppRaise animated:YES];
        }
            break;
        case 6:
        {
            //我的收益
            iuiueMyEarningsViewController *myEarn = [[iuiueMyEarningsViewController alloc]init];
            myEarn.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:myEarn animated:YES];

        }
            break;
        case 7:
        {
            //收款方式
            iuiueWayForCashViewController *way = [[iuiueWayForCashViewController alloc]initWithNibName:@"iuiueWayForCashViewController" bundle:nil];
            way.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:way animated:YES];
        }
            break;
        case 8:
        {
            //问题反馈
            iuiueFeedBackViewController *feedBackVC = [[iuiueFeedBackViewController alloc]initWithNibName:@"iuiueFeedBackViewController" bundle:nil];
            feedBackVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:feedBackVC animated:YES];
        }
            break;
        case 9:
        {
            //木鸟客服
            //播电话
            NSString *phoneNum = @"400-056-0055";// 电话号码
            NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",phoneNum]];
            if ( !phoneCallWebView ) {
                phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];// 这个webView只是一个后台的View 不需要add到页面上来  效果跟方法二一样 但是这个方法是合法的
            }
            [phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
        }
            break;
        case 10:
        {
            //更多
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"更多功能，敬请期待。。。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
            break;
        case 11:
        {
            if ([leftlabelT.text isEqualToString:@"0"]) {
                [[UIApplication sharedApplication].keyWindow makeToast:@"当前没有待确认订单"];
            }else{
            //待处理订单
            iuiueOrderTableViewController *orderTVC = [[iuiueOrderTableViewController alloc]initWithStyle:UITableViewStylePlain];
            orderTVC.hidesBottomBarWhenPushed = YES;
            orderTVC.number = 0;
            [self.navigationController pushViewController:orderTVC animated:YES];
            }
        }
            break;
        case 12:
        {
            //待处理消息
            iuiueRemindViewController *remind = [[iuiueRemindViewController alloc]init];
            remind.hidesBottomBarWhenPushed = YES;
            remind.title = @"订单消息提醒";
            [self.navigationController pushViewController:remind animated:YES];
            
        }
            break;
        case 13:
        {
            
        }
            break;
            
        default:
            break;
    }
}



-(BOOL)getarr{
   __weak ASIFormDataRequest * request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:URL_NEW_ORDER]];
    request.requestMethod = @"POST";
    [request addPostValue:MY_UID forKey:@"uid"];
    [request addPostValue:MY_ZEND forKey:@"zend"];
    NSLog(@"MY_zend:%@",MY_ZEND);
    NSLog(@"%@",MY_UID);
    __block BOOL flag = YES;
    
    [request setCompletionBlock:^{
        NSLog(@"%@",request.responseString);
        NSError *error;
        NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingAllowFragments error:&error];
        if (!error) {
            switch ([resultDict[@"status"] integerValue]) {
                case 0:
//                    [hud hide:NO];
                    leftlabelT.text = [[resultDict valueForKey:@"daiqueren"] stringValue];
                    self.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d",[rightlabelT.text integerValue]+[leftlabelT.text integerValue]];
                    if ([self.navigationController.tabBarItem.badgeValue isEqualToString:@"0"]) {
                        self.navigationController.tabBarItem.badgeValue = nil;
                    }
//                    array = [NSArray arrayWithObjects:[resultDict valueForKey:@"daiqueren"],[resultDict valueForKey:@"weifukuan"],[resultDict valueForKey:@"yifukuan"],[resultDict valueForKey:@"yiwancheng"],[resultDict valueForKey:@"daituikuan"],[resultDict valueForKey:@"yituikuan"],[resultDict valueForKey:@"yijujue"],[resultDict valueForKey:@"yiguoquerenshijian"],[resultDict valueForKey:@"keyishouqudingjin"], nil];
//                    [tableview reloadData];
                    break;
                case 1:
                    
                    flag = NO;
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
                    break;
            }
        }else{
            NSLog(@"%@",[error localizedDescription]);
        }
    }];
    
    [request setFailedBlock:^{
        NSLog(@"%@",[request.error localizedDescription]);
//        hud.labelText = @"加载失败。。";
        
    }];
//    hud =
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    hud.labelText = @"加载中...";
    //    hud.detailsLabelText = @"正在登录，请稍后....";
    [request startAsynchronous];
    
    return flag;
}

-(void)GetOrderTongzhiList{
    __weak ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:URL_ORDER_TONGZHI]];
    
    request.requestMethod = @"POST";
    [request addPostValue:MY_UID forKey:@"uid"];
    [request addPostValue:@"1" forKey:@"utype"];
    [request addPostValue:MY_UUID forKey:@"urnd"];
    [request addPostValue:MY_UZEND forKey:@"uzend"];
    [request setCompletionBlock:^{
        NSLog(@"%@",request.responseString);
        NSError *error;
        NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingAllowFragments error:&error];
        if (!error) {
            if ([resultDict[@"success"] boolValue]) {
                NSArray *arr= resultDict[@"list"];
                rightlabelT.text = [NSString stringWithFormat:@"%d",arr.count];
                self.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d",[rightlabelT.text integerValue]+[leftlabelT.text integerValue]];
                if ([self.navigationController.tabBarItem.badgeValue isEqualToString:@"0"]) {
                    self.navigationController.tabBarItem.badgeValue = nil;
                }
            }else{
                NSString *str = [NSString stringWithFormat:@"%@",resultDict[@"message"]];
                [self.view makeToast:str duration:1.0 position:@"center"];
            }
            
        }else{
            NSLog(@"%@",[error localizedDescription]);
        }
    }];
    
    [request setFailedBlock:^{
        NSLog(@"%@",[request.error localizedDescription]);
        [self.view makeToast:@"网络连接失败，请检查网络设置" duration:1.0f position:@"center"];
    }];
    
    [request startAsynchronous];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)MainViewRefresh:(NSNotification *) NSNotification{
    NSDictionary *dic = [NSNotification userInfo];
    if ([dic[@"status"] isEqualToString:@"Chat"]) {
        [self.navigationController.tabBarController setSelectedIndex:0];
        [self.navigationController.tabBarController setSelectedIndex:0];
        NSLog(@"聊天推送");
    }else if([dic[@"status"] isEqualToString:@"OrderOut"]){
         NSLog(@"订单推送");
        [self.navigationController.tabBarController setSelectedIndex:1];
        [self GetOrderTongzhiList];
        [self getarr];
    }else{
        [self GetOrderTongzhiList];
        [self getarr];
    }

    
}

@end
