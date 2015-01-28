//
//  iuiueBegForRentViewController.m
//  木鸟房东端
//
//  Created by 赵中良 on 14-8-4.
//  Copyright (c) 2014年 iuiue. All rights reserved.
//

#import "iuiueBegForRentViewController.h"
#import "UIImageView+WebCache.h"//引入加载图片的头文件
#import "MJRefresh.h"
#import "FLViewController.h"


@interface iuiueBegForRentViewController ()<MJRefreshBaseViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UILabel *MyLabel;
    MJRefreshHeaderView *_header;
    MJRefreshFooterView *_footer;
    NSInteger pages;
    MBProgressHUD *hud;
    NSMutableArray *MyArray;
    UIScrollView *MyScrollView;
    UITableView *MyTableView;//
    UISegmentedControl *MySegment;//可抢订单，历史求租
}

@end

@implementation iuiueBegForRentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationItem.title = @"城市求租";
//        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(fanhui)];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh) ];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//     self.navigationController.navigationBar.hidden = NO;//取消翻滚后的效果
    self.view.backgroundColor = [UIColor whiteColor];//设置背景不透明
    
    MyArray = [NSMutableArray arrayWithCapacity:15];
    MySegment = [[UISegmentedControl alloc]initWithItems:@[@"可抢订单",@"历史求租"]];
    [MySegment setFrame:CGRectMake(0, 64, MY_WIDTH, 40)];
    [MySegment setSelectedSegmentIndex:0];
    [MySegment addTarget:self action:@selector(segmentValueChange:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:MySegment];
    
    MyLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, MySegment.bottom, MY_WIDTH, 20)];
    MyLabel.backgroundColor = [UIColor orangeColor];
    MyLabel.textColor = [UIColor whiteColor];
    MyLabel.text = @"共有 待查询 条求租";
    MyLabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:MyLabel];
    
    MyTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, MyLabel.bottom, MY_WIDTH, MY_HEIGHT - MyLabel.bottom)];
    MyTableView.dataSource = self;
    MyTableView.delegate = self;
    MyTableView.tableFooterView = [[UIView alloc]init];
    
    [self.view addSubview:MyTableView];
    [self setFreshView];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    hud =
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"加载中...";
    pages = 1;
    [self getOrderArray:NO];
//    self.tabBarController.tabBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    self.tabBarController.tabBar.hidden = NO;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - mjfresh
- (void)setFreshView{
    // 下拉刷新
    _header = [[MJRefreshHeaderView alloc] init];
    _header.delegate = self;
    _header.scrollView = MyTableView;
    
    // 上拉加载更多
    _footer = [[MJRefreshFooterView alloc] init];
    _footer.delegate = self;
    _footer.scrollView = MyTableView;
}

#pragma mark 代理方法-进入刷新状态就会调用
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"HH : mm : ss.SSS";
    
    if (_header == refreshView) {
        
        pages = 1;
        [self getOrderArray:NO];
        
    } else {
        [self getOrderArray:YES];
    }
    
}


//跳转返回
-(void)fanhui{
//    self.navigationController.navigationBar.hidden = YES;//取消翻滚后的效果
    [self dismissFlipWithCompletion:nil];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    [_header endRefreshing];
    [_footer endRefreshing];
    return MyArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    static NSString *reuseIdentifier = @"reuseIdentifier";
    NSString *reuseIdentifier = [NSString stringWithFormat:@"%d",indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    UILabel *label;
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
//        cell.imageView.image = [UIImage imageNamed:@"backgroud"];
        label = [[UILabel alloc]initWithFrame:CGRectMake(240, 10, 60, 20)];
        [cell.contentView addSubview:label];
    }

    NSDictionary *dic = MyArray[indexPath.row];
    NSString *passStr = [NSString stringWithFormat:@"%@",dic[@"overdue"]];
    if ([passStr intValue]==1) {
        NSString *NumberStr = [NSString stringWithFormat:@"%@",dic[@"reply"]];
        if ([NumberStr intValue]==1) {
            UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40, 30)];
            imgV.image = [UIImage imageNamed:@"huifu"];
            cell.accessoryView = imgV;
        }else{
            UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40, 30)];
            imgV.image = [UIImage imageNamed:@"guoqi"];
            cell.accessoryView = imgV;
        }
    }else{
        NSString *NumberStr = [NSString stringWithFormat:@"%@",dic[@"reply"]];
        if ([NumberStr intValue]==1) {
            UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40, 30)];
            imgV.image = [UIImage imageNamed:@"huifu"];
            cell.accessoryView = imgV;
        }
    }
