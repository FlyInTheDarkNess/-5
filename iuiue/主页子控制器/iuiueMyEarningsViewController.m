//
//  iuiueMyEarningsViewController.m
//  木鸟房东端
//
//  Created by 赵中良 on 14-7-18.
//  Copyright (c) 2014年 iuiue. All rights reserved.
//

#import "iuiueMyEarningsViewController.h"
#import "MJRefresh.h"
#import "ASIFormDataRequest.h"

@interface iuiueMyEarningsViewController ()<UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate>
{
    UILabel *MyEarningsLabel;//总收益显示
    UIScrollView *BigScrollView;
    UITableView *MytableView;
    MJRefreshHeaderView *_header;
    MJRefreshFooterView *_footer;
    NSInteger _page;//当前页码
    MBProgressHUD *hud;
    NSMutableDictionary *MyDic;
    NSMutableArray *MyArray;//当前array
    NSMutableArray *monthArray;
    __weak ASIFormDataRequest *request;
}

@end

@implementation iuiueMyEarningsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationItem.title = @"我的收益";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //初始化
    MyArray = [NSMutableArray array];
    MyDic = [NSMutableDictionary dictionary];
    monthArray = [NSMutableArray array];
    
    //设置背景不透明
    self.view.backgroundColor = [UIColor whiteColor];
    
    //总收益显示
    MyEarningsLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, 20)];
    MyEarningsLabel.backgroundColor = [UIColor blueColor];
    MyEarningsLabel.textColor = [UIColor whiteColor];
    MyEarningsLabel.textAlignment = NSTextAlignmentRight;
    MyEarningsLabel.text = @"总收益 待查询 元";
    
    //自适应
    BigScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, MyEarningsLabel.bottom, MyEarningsLabel.width, [UIScreen mainScreen].bounds.size.height - MyEarningsLabel.height - 64)];
    
    //设置bigScrollView的contentSize
    
    [BigScrollView setContentSize:CGSizeMake(BigScrollView.width * 2, BigScrollView.height)];
    
    //设置滚到边缘不可继续滚动
    BigScrollView.bounces = NO;
    
    UISegmentedControl *Segment = [[UISegmentedControl alloc]initWithItems:@[@"房客姓名",@"房间号",@"下单时间",@"入住时间",@"退房时间",@"天数",@"订单收益"]];
    [Segment setFrame:CGRectMake(0, 0, BigScrollView.width * 2, 20)];
    Segment.momentary = YES;//设置在点击后是否恢复原样
    
    MytableView = [[UITableView alloc]initWithFrame:CGRectMake(0, Segment.height, Segment.width, BigScrollView.height - Segment.height)];
    
    MytableView.dataSource = self;
    MytableView.delegate = self;
    
    
    [self.view addSubview:MyEarningsLabel];
    [self.view addSubview:BigScrollView];
    [BigScrollView addSubview:Segment];
    [BigScrollView addSubview:MytableView];
    //添加下拉刷新
    [self setFreshView];
    
    
    // Do any additional setup after loading the view.
}

#pragma mark - mjfresh
- (void)setFreshView{
    // 下拉刷新
    _header = [[MJRefreshHeaderView alloc] init];
    _header.delegate = self;
    _header.scrollView = MytableView;
    
    // 上拉加载更多
    _footer = [[MJRefreshFooterView alloc] init];
    _footer.delegate = self;
    _footer.scrollView = MytableView;
}
#pragma mark 代理方法-进入刷新状态就会调用
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"HH : mm : ss.SSS";
    
    if (_header == refreshView) {
        
       _page = 1;
        //刷新调用
        [self getMyEarningsDic:YES];
        
    } else {
        //加载更多
        [self getMyEarningsDic:NO];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    hud =
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"加载中...";

    _page = 1;
    [self getMyEarningsDic:YES];
//    self.tabBarController.tabBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    self.tabBarController.tabBar.hidden = NO;
}


