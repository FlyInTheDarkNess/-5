//
//  iuiueRemindViewController.m
//  木鸟房东助手
//
//  Created by 赵中良 on 14/12/24.
//  Copyright (c) 2014年 iuiue. All rights reserved.
//

#import "iuiueRemindViewController.h"
//#import "iuiueOrderDetailViewController"
#import "OrderDetailViewController.h"
@interface iuiueRemindViewController ()<UITableViewDataSource,UITableViewDelegate>{
    UITableView *MyTableView;//列表
    NSMutableArray *arr;
    __weak ASIFormDataRequest *request;
}

@end

@implementation iuiueRemindViewController
-(void)dealloc{
    [request cancel];
    request = nil;
    MyTableView = nil;
    arr = nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, MY_HEIGHT/2 - 50, MY_WIDTH, 50)];
    label.font = [UIFont fontWithName:@"Helvetica" size:25];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor grayColor];
    label.text = @"当前没有提醒消息";
    [self.view addSubview:label];
    
    MyTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, MY_WIDTH, MY_HEIGHT - 64)];
    MyTableView.rowHeight = 60;
    MyTableView.tableFooterView = [[UIView alloc]init];
    MyTableView.delegate = self;
    MyTableView.dataSource = self;
    
    [self.view addSubview:MyTableView];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]init];
    item.title = @"返回";
    self.navigationItem.backBarButtonItem= item;
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark-UITableView

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (arr.count == 0) {
        tableView.hidden = YES;
    }
    return arr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *useidentify = @"useidentify";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:useidentify];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:useidentify];
    }
    NSDictionary *dic = arr[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"订单编号：%@",dic[@"str"]];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    NSString *status;
    switch ([dic[@"status"] integerValue]) {
                    case 1:
                        status = @"待确认";
                        break;
                    case 2:
                        status = @"已拒绝";
                        break;
                        
                    case 3:
                        status = @"待付款";
                        break;
                        
                    case 4:
                        status = @"房客取消订单";
                        break;
                        
                    case 5:
                        status = @"已付款";
                        break;
                        
                    case 6:
                        status = @"申请退款";
                        break;
                        
                    case 7:
                        status = @"取消退款";
                        break;
                    case 8:
                        status = @"不同意退款";
                        break;
                        
                    case 9:
                        status = @"退款中";
                        break;
                    case 10:
                        status = @"退款完成";
                        break;
                    case 11:
                        status = @"房客已评价";
                        break;
                    case 12:
                        status = @"房东已回评";
                        break;
                        
                    default:{
                        status = @"待查询";
                    }
                        break;

    }
    cell.detailTextLabel.text = [NSString stringWithFormat: @"订单状态：%@",status];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 30)];
    NSString *time = [NSString stringWithFormat:@"%@",dic[@"adddate"]];
    label.text = [self returnUploadTime:time];
    label.font = [UIFont systemFontOfSize:10];
    label.textColor = [UIColor grayColor];
    label.textAlignment = NSTextAlignmentCenter;
    cell.accessoryView = label;
    return cell;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSDictionary *dic = arr[indexPath.row];
        NSString *orderid = [NSString stringWithFormat:@"%@",dic[@"cid"]];
        [self OrderTongzhiDelete:orderid];
        [arr removeObjectAtIndex:[indexPath row]];  //删除数组里的数据
        [tableView deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = arr[indexPath.row];
    OrderDetailViewController *order = [[OrderDetailViewController alloc]init];
    order.Orderid = [NSString stringWithFormat:@"%@",dic[@"cid"]];
    [self OrderTongzhiDelete:order.Orderid];
    order.title = @"订单详情";
    [self.navigationController pushViewController:order animated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    arr = [NSMutableArray array];
    [self GetOrderTongzhiList];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}


-(void)GetOrderTongzhiList{
    
    request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:URL_ORDER_TONGZHI]];
    
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
                [arr removeAllObjects];
                NSArray *array = resultDict[@"list"];
                [arr addObjectsFromArray:array];
                if (arr.count==0) {
                    
                }else{
                    MyTableView.hidden = NO;
                    [MyTableView reloadData];

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

-(void)OrderTongzhiDelete:(NSString *)OrderId{
    request = nil;
    request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:URL_ORDER_READ]];
    
    request.requestMethod = @"POST";
    [request addPostValue:MY_UID forKey:@"uid"];
    [request addPostValue:@"1" forKey:@"utype"];
    [request addPostValue:MY_UUID forKey:@"urnd"];
    [request addPostValue:MY_UZEND forKey:@"uzend"];
    [request addPostValue:OrderId forKey:@"orderid"];
    [request setCompletionBlock:^{
        NSLog(@"%@",request.responseString);
        NSError *error;
        NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingAllowFragments error:&error];
        if (!error) {
            if ([resultDict[@"success"] boolValue]) {
//                [self GetOrderTongzhiList];
//                [self.view makeToast:@"删除成功" duration:1.0 position:@"center"];

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

/*处理返回应该显示的时间*/
- (NSString *) returnUploadTime:(NSString *)timeStr
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timeStr doubleValue]];
    
    NSTimeInterval late=[date timeIntervalSince1970]*1;
    
    NSDateFormatter *yourformatter = [[NSDateFormatter alloc]init];
    
    //    NSTimeInterval late = [d timeIntervalSince1970]*1;
    
    NSString * timeString = nil;
    
    NSDate * dat = [NSDate dateWithTimeIntervalSinceNow:0];
    
    NSTimeInterval now = [dat timeIntervalSince1970]*1;
    
    NSTimeInterval cha = now - late;
    if (cha/3600 < 1) {
        
        timeString = [NSString stringWithFormat:@"%f", cha/60];
        
        timeString = [timeString substringToIndex:timeString.length-7];
        
        int num= [timeString intValue];
        
        if (num <= 1) {
            
            timeString = [NSString stringWithFormat:@"刚刚..."];
            
        }else{
            
            [yourformatter setDateFormat:@"HH:mm"];
            
            timeString = [NSString stringWithFormat:@"今天 %@",[yourformatter stringFromDate:date]];
        }
        
    }
    
    if (cha/3600 > 1 && cha/86400 < 1) {
        
        timeString = [NSString stringWithFormat:@"%f", cha/3600];
        
        timeString = [timeString substringToIndex:timeString.length-7];
        
        [yourformatter setDateFormat:@"HH:mm"];
        
        timeString = [NSString stringWithFormat:@"今天 %@",[yourformatter stringFromDate:date]];
        
        NSTimeInterval secondPerDay = 24*60*60;
        
        NSDate * yesterDay = [NSDate dateWithTimeIntervalSinceNow:-secondPerDay];
        
        NSCalendar * calendar = [NSCalendar currentCalendar];
        
        unsigned uintFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
        
        NSDateComponents * souretime = [calendar components:uintFlags fromDate:date];
        
        NSDateComponents * yesterday = [calendar components:uintFlags fromDate:yesterDay];
        
        if (souretime.year == yesterday.year && souretime.month == yesterday.month && souretime.day == yesterday.day){
            
            [yourformatter setDateFormat:@"HH:mm"];
            
            timeString = [NSString stringWithFormat:@"昨天 %@",[yourformatter stringFromDate:date]];
        }
    }
    
    if (cha/86400 > 1)
        
    {
        
        timeString = [NSString stringWithFormat:@"%f", cha/86400];
        
        timeString = [timeString substringToIndex:timeString.length-7];
        
        int num = [timeString intValue];
        
        if (num < 2) {
            [yourformatter setDateFormat:@"HH:mm"];
            
            timeString = [NSString stringWithFormat:@"昨天 %@",[yourformatter stringFromDate:date]];
            
        }else if(num == 2){
            
            [yourformatter setDateFormat:@"HH:mm"];
            
            timeString = [NSString stringWithFormat:@"前天 %@",[yourformatter stringFromDate:date]];
            
        }else if (num > 2 && num <7){
            
            [yourformatter setDateFormat:@"MM-dd"];
            
            timeString = [NSString stringWithFormat:@"%@",[yourformatter stringFromDate:date]];
            //            timeString = [NSString stringWithFormat:@"%@天前", timeString];
            
        }else if (num >= 7 && num <= 10) {
            
            //            timeString = [NSString stringWithFormat:@"1周前"];
            [yourformatter setDateFormat:@"MM-dd"];
            
            timeString = [NSString stringWithFormat:@"%@",[yourformatter stringFromDate:date]];
            
        }else if(num > 10){
            
            [yourformatter setDateFormat:@"MM-dd"];
            
            timeString = [NSString stringWithFormat:@"%@",[yourformatter stringFromDate:date]];
            
        }
        
    }
    
    
    return timeString;
}




@end