//    UIImageView *imV = [[UIImageView alloc]init];
//    [imV  setImageWithURL:[NSURL URLWithString:[dic valueForKey:@"userimage"]] placeholderImage:[UIImage imageNamed:@"ChatBack"]];
//
//    cell.imageView.image = imV.image;
    [cell.imageView setImageWithURL:[NSURL URLWithString:[dic valueForKey:@"userimage"]] placeholderImage:[UIImage imageNamed:@"ChatBack"]];
        cell.textLabel.text = [NSString stringWithFormat:@"%@",dic[@"username"]];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",dic[@"contents"]];
    cell.detailTextLabel.font = cell.textLabel.font;
    cell.detailTextLabel.textColor = [UIColor grayColor];
    label.textColor = [UIColor grayColor];
    NSString *date = [NSString stringWithFormat:@"%@",dic[@"addtime"]];
    label.text = [date substringWithRange:NSMakeRange(5, 5)];
    return cell;
}

//刷新当前页数据
-(void)refresh{
    hud =
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"加载中...";
    pages = 1;
    [self getOrderArray:NO];
}

//切换后刷新
-(IBAction)segmentValueChange:(id)sender{
    [self refresh];
}

//获取数据
-(void)getOrderArray:(BOOL) UpDown{

    __weak ASIFormDataRequest *request;
    
    request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:URL_QIUZU]];
    
    request.requestMethod = @"POST";
    
    
    NSString *page = [NSString stringWithFormat:@"%ld",(long)pages];
    [request addPostValue:page forKey:@"page"];
    [request addPostValue:MY_UID forKey:@"uid"];
    [request addPostValue:MY_ZEND forKey:@"zend"];
    //可抢
    switch (MySegment.selectedSegmentIndex) {
        case 0:
            [request addPostValue:@"1" forKey:@"type"];

            break;
        case 1:
            [request addPostValue:@"2" forKey:@"type"];
            break;
        default:
            break;
    }
    
    
    [request setCompletionBlock:^{
        NSLog(@"%@",request.responseString);
        NSError *error;
        NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingAllowFragments error:&error];
        if (!error) {
            switch ([resultDict[@"status"] integerValue]) {
                case 0:{
                    [hud hide:YES];
                    NSArray *ListArray = resultDict[@"list"];
                    if (UpDown) {
                        [MyArray addObjectsFromArray:ListArray];
                        [MyTableView reloadData];
                    }
                    else{
                        [MyArray removeAllObjects];
                        [MyArray addObjectsFromArray:ListArray];
                        [MyTableView reloadData];
                    }
                    //获取数据后更新发布房间数量
                    MyLabel.text = [NSString stringWithFormat:@"当前有 %@ 条求租",resultDict[@"count"]];
                    
                    pages++;
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
        
    }];
    
    //异步加载
    [request startAsynchronous];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}


//点击跳转
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    FLViewController *flVc= [[FLViewController alloc]initWithNibName:@"FLViewController" bundle:nil];
    NSDictionary *dic = MyArray[indexPath.row];
    NSString *PassStr = [NSString stringWithFormat:@"%@",dic[@"overdue"]];
    if ([PassStr intValue]==1) {
        flVc.IsPass = YES;
    }else{
        flVc.IsPass = NO;
    }
    flVc.UserId = [NSString stringWithFormat:@"%@",dic[@"qiuzuid"]];
    [self.navigationController pushViewController:flVc animated:YES];
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
    NSLog(@"iuiueBegForRentViewController--dealloc---");
    [_footer free];
    [_header free];
}

@end