//接口获取数据
-(void)getMyEarningsDic:(BOOL) IsUpdate{
    
    
    
    request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:URL_MY_EAENINGS]];
    
    request.requestMethod = @"POST";
    
    
    NSString *page = [NSString stringWithFormat:@"%ld",(long)_page];
    [request addPostValue:page forKey:@"page"];
    [request addPostValue:MY_UID forKey:@"uid"];
    [request addPostValue:MY_ZEND forKey:@"zend"];
    
    [request setCompletionBlock:^{
        NSLog(@"%@",request.responseString);
        NSError *error;
        NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingAllowFragments error:&error];
        if (!error) {
            switch ([resultDict[@"status"] integerValue]) {
                case 0:{
                    [hud hide:YES];
                    NSArray *ListArray = resultDict[@"list"];
                    if (IsUpdate) {
                        [MyArray removeAllObjects];
                        [MyArray addObjectsFromArray:ListArray];
                        [self arrayToDictionary];
                        [MytableView reloadData];
                    }
                    else{
                        [MyArray addObjectsFromArray:ListArray];
                        [self arrayToDictionary];
                        [MytableView reloadData];
                    }
                    //获取数据后更新发布房间数量
                    NSString *str = [NSString stringWithFormat:@"%@",resultDict[@"ordersproceeds"]];
                    MyEarningsLabel.text = [NSString stringWithFormat:@"总收益 %.2f 元",[str floatValue]];
                    
                    _page++;
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
                    break;
            }
        }else{
            NSLog(@"%@",[error localizedDescription]);
        }
    }];
    
    //获取数据失败处理
    [request setFailedBlock:^{
        NSLog(@"%@",[request.error localizedDescription]);
        hud.labelText = @"加载失败。。";
//        [hud hide:YES afterDelay:1];
        
    }];
    
       //异步加载
    [request startAsynchronous];
}


-(void)arrayToDictionary{
    NSMutableArray *array = [NSMutableArray array];
    [monthArray removeAllObjects];
    for (id _id in MyArray) {
        NSString *str1 = [NSString stringWithFormat:@"%@",[_id valueForKey:@"adddate"]];
        NSString *str2 = [str1 substringToIndex:7];
        
        if (monthArray.count == 0) {
            [monthArray addObject:str2];
            [array addObject:_id];
        }
        else if([monthArray.lastObject isEqualToString:str2]){
            [array addObject:_id];
            NSMutableArray *arr = [NSMutableArray arrayWithArray:array];
            [MyDic setObject:arr forKey:monthArray.lastObject];
            
        }
        else{
            NSMutableArray *arr = [NSMutableArray arrayWithArray:array];
            [MyDic setObject:arr forKey:monthArray.lastObject];
            [array removeAllObjects];
            [array addObject:_id];
            [monthArray addObject:str2];
            NSMutableArray *arr1 = [NSMutableArray arrayWithArray:array];
            [MyDic setObject:arr1 forKey:monthArray.lastObject];
            
            [MyDic setObject:arr1 forKey:monthArray.lastObject];
        }
    }
    NSLog(@"数据转换完毕");
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    [_footer endRefreshing];
    [_header endRefreshing];
    return monthArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSString *str = monthArray[section];
    
    NSArray *arr = MyDic[str];
    
    return arr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *reuseIdentifier = [NSString stringWithFormat:@"%d-%d",indexPath.section,indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        
        for (int num = 0; num < 7; num++) {
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(num * MytableView.width/7, 5, MytableView.width/7, 20)];
            label.textAlignment = NSTextAlignmentCenter;
            [cell.contentView addSubview:label];
            NSString *str = monthArray[indexPath.section];
            
            NSArray *arr = MyDic[str];
            
            NSDictionary *dic = arr[indexPath.row];
            switch (num) {
                case 0:
                    label.text = [NSString stringWithFormat:@"%@",dic[@"username"]];
                    break;
                case 1:
                    label.text = [NSString stringWithFormat:@"%@",dic[@"room_id"]];
                    break;
                case 2:{
                    NSString *str = [NSString stringWithFormat:@"%@",dic[@"adddate"]];
                    label.text = [str substringFromIndex:5];
                    label.adjustsFontSizeToFitWidth = YES;
                }
                    break;
                case 3:{
                    NSString *str = [NSString stringWithFormat:@"%@",dic[@"start_date"]];
                    label.text = [str substringFromIndex:5];
//                    [label sizeToFit];
                }
                    break;
                case 4:{
                    NSString *str = [NSString stringWithFormat:@"%@",dic[@"end_date"]];
                    label.text = [str substringFromIndex:5];
//                    label.adjustsFontSizeToFitWidth = YES;
                }
                    break;
                case 5:{
                    
                    label.text = [NSString stringWithFormat:@"%@",dic[@"days"]];
                }
                    break;
                case 6:
                    label.text = [NSString stringWithFormat:@"%@",dic[@"total_price"]];
                    break;
                default:
                    break;
            }
        }
    }
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    
    cell.backgroundColor = [UIColor colorWithRed:135.0f/255.0f green:206.0f/255.0f blue:250.0f/255.0f alpha:1];
    
    cell.textLabel.text = monthArray[section];
    
    return cell;
    
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UITableViewCell *cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
    NSString *str = monthArray[section];
    
    NSArray *arr = MyDic[str];
    
    NSInteger month = 0;
    for (NSDictionary *dic in arr) {
        NSString *strone = [NSString stringWithFormat:@"%@",dic[@"total_price"]];
        month = month + [strone integerValue];
    }
    cell.detailTextLabel.text = [NSString stringWithFormat:@"月总计：%d",month];
    
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)dealloc{
    [request cancel];
    [_header free];
    [_footer free];
}

@end
