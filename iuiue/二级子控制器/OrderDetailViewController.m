//
//  iuiueOrderDetailViewController.m
//  木鸟房东助手
//
//  Created by 赵中良 on 14/12/25.
//  Copyright (c) 2014年 iuiue. All rights reserved.
//

#import "OrderDetailViewController.h"

@interface OrderDetailViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSDictionary *dic;
    UITableView *MyTableView;
    NSArray *array;
    NSArray *arr;
    __weak ASIFormDataRequest *request;
}

@end

@implementation OrderDetailViewController
@synthesize Orderid;

-(void)dealloc{
    [request cancel];
    request = nil;
    dic = nil;
    MyTableView = nil;
    arr = nil;
    array = nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    MyTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, MY_WIDTH, MY_HEIGHT)];
    MyTableView.dataSource = self;
    MyTableView.delegate = self;
    MyTableView.rowHeight = 50;
    MyTableView.tableFooterView = [[UITableView alloc]init];
    [self.view addSubview:MyTableView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 14;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *userindentify = @"userindentify";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:userindentify];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:userindentify];
    }
    NSString *str = array[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@:",arr[indexPath.row]];
    
    NSString *Detail = [NSString stringWithFormat:@"%@",dic[str]];
    NSCharacterSet *characterSet1 = [NSCharacterSet characterSetWithCharactersInString:@"\n"];
    
    NSArray *array1 = [Detail componentsSeparatedByCharactersInSet:characterSet1];
    cell.detailTextLabel.numberOfLines = array1.count;
    cell.detailTextLabel.text = Detail;
    NSLog(@"%@",dic[str]);
    if (indexPath.row == 2) {
        switch ([Detail integerValue]) {
            case 1:
                Detail = @"待确认";
                break;
            case 2:
                Detail = @"未付款";
                break;

            case 3:
                Detail = @"已付款";
                break;

            case 4:
                Detail = @"已完成";
                break;

            case 5:
                Detail = @"待处理退款";
                break;

            case 6:
                Detail = @"已退款";
                break;

            case 7:
                Detail = @"已拒绝";
                break;
            case 8:
                Detail = @"已过确认时间";
                break;

            case 9:
                Detail = @"可以收取定金";
                break;
            case 10:
                Detail = @"已付款待入住";
                break;
            case 100:
                Detail = @"已取消";
                break;
            default:{
                Detail = @"待查询";
            }
                break;
        }
        cell.detailTextLabel.text = Detail;
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 13) {
        return 80;
    }
    return 44;
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    array = @[@"ordernum",@"adddate",@"status",@"title",@"title2",@"total_price",@"prepay_price",@"start_date",@"end_date",@"rent_type",@"sameroom",@"username",@"rentnumber",@"refundtype"];
    arr = @[@"订单编号",@"订单日期",@"订单状态",@"房间标题",@"房间别名",@"全部房款",@"本单定金",@"入住时间",@"退房时间",@"租房类型",@"租住数量",@"房客名称",@"入住人数",@"退款协议"];
    [self GetOrderDetail];
}


-(void)GetOrderDetail{
    request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:URL_ORDER_DETAIL]];

    request.requestMethod = @"POST";
    [request addPostValue:MY_UID forKey:@"uid"];
    [request addPostValue:MY_ZEND forKey:@"zend"];
    [request addPostValue:self.Orderid forKey:@"orderid"];
    
    [request setCompletionBlock:^{
        
        NSLog(@"%@",request.responseString);
        NSError *error;
        NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingAllowFragments error:&error];
        if (!error) {
            switch ([resultDict[@"status"] integerValue]) {
                case 0:
                    dic = resultDict[@"info"];
                    [MyTableView reloadData];
                    break;
                case 90:{
                    NSString *str = [NSString stringWithFormat:@"%@",resultDict[@"message"]];
                    [self.view makeToast:str duration:1.5 position:@"center"];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self dismissViewControllerAnimated:YES completion:nil];
                    });
                }
                    break;
                default:
                {
                    NSString *str = [NSString stringWithFormat:@"%@",resultDict[@"message"]];
                    [self.view makeToast:str duration:1.0 position:@"center"];
                }
                    break;
            }
        }else{
            NSLog(@"%@",[error localizedDescription]);
        }
    }];
    
    [request setFailedBlock:^{
//        [hud hide:YES];
        NSLog(@"%@",[request.error localizedDescription]);
        [self.view makeToast:@"网络连接失败，请检查网络设置" duration:1.0f position:@"center"];
        
    }];
//    hud =
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    hud.labelText = @"正在加载，请稍后...";
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

@end
