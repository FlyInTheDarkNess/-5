//
//  iuiueOrderViewController.m
//  iuiue
//
//  Created by mizilang on 14-5-8.
//  Copyright (c) 2014年 iuiue. All rights reserved.
//

#import "iuiueOrderViewController.h"
#import "iuiueOrderTableViewController.h"
#import "iuiueNotFundOrderViewController.h"
@interface iuiueOrderViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *arry;
    UITableView *tableview;
    NSDictionary *dictionary;
    NSArray *array;
    float height;
    MBProgressHUD *hud;
    __weak ASIFormDataRequest *request;
}

@end

@implementation iuiueOrderViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationItem.title = @"订单管理";
        UIBarButtonItem *item = [[UIBarButtonItem alloc]init];
        self.navigationController.navigationBar.backgroundColor = [UIColor redColor];
        self.navigationItem.backBarButtonItem = item;
        item.title = @"返回";
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(viewinit)];
        //翻转效果已取消
        /*
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(fanhui)];
         */
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.navigationController.navigationBar.hidden = NO;//取消翻滚后的效果(已取消翻转效果)
//    NSLog(@"%@",array);
    arry = [NSArray array];
    arry = @[@"待确认",@"待付款",@"已付款",@"已完成",@"待处理退款",@"已退款",@"已拒绝",@"已过确认时间",@"可以收取定金"];
    tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, MY_WIDTH, MY_HEIGHT)];
    tableview.bounces = NO;
    //    tableview.separatorStyle = NO;//去掉cell间的横线
    tableview.delegate = self;
    tableview.dataSource = self;
    
    [self.view addSubview:tableview];
    //    [self getarr1];
    // Do any additional setup after loading the view from its nib.
}

-(void)fanhui{
//    self.navigationController.navigationBar.hidden = YES;
    [self dismissFlipWithCompletion:nil];
//    [self dismissViewControllerAnimated:YES completion:NULL];//系统自带present返回
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return array.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseidentifier = @"reuseidentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseidentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseidentifier];
    }
    NSString *string = arry[indexPath.row];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    NSString *title = [NSString stringWithFormat:@"%@",array[indexPath.row]];
    label.text = title;
    label.textColor = [UIColor whiteColor];
    UIImageView *littleView = [[UIImageView alloc]initWithFrame:CGRectMake(270,height/2 - 15, 30, 30)];
    NSLog(@"cell:%f",cell.frame.size.height);
    littleView.image = [UIImage imageNamed:@"button"];
    
    [label setTextAlignment:NSTextAlignmentCenter];
    [littleView addSubview:label];
    if ([label.text isEqualToString:@"0"]) {
        littleView.hidden = YES;
    }
    cell.accessoryView = littleView;
    cell.textLabel.text = string;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGRect r = [ UIScreen mainScreen ].applicationFrame;
    CGFloat number = r.size.height - 64;
    height = number/9;
    return height;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath: [tableView indexPathForSelectedRow] animated:YES];
    iuiueAllService *service = [[iuiueAllService alloc]init];
    if (![service isConnectionAvailable]) {
        [[UIApplication sharedApplication].keyWindow makeToast:@"网络连接失败...请检查网络设置" duration:1 position:@"center"];
        return;
    }
    NSString *str = [NSString stringWithFormat:@"%@",array[indexPath.row]];
    if ([str isEqualToString:@"0"]) {
        iuiueNotFundOrderViewController *NVC = [[iuiueNotFundOrderViewController alloc]initWithNibName:@"iuiueNotFundOrderViewController" bundle:nil];
        [self.navigationController pushViewController:NVC animated:YES];
    }
    else{
        iuiueOrderTableViewController *orderTVC = [[iuiueOrderTableViewController alloc]initWithStyle:UITableViewStylePlain];
        orderTVC.number = [indexPath row];
        [self.navigationController pushViewController:orderTVC animated:YES];
    }
}

//-(NSArray *)getarr{
//    NSMutableDictionary *usernamepasswordKVPairs = (NSMutableDictionary *)[iuiueCHKeychain load:KEYCHAIN_USERNAMEPASSWORD];
//    NSString *uid =[usernamepasswordKVPairs objectForKey:KEYCHAIN_UID];
//    NSString *zend = [usernamepasswordKVPairs objectForKey:KEYCHAIN_ZEND];
//    iuiueAllService *service = [[iuiueAllService alloc]init];
//    [service ordercountDictionaryInit:[NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",zend,@"zend", nil]];
//    NSDictionary *dic = service.diction;
//    NSLog(@"room：%@",dic);
//
//    NSArray *arr;
//    arr = [NSArray arrayWithObjects:[dic valueForKey:@"daiqueren"],[dic valueForKey:@"weifukuan"],[dic valueForKey:@"yifukuan"],[dic valueForKey:@"yiwancheng"],[dic valueForKey:@"daituikuan"],[dic valueForKey:@"yituikuan"],[dic valueForKey:@"yijujue"],[dic valueForKey:@"yiguoquerenshijian"],[dic valueForKey:@"keyishouqudingjin"], nil];
//    return arr;
//}

-(BOOL)getarr1{
    NSMutableDictionary *usernamepasswordKVPairs = (NSMutableDictionary *)[iuiueCHKeychain load:KEYCHAIN_USERNAMEPASSWORD];
    NSString *uid =[usernamepasswordKVPairs objectForKey:KEYCHAIN_UID];
    NSString *zend = [usernamepasswordKVPairs objectForKey:KEYCHAIN_ZEND];
    request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:URL_NEW_ORDER]];
    request.requestMethod = @"POST";
    [request addPostValue:uid forKey:@"uid"];
    [request addPostValue:zend forKey:@"zend"];
    
    __block BOOL flag = YES;
    
    [request setCompletionBlock:^{
        NSLog(@"%@",request.responseString);
        NSError *error;
        NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingAllowFragments error:&error];
        if (!error) {
            switch ([resultDict[@"status"] integerValue]) {
                case 0:
                    [hud hide:NO];
                    array = [NSArray arrayWithObjects:[resultDict valueForKey:@"daiqueren"],[resultDict valueForKey:@"weifukuan"],[resultDict valueForKey:@"yifukuan"],[resultDict valueForKey:@"yiwancheng"],[resultDict valueForKey:@"daituikuan"],[resultDict valueForKey:@"yituikuan"],[resultDict valueForKey:@"yijujue"],[resultDict valueForKey:@"yiguoquerenshijian"],[resultDict valueForKey:@"keyishouqudingjin"], nil];
                    [tableview reloadData];
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
        hud.labelText = @"加载失败。。";
        
    }];
    hud =
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"加载中...";
    //    hud.detailsLabelText = @"正在登录，请稍后....";
    [request startAsynchronous];
    
    return flag;
}

-(void)viewinit{
    //    array = [self getarr];
    [self getarr1];
    [tableview reloadData];
}

//每次返回的时候刷新
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    self.tabBarController.tabBar.hidden = YES;
    [self getarr1];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    self.tabBarController.tabBar.hidden = NO;
}
-(void)dealloc{
    [request cancel];
//    self.hidesBottomBarWhenPushed = YES;
}



@end

