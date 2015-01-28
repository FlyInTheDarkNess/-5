//
//  iuiueOrderTableViewController.m
//  iuiue
//
//  Created by 赵中良 on 14-5-19.
//  Copyright (c) 2014年 iuiue. All rights reserved.
//

#import "iuiueOrderTableViewController.h"
#import "MJRefresh.h"
#import "iuiueAllService.h"
#import "UIImageView+WebCache.h"//引入加载图片的头文件
#import "Toast+UIView.h"
#import "iuiueOrderDetailViewController.h"
#import "iuiueRoomManageViewController.h"
#import "iuiueChatViewController.h"
NSString *const iuiueOrderTableViewCellIdentifier = @"Cell";

@interface iuiueOrderTableViewController ()<UIAlertViewDelegate,UIActionSheetDelegate,MJRefreshBaseViewDelegate>
{
    NSMutableArray *_fakeData; // 假数据(只存放字符串)
    
    MJRefreshHeaderView *_header;
    MJRefreshFooterView *_footer;
    NSInteger pages;
    NSString *endtitle;
    
    MBProgressHUD *hud;
    __weak ASIFormDataRequest *request;
}
@end

@implementation iuiueOrderTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
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

    //改版后取消翻转
    /*
    if (self.number == 9) {
        self.navigationController.navigationBar.hidden = NO;//取消翻滚后的效果
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(fanhui)];
    }
     */
    //设置title

    [self setMytitle];
    
    // 1.注册
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:iuiueOrderTableViewCellIdentifier];
    
    // 2.初始化假数据
    _fakeData = [NSMutableArray array];

    
    
    self.tableView.tableFooterView = [[UIView alloc]init];//设置tableview的footerView
    //滚动到初始位置
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //添加刷新控件
    if (!_header) {
         [self setFreshView];
    }
}

//跳转返回（）
-(void)fanhui{
//    self.navigationController.navigationBar.hidden = YES ;
    [self dismissFlipWithCompletion:nil];
}

//设置navigationitem的title
-(void)setMytitle{
    NSString *MyTitleStr;
    switch (self.number) {
        case 0:
            MyTitleStr = [NSString stringWithFormat:@"待确认订单"];
            break;
        case 1:
            MyTitleStr = [NSString stringWithFormat:@"待付款订单"];
            break;
        case 2:
            MyTitleStr = [NSString stringWithFormat:@"已付款订单"];
            break;
        case 3:
            MyTitleStr = [NSString stringWithFormat:@"已完成订单"];
            break;
        case 4:
            MyTitleStr = [NSString stringWithFormat:@"待处理退款订单"];
            break;
        case 5:
            MyTitleStr = [NSString stringWithFormat:@"已退款订单"];
            break;
        case 6:
            MyTitleStr = [NSString stringWithFormat:@"已拒绝订单"];
            break;
        case 7:
            MyTitleStr = [NSString stringWithFormat:@"已过确认时间订单"];
            break;
        case 8:
            MyTitleStr = [NSString stringWithFormat:@"可以收取订金订单"];
            break;
        case 9:
            MyTitleStr = [NSString stringWithFormat:@"我的房间"];
            break;
            
        default:
            break;
    }
    self.navigationItem.title = MyTitleStr;
}

#pragma mark - mjfresh
- (void)setFreshView{
    // 下拉刷新
    _header = [[MJRefreshHeaderView alloc] init];
    _header.delegate = self;
    _header.scrollView = self.tableView;
    
    // 上拉加载更多
    _footer = [[MJRefreshFooterView alloc] init];
    _footer.delegate = self;
    _footer.scrollView = self.tableView;
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView setFrame:CGRectMake(0, 64, MY_WIDTH, 200)];
    hud =
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"加载中...";
    pages = 1;
    [self getOrderArray:NO];
    CGPoint position = CGPointMake(0 , 0);
    [self.tableView setContentOffset:position animated:YES];
    self.navigationController.navigationBar.translucent = YES;//设置navigationBar透明
//    self.tabBarController.tabBar.hidden = YES;
//    self.tabBarController.tabBar.translucent = YES;
    
    
    //显示房间列表时显示返回键（翻转效果已取消）
    /*
    if (self.number == 9) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(fanhui)];
    }
     */
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    [_header endRefreshing];
    [_footer endRefreshing];
  
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
  
    return _fakeData.count;;
}

- (void)doneWithView:(MJRefreshBaseView *)refreshView
{
    // 刷新表格
    [self.tableView reloadData];
    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    [refreshView endRefreshing];
}

/**
 为了保证内部不泄露，在dealloc中释放占用的内存
 */
- (void)dealloc
{
    [request cancel];
    NSLog(@"MJTableViewController--dealloc---");
    request = Nil;
    _fakeData = Nil;
    [_header free];
    [_footer free];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *reuseindentify =@"sdfas";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseindentify];
//    if (!cell) {
        switch (_number) {
            case 0:{
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseindentify];
                
                //添加横线
                UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(15, 35, MY_WIDTH - 30, 1)];
                line.image = [UIImage imageNamed:@"line"];
                [cell addSubview:line];
                
                
                 cell.selectionStyle = UITableViewCellSelectionStyleNone;
                UILabel *titlelabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, MY_WIDTH - 30, 30)];
                [titlelabel setTag:1];
                [cell.contentView addSubview:titlelabel];
                
                UIImageView *imgeV = [[UIImageView alloc]initWithFrame:CGRectMake(15, 40, 155, 120)];
                [imgeV setTag:2];
                [cell.contentView addSubview:imgeV];
                
                //入住人数
                UILabel *innumber = [[UILabel alloc]initWithFrame:CGRectMake(180, 40, 55, 15)];
                innumber.text = @"入住人数:";
                innumber.font = [UIFont fontWithName:@"Helvetica" size:12];
                innumber.textColor = [UIColor blackColor];
                [cell.contentView addSubview:innumber];
                
                UILabel *number = [[UILabel alloc]initWithFrame:CGRectMake(innumber.frame.origin.x +55, innumber.frame.origin.y, 20, 15)];
                number.font = [UIFont fontWithName:@"Helvetica" size:12];
                number.textColor = [UIColor blackColor];
                [number setTag:3];
                [cell.contentView addSubview:number];
                
                //预定数量
                UILabel *roomnumber = [[UILabel alloc]initWithFrame:CGRectMake(180, 60, 55, 15)];
                roomnumber.text = @"预订数量:";
                roomnumber.textColor = [UIColor blackColor];
                roomnumber.font = [UIFont fontWithName:@"Helvetica" size:12];
                [cell.contentView addSubview:roomnumber];
                
                UILabel *numberR = [[UILabel alloc]initWithFrame:CGRectMake(roomnumber.frame.origin.x + 55, roomnumber.frame.origin.y, 20, 15)];
                [numberR setTag:4];
                numberR.textColor = [UIColor blackColor];
                numberR.font = [UIFont fontWithName:@"Helvetica" size:12];
                [cell.contentView addSubview:numberR];
                
                //订单号
                UILabel *order = [[UILabel alloc]initWithFrame:CGRectMake(180, 80, 50, 15)];
                order.font = [UIFont fontWithName:@"Helvetica" size:12];
                order.textColor = [UIColor blackColor];
                order.text = @"订单号:";
                [cell.contentView addSubview:order];
                
                UILabel *ordernumber = [[UILabel alloc]initWithFrame:CGRectMake(order.frame.origin.x + 55, order.frame.origin.y, 70, 15)];
                ordernumber.numberOfLines = 0;
                ordernumber.textColor = [UIColor blackColor];
                [ordernumber setTag:5];
                ordernumber.font = [UIFont fontWithName:@"Helvetica" size:12];
                [cell.contentView addSubview:ordernumber];
                
                UILabel *startdate = [[UILabel alloc]initWithFrame:CGRectMake(180, 110, 60, 15)];
                startdate.font = [UIFont fontWithName:@"Helvetica" size:10];
                [startdate setTag:6];
                startdate.textColor = [UIColor blackColor];
                UILabel *enddate = [[UILabel alloc]initWithFrame:CGRectMake(180, 130, 60, 15)];
                enddate.font = [UIFont fontWithName:@"Helvetica" size:10];
                [enddate setTag:7];
                enddate.textColor = [UIColor blackColor];
                
                UILabel *start = [[UILabel alloc]initWithFrame:CGRectMake(startdate.frame.origin.x + 65, startdate.frame.origin.y, 30, 15)];
                UILabel *end = [[UILabel alloc]initWithFrame:CGRectMake(enddate.frame.origin.x + 65, enddate.frame.origin.y, 30, 15)];
                start.textColor = [UIColor blackColor];
                end.textColor = [UIColor blackColor];
                start.font = [UIFont fontWithName:@"Helvetica" size:12];
                end.font = [UIFont fontWithName:@"Helvetica" size:12];
                start.text = @"入住";
                end.text = @"离开";
                [start sizeToFit];
                [end sizeToFit];
                [cell.contentView addSubview:start];
                [cell.contentView addSubview:end];
                [cell.contentView addSubview:startdate];
                [cell.contentView addSubview:enddate];
                
                UILabel *allprice = [[UILabel alloc]initWithFrame:CGRectMake(180, 155, 30, 15)];
                allprice.font = [UIFont fontWithName:@"Helvetica" size:12];
                allprice.text = @"总房款￥：";
                allprice.textColor = [UIColor blackColor];
                [allprice sizeToFit];
                [cell.contentView addSubview:allprice];
                
                UILabel *all = [[UILabel alloc]initWithFrame:CGRectMake(185 + allprice.frame.size.width, allprice.frame.origin.y, 50, 15)];
                all.font = [UIFont fontWithName:@"Helvetica" size:12];
                [all setTextColor:[UIColor orangeColor]];
                [all setTag:8];
                [cell.contentView addSubview:all];
                
                UILabel *prepay_Price = [[UILabel alloc]initWithFrame:CGRectMake(180, 175, 30, 15)];
                prepay_Price.font = [UIFont fontWithName:@"Helvetica" size:12];
                prepay_Price.text = @"定金￥：";
                prepay_Price.textColor = [UIColor blackColor];
                 [prepay_Price sizeToFit];
                [cell.contentView addSubview:prepay_Price];
                
                UILabel *prepay = [[UILabel alloc]initWithFrame:CGRectMake(185 + prepay_Price.frame.size.width, prepay_Price.frame.origin.y, 50, 15)];
                prepay.font = [UIFont fontWithName:@"Helvetica" size:12];
                [prepay setTextColor:[UIColor orangeColor]];
                [prepay setTag:9];
                [cell.contentView addSubview:prepay];
                
                UILabel *last_Price = [[UILabel alloc]initWithFrame:CGRectMake(180, 195, 30, 15)];
                
                last_Price.font = [UIFont fontWithName:@"Helvetica" size:12];
                last_Price.textColor = [UIColor blackColor];
                last_Price.text = @"到店付款￥：";
                [last_Price sizeToFit];
                [cell.contentView addSubview:last_Price];
                
                UILabel *last = [[UILabel alloc]initWithFrame:CGRectMake(185 + last_Price.frame.size.width, last_Price.frame.origin.y, 50, 15)];
                last.font = [UIFont fontWithName:@"Helvetica" size:12];
                last.textColor = [UIColor blackColor];
                [last setTextColor:[UIColor orangeColor]];
                [cell.contentView addSubview:last];
                
                UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(40, last.frame.origin.y + 20, 100, 40)];
                btn.layer.cornerRadius = 10;
                [btn setBackgroundColor:[UIColor greenColor]];
                [btn setTitle:@"接受" forState:UIControlStateNormal];
                [cell.contentView addSubview:btn];
                
                UIButton *btn1 = [[UIButton alloc]initWithFrame:CGRectMake(180, last.frame.origin.y + 20, 100, 40)];
                [btn1 setBackgroundColor:[UIColor redColor]];
                btn1.layer.cornerRadius = 10;
                [btn1 setTitle:@"拒绝" forState:UIControlStateNormal];
                
                [btn1 setTag:12];
                [cell.contentView addSubview:btn1];
                
//                UIButton *btn3 = [[UIButton alloc]initWithFrame:CGRectMake(40, last.frame.origin.y + 20, 100, 40)];
//                btn.layer.cornerRadius = 10;
//                [btn setBackgroundColor:[UIColor greenColor]];
//                [btn setTitle:@"联系房客" forState:UIControlStateNormal];
//                [cell.contentView addSubview:btn];
                
                
                [btn setTag:indexPath.row * 100000 ];
                NSLog(@"row:%d",btn.tag);
                [btn1 setTag:indexPath.row * 100000 + 1];
                [btn addTarget:self action:@selector(ordercanpay:) forControlEvents:UIControlEventTouchUpInside];
                [btn1 addTarget:self action:@selector(ordercanpay:) forControlEvents:UIControlEventTouchUpInside];
                
                
                
                
                [cell setFrame:CGRectMake(0, 0, MY_WIDTH, btn.frame.origin.y + btn.frame.size.height + 10)];
        }

                break;
            case 1:
            {
//                cell = [nib objectAtIndex:1];
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseindentify];
                //添加横线
                UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(15, 35,MY_WIDTH - 30, 1)];
                line.image = [UIImage imageNamed:@"line"];
                [cell addSubview:line];

                UILabel *titlelabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, MY_WIDTH - 30, 30)];
                [titlelabel setTag:1];
                [cell.contentView addSubview:titlelabel];
                
                UIImageView *imgeV = [[UIImageView alloc]initWithFrame:CGRectMake(15, 40, 155, 120)];
                [imgeV setTag:2];
                [cell.contentView addSubview:imgeV];
                
                UILabel *order = [[UILabel alloc]initWithFrame:CGRectMake(180, 40, 40, 15)];
                order.font = [UIFont fontWithName:@"Helvetica" size:12];
                order.text = @"订单号:";
                
                order.textColor = [UIColor blackColor];
                [cell.contentView addSubview:order];
                
                UILabel *ordernumber = [[UILabel alloc]initWithFrame:CGRectMake(order.frame.origin.x + 55, order.frame.origin.y, 80, 15)];
                ordernumber.numberOfLines = 0;
                ordernumber.textColor = [UIColor blackColor];
                [ordernumber setTag:3];
                ordernumber.font = [UIFont fontWithName:@"Helvetica" size:12];
                [cell.contentView addSubview:ordernumber];
                
                //入住时间
                UILabel *startdate = [[UILabel alloc]initWithFrame:CGRectMake(180, 70, 60, 15)];
                startdate.font = [UIFont fontWithName:@"Helvetica" size:10];
                [startdate setTag:4];
                startdate.textColor = [UIColor blackColor];
                UILabel *enddate = [[UILabel alloc]initWithFrame:CGRectMake(180, 90, 60, 15)];
                enddate.textColor = [UIColor blackColor];
                enddate.font = [UIFont fontWithName:@"Helvetica" size:10];
                [enddate setTag:5];
                
                UILabel *start = [[UILabel alloc]initWithFrame:CGRectMake(startdate.frame.origin.x + 65, startdate.frame.origin.y, 30, 15)];
                UILabel *end = [[UILabel alloc]initWithFrame:CGRectMake(enddate.frame.origin.x + 65, enddate.frame.origin.y, 30, 15)];
                start.font = [UIFont fontWithName:@"Helvetica" size:12];
                end.font = [UIFont fontWithName:@"Helvetica" size:12];
                start.text = @"入住";
                end.text = @"离开";
                [start sizeToFit];
                [end sizeToFit];
                [cell.contentView addSubview:start];
                [cell.contentView addSubview:end];
                [cell.contentView addSubview:startdate];
                [cell.contentView addSubview:enddate];
                UILabel *allprice = [[UILabel alloc]initWithFrame:CGRectMake(180, 140, 30, 15)];
//                allprice.font = [UIFont fontWithName:@"Helvetica" size:12];
//                allprice.text = @"金额￥：";
//                [allprice sizeToFit];
//                [cell.contentView addSubview:allprice];
                UILabel *status = [[UILabel alloc]initWithFrame:CGRectMake(200, 100, 80, 40)];
                [status setTextColor:[UIColor greenColor]];
                status.font = [UIFont fontWithName:@"Helvetica" size:20];
                status.text = @"未付款";
                [cell.contentView addSubview:status];
                
                UILabel *all = [[UILabel alloc]initWithFrame:CGRectMake(150 + allprice.frame.size.width, allprice.frame.origin.y, 120, 15)];
                all.font = [UIFont fontWithName:@"Helvetica" size:12];
                [all setTextColor:[UIColor orangeColor]];
                [all setTag:6];
                [cell.contentView addSubview:all];
                
                //根据图片设置cell的height
                
                [cell setFrame:CGRectMake(0, 0, MY_WIDTH, imgeV.frame.origin.y + imgeV.frame.size.height + 10)];
                
            }
                break;
            case 2:{
                {
                    //                cell = [nib objectAtIndex:0];
                    //                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseindentify];
                    //添加横线
                    UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(15, 35,MY_WIDTH - 30, 1)];
                    line.image = [UIImage imageNamed:@"line"];
                    [cell addSubview:line];

                    UILabel *titlelabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, MY_WIDTH - 30, 30)];
                    [titlelabel setTag:1];
                    [cell.contentView addSubview:titlelabel];
                    
                    UIImageView *imgeV = [[UIImageView alloc]initWithFrame:CGRectMake(15, 40, 155, 120)];
                    [imgeV setTag:2];
                    [cell.contentView addSubview:imgeV];
                    
                    //订单号
                    UILabel *order = [[UILabel alloc]initWithFrame:CGRectMake(180, 40, 50, 15)];
                    order.font = [UIFont fontWithName:@"Helvetica" size:12];
                    order.text = @"订单号:";
                    [cell.contentView addSubview:order];
                    
                    UILabel *ordernumber = [[UILabel alloc]initWithFrame:CGRectMake(order.frame.origin.x + 55, order.frame.origin.y, 70, 15)];
                    ordernumber.numberOfLines = 0;
                    [ordernumber setTag:3];
                    ordernumber.font = [UIFont fontWithName:@"Helvetica" size:12];
                    [cell.contentView addSubview:ordernumber];
                    
                    //入住与退出
                    UILabel *startdate = [[UILabel alloc]initWithFrame:CGRectMake(180, 80, 60, 15)];
                    startdate.font = [UIFont fontWithName:@"Helvetica" size:10];
                    [startdate setTag:4];
                    UILabel *enddate = [[UILabel alloc]initWithFrame:CGRectMake(180, 100, 60, 15)];
                    enddate.font = [UIFont fontWithName:@"Helvetica" size:10];
                    [enddate setTag:5];
                    
                    UILabel *start = [[UILabel alloc]initWithFrame:CGRectMake(startdate.frame.origin.x + 65, startdate.frame.origin.y, 30, 15)];
                    UILabel *end = [[UILabel alloc]initWithFrame:CGRectMake(enddate.frame.origin.x + 65, enddate.frame.origin.y, 30, 15)];
                    start.font = [UIFont fontWithName:@"Helvetica" size:12];
                    end.font = [UIFont fontWithName:@"Helvetica" size:12];
                    start.text = @"入住";
                    end.text = @"退房";
                    [start sizeToFit];
                    [end sizeToFit];
                    [cell.contentView addSubview:start];
                    [cell.contentView addSubview:end];
                    [cell.contentView addSubview:startdate];
                    [cell.contentView addSubview:enddate];

                    //入住人数
                    UILabel *innumber = [[UILabel alloc]initWithFrame:CGRectMake(180, 120, 55, 15)];
                    innumber.text = @"入住人数:";
                    innumber.font = [UIFont fontWithName:@"Helvetica" size:12];
                    [cell.contentView addSubview:innumber];
                    
                    UILabel *number = [[UILabel alloc]initWithFrame:CGRectMake(innumber.frame.origin.x +55, innumber.frame.origin.y, 20, 15)];
                    number.font = [UIFont fontWithName:@"Helvetica" size:12];
                    [number setTag:6];
                    [cell.contentView addSubview:number];
                    
                    //预定数量
                    UILabel *roomnumber = [[UILabel alloc]initWithFrame:CGRectMake(180, 140, 55, 15)];
                    roomnumber.text = @"预订数量:";
                    roomnumber.font = [UIFont fontWithName:@"Helvetica" size:12];
                    [cell.contentView addSubview:roomnumber];
                    
                    UILabel *numberR = [[UILabel alloc]initWithFrame:CGRectMake(roomnumber.frame.origin.x + 55, roomnumber.frame.origin.y, 20, 15)];
                    [numberR setTag:7];
                    numberR.font = [UIFont fontWithName:@"Helvetica" size:12];
                    [cell.contentView addSubview:numberR];
                
                    
                    UILabel *allprice = [[UILabel alloc]initWithFrame:CGRectMake(180, 155, 130, 30)];
                    allprice.font = [UIFont fontWithName:@"Helvetica" size:12];
                    allprice.text = @"租客已付定金，到店请热情接待哦。";
                    allprice.numberOfLines= 2;
                    [allprice sizeToFit];
                    [cell.contentView addSubview:allprice];
                    UILabel *last_Price = [[UILabel alloc]initWithFrame:CGRectMake(180, 195, 30, 15)];
                    
                    last_Price.font = [UIFont fontWithName:@"Helvetica" size:12];
                    last_Price.text = @"到店需支付￥：";
                    [last_Price sizeToFit];
                    [cell.contentView addSubview:last_Price];
                    
                    UILabel *last = [[UILabel alloc]initWithFrame:CGRectMake(185 + last_Price.frame.size.width, last_Price.frame.origin.y, 50, 15)];
                    last.font = [UIFont fontWithName:@"Helvetica" size:12];
                    [last setTextColor:[UIColor orangeColor]];
                    [last setTag:8];
                    [cell.contentView addSubview:last];
                    
                    [cell setFrame:CGRectMake(0, 0, MY_WIDTH, imgeV.frame.origin.y + imgeV.frame.size.height + 50)];
                }

            }
//                cell = [nib objectAtIndex:2];
                break;
            case 3:{
                 cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseindentify];
                //添加横线
                UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(15, 35, MY_WIDTH - 30, 1)];
                line.image = [UIImage imageNamed:@"line"];
                [cell addSubview:line];

                UILabel *titlelabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, MY_WIDTH - 30, 30)];
                [titlelabel setTag:1];
                [cell.contentView addSubview:titlelabel];
                
                UIImageView *imgeV = [[UIImageView alloc]initWithFrame:CGRectMake(15, 40, 155, 120)];
                [imgeV setTag:2];
                [cell.contentView addSubview:imgeV];
                
                UILabel *room = [[UILabel alloc]initWithFrame:CGRectMake(180, 40, 30, 15)];
                room.text = @"房号：";
                room.font = [UIFont fontWithName:@"Helvetica" size:12];
                [room sizeToFit];
                [cell.contentView addSubview:room];
                
                UILabel *roomid = [[UILabel alloc]initWithFrame:CGRectMake(215, 40, 80, 15)];
                roomid.font = [UIFont fontWithName:@"Helvetica" size:11];
                [roomid setTag:3];
                [cell.contentView addSubview:roomid];
                
                UILabel *startdate = [[UILabel alloc]initWithFrame:CGRectMake(180, 60, 60, 15)];
                startdate.font = [UIFont fontWithName:@"Helvetica" size:10];
                [startdate setTag:4];
                UILabel *enddate = [[UILabel alloc]initWithFrame:CGRectMake(180, 75, 60, 15)];
                enddate.font = [UIFont fontWithName:@"Helvetica" size:10];
                [enddate setTag:5];
                
                UILabel *start = [[UILabel alloc]initWithFrame:CGRectMake(startdate.frame.origin.x + 65, startdate.frame.origin.y, 30, 15)];
                UILabel *end = [[UILabel alloc]initWithFrame:CGRectMake(enddate.frame.origin.x + 65, enddate.frame.origin.y, 30, 15)];
                start.font = [UIFont fontWithName:@"Helvetica" size:12];
                end.font = [UIFont fontWithName:@"Helvetica" size:12];
                start.text = @"入住";
                end.text = @"离开";
                [start sizeToFit];
                [end sizeToFit];
                [cell.contentView addSubview:start];
                [cell.contentView addSubview:end];
                [cell.contentView addSubview:startdate];
                [cell.contentView addSubview:enddate];
                
                UILabel *user = [[UILabel alloc]initWithFrame:CGRectMake(180, 95, 30, 15)];
                user.font = [UIFont fontWithName:@"Helvetica" size:12];
                [cell.contentView addSubview:user];
                user.text = @"租客:";
                
                UILabel *username = [[UILabel alloc]initWithFrame:CGRectMake(user.frame.origin.x + 35, user.frame.origin.y, 60, 15)];
                [username setTag:6];
                username.font = [UIFont fontWithName:@"Helvetica" size:12];
                [cell.contentView addSubview:username];
                
                UILabel *status = [[UILabel alloc]initWithFrame:CGRectMake(200, 115, 80, 40)];
                [status setTextColor:[UIColor greenColor]];
                status.font = [UIFont fontWithName:@"Helvetica" size:20];
                status.text = @"已完成";
                [cell.contentView addSubview:status];
                
                [cell setFrame:CGRectMake(0, 0, MY_WIDTH, imgeV.frame.origin.y + imgeV.frame.size.height + 10)];
            }
                break;
            case 4:{
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseindentify];
                
                //添加横线
                UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(15, 35, MY_WIDTH - 30, 1)];
                line.image = [UIImage imageNamed:@"line"];
                [cell addSubview:line];

                UILabel *titlelabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, MY_WIDTH - 30, 30)];
                [titlelabel setTag:1];
                [cell.contentView addSubview:titlelabel];
                
                UIImageView *imgeV = [[UIImageView alloc]initWithFrame:CGRectMake(15, 40, 155, 120)];
                [imgeV setTag:2];
                [cell.contentView addSubview:imgeV];
                
                UILabel *room = [[UILabel alloc]initWithFrame:CGRectMake(180, 40, 30, 15)];
                room.text = @"房号：";
                room.font = [UIFont fontWithName:@"Helvetica" size:12];
                [room sizeToFit];
                [cell.contentView addSubview:room];
                
                UILabel *roomid = [[UILabel alloc]initWithFrame:CGRectMake(215, 40, 80, 15)];
                roomid.font = [UIFont fontWithName:@"Helvetica" size:11];
                [roomid setTag:3];
                [cell.contentView addSubview:roomid];
                
                UILabel *startdate = [[UILabel alloc]initWithFrame:CGRectMake(180, 60, 60, 15)];
                startdate.font = [UIFont fontWithName:@"Helvetica" size:10];
                [startdate setTag:4];
                UILabel *enddate = [[UILabel alloc]initWithFrame:CGRectMake(180, 75, 60, 15)];
                enddate.font = [UIFont fontWithName:@"Helvetica" size:10];
                [enddate setTag:5];
                
                UILabel *start = [[UILabel alloc]initWithFrame:CGRectMake(startdate.frame.origin.x + 65, startdate.frame.origin.y, 30, 15)];
                UILabel *end = [[UILabel alloc]initWithFrame:CGRectMake(enddate.frame.origin.x + 65, enddate.frame.origin.y, 30, 15)];
                start.font = [UIFont fontWithName:@"Helvetica" size:12];
                end.font = [UIFont fontWithName:@"Helvetica" size:12];
                start.text = @"入住";
                end.text = @"离开";
                [start sizeToFit];
                [end sizeToFit];
                [cell.contentView addSubview:start];
                [cell.contentView addSubview:end];
                [cell.contentView addSubview:startdate];
                [cell.contentView addSubview:enddate];
                
                UILabel *user = [[UILabel alloc]initWithFrame:CGRectMake(180, 95, 30, 15)];
                user.font = [UIFont fontWithName:@"Helvetica" size:12];
                [cell.contentView addSubview:user];
                user.text = @"租客:";
                
                UILabel *username = [[UILabel alloc]initWithFrame:CGRectMake(user.frame.origin.x + 35, user.frame.origin.y, 60, 15)];
                [username setTag:6];
                username.font = [UIFont fontWithName:@"Helvetica" size:12];
                [cell.contentView addSubview:username];
                
                UILabel *status = [[UILabel alloc]initWithFrame:CGRectMake(200, 115, 110, 40)];
                [status setTextColor:[UIColor greenColor]];
                status.font = [UIFont fontWithName:@"Helvetica" size:20];
                status.text = @"待处理退款";
                [cell.contentView addSubview:status];
                
                [cell setFrame:CGRectMake(0, 0, MY_WIDTH, imgeV.frame.origin.y + imgeV.frame.size.height + 10)];
            }
//                cell = [nib objectAtIndex:4];
                break;
            case 5:
            {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseindentify];
                //添加横线
                UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(15, 35, MY_WIDTH - 30, 1)];
                line.image = [UIImage imageNamed:@"line"];
                [cell addSubview:line];

                UILabel *titlelabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, MY_WIDTH - 30, 30)];
                [titlelabel setTag:1];
                [cell.contentView addSubview:titlelabel];
                
                UIImageView *imgeV = [[UIImageView alloc]initWithFrame:CGRectMake(15, 40, 155, 120)];
                [imgeV setTag:2];
                [cell.contentView addSubview:imgeV];
                
                UILabel *room = [[UILabel alloc]initWithFrame:CGRectMake(180, 40, 30, 15)];
                room.text = @"房号：";
                room.font = [UIFont fontWithName:@"Helvetica" size:12];
                [room sizeToFit];
                [cell.contentView addSubview:room];
                
                UILabel *roomid = [[UILabel alloc]initWithFrame:CGRectMake(215, 40, 80, 15)];
                roomid.font = [UIFont fontWithName:@"Helvetica" size:11];
                [roomid setTag:3];
                [cell.contentView addSubview:roomid];
                
                UILabel *startdate = [[UILabel alloc]initWithFrame:CGRectMake(180, 60, 60, 15)];
                startdate.font = [UIFont fontWithName:@"Helvetica" size:10];
                [startdate setTag:4];
                UILabel *enddate = [[UILabel alloc]initWithFrame:CGRectMake(180, 75, 60, 15)];
                enddate.font = [UIFont fontWithName:@"Helvetica" size:10];
                [enddate setTag:5];
                
                UILabel *start = [[UILabel alloc]initWithFrame:CGRectMake(startdate.frame.origin.x + 65, startdate.frame.origin.y, 30, 15)];
                UILabel *end = [[UILabel alloc]initWithFrame:CGRectMake(enddate.frame.origin.x + 65, enddate.frame.origin.y, 30, 15)];
                start.font = [UIFont fontWithName:@"Helvetica" size:12];
                end.font = [UIFont fontWithName:@"Helvetica" size:12];
                start.text = @"入住";
                end.text = @"离开";
                [start sizeToFit];
                [end sizeToFit];
                [cell.contentView addSubview:start];
                [cell.contentView addSubview:end];
                [cell.contentView addSubview:startdate];
                [cell.contentView addSubview:enddate];
                
                UILabel *user = [[UILabel alloc]initWithFrame:CGRectMake(180, 95, 30, 15)];
                user.font = [UIFont fontWithName:@"Helvetica" size:12];
                [cell.contentView addSubview:user];
                user.text = @"租客:";
                
                UILabel *username = [[UILabel alloc]initWithFrame:CGRectMake(user.frame.origin.x + 35, user.frame.origin.y, 60, 15)];
                [username setTag:6];
                username.font = [UIFont fontWithName:@"Helvetica" size:12];
                [cell.contentView addSubview:username];
                
                UILabel *status = [[UILabel alloc]initWithFrame:CGRectMake(200, 115, 110, 40)];
                [status setTextColor:[UIColor blackColor]];
                status.font = [UIFont fontWithName:@"Helvetica" size:20];
                status.text = @"已退款";
                [cell.contentView addSubview:status];
                
                [cell setFrame:CGRectMake(0, 0, MY_WIDTH, imgeV.frame.origin.y + imgeV.frame.size.height + 10)];
            }
//                cell = [nib objectAtIndex:5];
                break;
            case 6:{
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseindentify];
                //添加横线
                UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(15, 35,MY_WIDTH - 30, 1)];
                line.image = [UIImage imageNamed:@"line"];
                [cell addSubview:line];

                UILabel *titlelabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, MY_WIDTH - 30, 30)];
                [titlelabel setTag:1];
                [cell.contentView addSubview:titlelabel];
                
                UIImageView *imgeV = [[UIImageView alloc]initWithFrame:CGRectMake(15, 40, 155, 120)];
                [imgeV setTag:2];
                [cell.contentView addSubview:imgeV];
                
                UILabel *room = [[UILabel alloc]initWithFrame:CGRectMake(180, 40, 30, 15)];
                room.text = @"房号：";
                room.font = [UIFont fontWithName:@"Helvetica" size:12];
                [room sizeToFit];
                [cell.contentView addSubview:room];
                
                UILabel *roomid = [[UILabel alloc]initWithFrame:CGRectMake(215, 40, 80, 15)];
                roomid.font = [UIFont fontWithName:@"Helvetica" size:11];
                [roomid setTag:3];
                [cell.contentView addSubview:roomid];
                
                UILabel *startdate = [[UILabel alloc]initWithFrame:CGRectMake(180, 60, 60, 15)];
                startdate.font = [UIFont fontWithName:@"Helvetica" size:10];
                [startdate setTag:4];
                UILabel *enddate = [[UILabel alloc]initWithFrame:CGRectMake(180, 75, 60, 15)];
                enddate.font = [UIFont fontWithName:@"Helvetica" size:10];
                [enddate setTag:5];
                
                UILabel *start = [[UILabel alloc]initWithFrame:CGRectMake(startdate.frame.origin.x + 65, startdate.frame.origin.y, 30, 15)];
                UILabel *end = [[UILabel alloc]initWithFrame:CGRectMake(enddate.frame.origin.x + 65, enddate.frame.origin.y, 30, 15)];
                start.font = [UIFont fontWithName:@"Helvetica" size:12];
                end.font = [UIFont fontWithName:@"Helvetica" size:12];
                start.text = @"入住";
                end.text = @"离开";
                [start sizeToFit];
                [end sizeToFit];
                [cell.contentView addSubview:start];
                [cell.contentView addSubview:end];
                [cell.contentView addSubview:startdate];
                [cell.contentView addSubview:enddate];
                
                UILabel *user = [[UILabel alloc]initWithFrame:CGRectMake(180, 95, 30, 15)];
                user.font = [UIFont fontWithName:@"Helvetica" size:12];
                [cell.contentView addSubview:user];
                user.text = @"租客:";
                
                UILabel *username = [[UILabel alloc]initWithFrame:CGRectMake(user.frame.origin.x + 35, user.frame.origin.y, 60, 15)];
                [username setTag:6];
                username.font = [UIFont fontWithName:@"Helvetica" size:12];
                [cell.contentView addSubview:username];
                
                UILabel *status = [[UILabel alloc]initWithFrame:CGRectMake(200, 115, 110, 40)];
                [status setTextColor:[UIColor greenColor]];
                status.font = [UIFont fontWithName:@"Helvetica" size:20];
                status.text = @"已拒绝";
                [cell.contentView addSubview:status];
                
                [cell setFrame:CGRectMake(0, 0, MY_WIDTH, imgeV.frame.origin.y + imgeV.frame.size.height + 10)];
            }
//                cell = [nib objectAtIndex:6];
                break;
            case 7:
            {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseindentify];
                //添加横线
                UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(15, 35, MY_WIDTH - 30, 1)];
                line.image = [UIImage imageNamed:@"line"];
                [cell addSubview:line];

                UILabel *titlelabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, MY_WIDTH - 30, 30)];
                [titlelabel setTag:1];
                [cell.contentView addSubview:titlelabel];
                
                UIImageView *imgeV = [[UIImageView alloc]initWithFrame:CGRectMake(15, 40, 155, 120)];
                [imgeV setTag:2];
                [cell.contentView addSubview:imgeV];
                
                UILabel *room = [[UILabel alloc]initWithFrame:CGRectMake(180, 40, 30, 15)];
                room.text = @"房号：";
                room.font = [UIFont fontWithName:@"Helvetica" size:12];
                [room sizeToFit];
                [cell.contentView addSubview:room];
                
                UILabel *roomid = [[UILabel alloc]initWithFrame:CGRectMake(215, 40, 80, 15)];
                roomid.font = [UIFont fontWithName:@"Helvetica" size:11];
                [roomid setTag:3];
                [cell.contentView addSubview:roomid];
                
                UILabel *startdate = [[UILabel alloc]initWithFrame:CGRectMake(180, 60, 60, 15)];
                startdate.font = [UIFont fontWithName:@"Helvetica" size:10];
                [startdate setTag:4];
                UILabel *enddate = [[UILabel alloc]initWithFrame:CGRectMake(180, 75, 60, 15)];
                enddate.font = [UIFont fontWithName:@"Helvetica" size:10];
                [enddate setTag:5];
                
                UILabel *start = [[UILabel alloc]initWithFrame:CGRectMake(startdate.frame.origin.x + 65, startdate.frame.origin.y, 30, 15)];
                UILabel *end = [[UILabel alloc]initWithFrame:CGRectMake(enddate.frame.origin.x + 65, enddate.frame.origin.y, 30, 15)];
                start.font = [UIFont fontWithName:@"Helvetica" size:12];
                end.font = [UIFont fontWithName:@"Helvetica" size:12];
                start.text = @"入住";
                end.text = @"离开";
                [start sizeToFit];
                [end sizeToFit];
                [cell.contentView addSubview:start];
                [cell.contentView addSubview:end];
                [cell.contentView addSubview:startdate];
                [cell.contentView addSubview:enddate];
                
                UILabel *user = [[UILabel alloc]initWithFrame:CGRectMake(180, 95, 30, 15)];
                user.font = [UIFont fontWithName:@"Helvetica" size:12];
                [cell.contentView addSubview:user];
                user.text = @"租客:";
                
                UILabel *username = [[UILabel alloc]initWithFrame:CGRectMake(user.frame.origin.x + 35, user.frame.origin.y, 60, 15)];
                [username setTag:6];
                username.font = [UIFont fontWithName:@"Helvetica" size:12];
                [cell.contentView addSubview:username];
                
                UILabel *status = [[UILabel alloc]initWithFrame:CGRectMake(190, 115, 120, 40)];
                [status setTextColor:[UIColor blackColor]];
                status.font = [UIFont fontWithName:@"Helvetica" size:20];
                status.text = @"已过确认时间";
                [cell.contentView addSubview:status];
                
                [cell setFrame:CGRectMake(0, 0, MY_WIDTH, imgeV.frame.origin.y + imgeV.frame.size.height + 10)];
            }
                
//                cell = [nib objectAtIndex:7];
                break;
            case 8:
            {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseindentify];
                //添加横线
                UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(15, 35, MY_WIDTH - 30, 1)];
                line.image = [UIImage imageNamed:@"line"];
                [cell addSubview:line];

                UILabel *titlelabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, MY_WIDTH - 30, 30)];
                [titlelabel setTag:1];
                [cell.contentView addSubview:titlelabel];
                
                UIImageView *imgeV = [[UIImageView alloc]initWithFrame:CGRectMake(15, 40, 155, 120)];
                [imgeV setTag:2];
                [cell.contentView addSubview:imgeV];
                
                UILabel *room = [[UILabel alloc]initWithFrame:CGRectMake(180, 40, 30, 15)];
                room.text = @"房号：";
                room.font = [UIFont fontWithName:@"Helvetica" size:12];
                [room sizeToFit];
                [cell.contentView addSubview:room];
                
                UILabel *roomid = [[UILabel alloc]initWithFrame:CGRectMake(215, 40, 80, 15)];
                roomid.font = [UIFont fontWithName:@"Helvetica" size:11];
                [roomid setTag:3];
                [cell.contentView addSubview:roomid];
                
                UILabel *startdate = [[UILabel alloc]initWithFrame:CGRectMake(180, 60, 60, 15)];
                startdate.font = [UIFont fontWithName:@"Helvetica" size:10];
                [startdate setTag:4];
                UILabel *enddate = [[UILabel alloc]initWithFrame:CGRectMake(180, 75, 60, 15)];
                enddate.font = [UIFont fontWithName:@"Helvetica" size:10];
                [enddate setTag:5];
                
                UILabel *start = [[UILabel alloc]initWithFrame:CGRectMake(startdate.frame.origin.x + 65, startdate.frame.origin.y, 30, 15)];
                UILabel *end = [[UILabel alloc]initWithFrame:CGRectMake(enddate.frame.origin.x + 65, enddate.frame.origin.y, 30, 15)];
                start.font = [UIFont fontWithName:@"Helvetica" size:12];
                end.font = [UIFont fontWithName:@"Helvetica" size:12];
                start.text = @"入住";
                end.text = @"离开";
                [start sizeToFit];
                [end sizeToFit];
                [cell.contentView addSubview:start];
                [cell.contentView addSubview:end];
                [cell.contentView addSubview:startdate];
                [cell.contentView addSubview:enddate];
                
                UILabel *user = [[UILabel alloc]initWithFrame:CGRectMake(180, 95, 30, 15)];
                user.font = [UIFont fontWithName:@"Helvetica" size:12];
                [cell.contentView addSubview:user];
                user.text = @"租客:";
                
                UILabel *username = [[UILabel alloc]initWithFrame:CGRectMake(user.frame.origin.x + 35, user.frame.origin.y, 60, 15)];
                [username setTag:6];
                username.font = [UIFont fontWithName:@"Helvetica" size:12];
                [cell.contentView addSubview:username];
                
                UILabel *status = [[UILabel alloc]initWithFrame:CGRectMake(190, 115, 120, 40)];
                [status setTextColor:[UIColor greenColor]];
                status.font = [UIFont fontWithName:@"Helvetica" size:20];
                status.text = @"可以收取定金";
                [cell.contentView addSubview:status];
                
                [cell setFrame:CGRectMake(0, 0, MY_WIDTH, imgeV.frame.origin.y + imgeV.frame.size.height + 10)];
            }
//                cell = [nib objectAtIndex:8];
                break;
            case 9:
            {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseindentify];
                //添加横线
                UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(15, 35, MY_WIDTH - 30, 1)];
                line.image = [UIImage imageNamed:@"line"];
                [cell addSubview:line];

                UILabel *titlelabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, MY_WIDTH - 30, 30)];
                [titlelabel setTag:1];
                titlelabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
                [cell.contentView addSubview:titlelabel];
                
                UIImageView *imgeV = [[UIImageView alloc]initWithFrame:CGRectMake(15, 40, 155, 120)];
                [imgeV setTag:2];
                [cell.contentView addSubview:imgeV];
                
                //房间编号
                UILabel *room = [[UILabel alloc]initWithFrame:CGRectMake(180, 40, 30, 15)];
                room.text = @"房间编号：";
                room.font = [UIFont fontWithName:@"Helvetica" size:12];
                room.textColor = [UIColor blackColor];
                [room sizeToFit];
                [cell.contentView addSubview:room];
                
                UILabel *roomid = [[UILabel alloc]initWithFrame:CGRectMake(185 + room.frame.size.width, 40, 80, 15)];
                roomid.textColor = [UIColor blackColor];
                roomid.font = [UIFont fontWithName:@"Helvetica" size:11];
                [roomid setTag:3];
                [cell.contentView addSubview:roomid];
                
                //房间别名
                UILabel *roomt = [[UILabel alloc]initWithFrame:CGRectMake(180, 60, 30, 15)];
                roomt.text = @"房间别名：";
                roomt.textColor = [UIColor blackColor];
                roomt.font = [UIFont fontWithName:@"Helvetica" size:12];
                [roomt sizeToFit];
                [cell.contentView addSubview:roomt];
                
                UILabel *roomtitle = [[UILabel alloc]initWithFrame:CGRectMake(185 + roomt.frame.size.width, roomt.frame.origin.y, 90, 15)];
                roomtitle.textColor = [UIColor blackColor];
                roomtitle.font = [UIFont fontWithName:@"Helvetica" size:12];
                [roomtitle setTag:4];
                [cell.contentView addSubview:roomtitle];
                
                UILabel *location = [[UILabel alloc]initWithFrame:CGRectMake(imgeV.left, imgeV.bottom + 5, 50, 15)];
                location.text = @"地理位置:";
                location.textColor = [UIColor blackColor];
                location.font = [UIFont fontWithName:@"Helvetica" size:12];
                [location sizeToFit];
                [cell.contentView addSubview:location];
                
                UILabel *address = [[UILabel alloc]initWithFrame:CGRectMake(location.right + 5, location.top, MY_WIDTH - location.right - 10, 15)];
                address.textColor = [UIColor blackColor];
                [address setTag:5];
                address.font = [UIFont fontWithName:@"Helvetica" size:12];
                [cell.contentView addSubview:address];
                
                UILabel *statu = [[UILabel alloc]initWithFrame:CGRectMake(180, roomt.bottom + 15, 50, 15)];
                statu.text = @"房间状态:";
                statu.textColor = [UIColor  blackColor];
                statu.font = [UIFont fontWithName:@"Helvetica" size:12];
                [statu sizeToFit];
                [cell.contentView addSubview:statu];
                
                UILabel *status = [[UILabel alloc]initWithFrame:CGRectMake(185 + statu.frame.size.width, statu.frame.origin.y - 8, 70, 30)];
                [status setTag:6];
                status.textColor = [UIColor blueColor];
                status.font = [UIFont fontWithName:@"Helvetica" size:15];
                [cell.contentView addSubview:status];
                
                UILabel *price = [[UILabel alloc]initWithFrame:CGRectMake(180, status.frame.size.height + status.frame.origin.y + 5, 50, 15)];
                price.text = @"默认价格: ￥";
                price.textColor = [UIColor blackColor];
                price.font = [UIFont fontWithName:@"Helvetica" size:12];
                [price sizeToFit];
                [cell.contentView addSubview:price];
                
                UILabel *cash = [[UILabel alloc]initWithFrame:CGRectMake(185 + price.frame.size.width, price.frame.origin.y - 8, 40, 30)];
                [cash setTag:7];
                cash.textColor = [UIColor orangeColor];
                cash.font = [UIFont fontWithName:@"Helvetica" size:15];
                [cell.contentView addSubview:cash];
                
                UILabel *last = [[UILabel alloc]initWithFrame:CGRectMake(cash.frame.origin.x  + cash.frame.size.width , price.frame.origin.y - 8, 30, 30)];
                last.text = @"/晚";
                last.textColor = [UIColor blackColor];
                [last setTag:99];
                last.font = [UIFont fontWithName:@"Helvetica" size:12];
                [cell addSubview:last];
                
                UILabel *num = [[UILabel alloc]initWithFrame:CGRectMake(180, cash.frame.size.height + cash.frame.origin.y , 50, 15)];
                num.text = @"默认数量：";
                num.textColor = [UIColor blackColor];
                num.font = [UIFont fontWithName:@"Helvetica" size:12];
                [num sizeToFit];
                [cell.contentView addSubview:num];
                
                UILabel *numberOfRoom = [[UILabel alloc]initWithFrame:CGRectMake(185 + num.frame.size.width, num.frame.origin.y, 40, 15)];
                [numberOfRoom setTag:8];
                numberOfRoom.textColor = [UIColor blackColor];
                numberOfRoom.font = [UIFont fontWithName:@"Helvetica" size:15];
                [cell.contentView addSubview:numberOfRoom];
                
                 [cell setFrame:CGRectMake(0, 0, MY_WIDTH, location.bottom + 10)];
            }
//                cell = [nib objectAtIndex:9];
                break;
            default:
                NSLog(@"订单列表加载出错");
                break;
        }
        
        
//    }
    NSDictionary *dic = _fakeData[indexPath.row];
    UILabel *titlelabel;
    titlelabel = (UILabel *)[cell viewWithTag:1];
     NSString *title =[NSString stringWithFormat:@"%@",[dic valueForKey:@"title"]];
    titlelabel.text = title;
    UIImageView *imageView;
    imageView = (UIImageView *)[cell viewWithTag:2];
//    [cell.imageView setImage:[UIImage imageNamed:@"button"]];
//    [cell.imageView performSelector:(@selector(setImageWithURL:)) withObject:[NSURL URLWithString:[dic valueForKey:@"picurl"]] afterDelay:0];
    [imageView setImage:[UIImage imageNamed:@"backgroud"]];
    [imageView performSelector:@selector(setImageWithURL:) withObject:[NSURL URLWithString:[dic valueForKey:@"picurl"]]];
//    [cell.imageView setImageWithURL:[NSURL URLWithString:[dic valueForKey:@"picurl"]]];
//    [imageView setImageWithURL:[NSURL URLWithString:[dic valueForKey:@"picurl"]]];
    switch (_number) {
        case 0:{
            //待确认订单加载
            UILabel *numberOfPeopleLabel;
            numberOfPeopleLabel = (UILabel *)[cell viewWithTag:3];
            UILabel *numberOfRoomLabel;
            numberOfRoomLabel = (UILabel *)[cell viewWithTag:4];
            UILabel *orderIdLabel;
            orderIdLabel = (UILabel *)[cell viewWithTag:5];
            UILabel *inDateLabel;
            inDateLabel = (UILabel *)[cell viewWithTag:6];
            UILabel *outDateLabel;
            outDateLabel = (UILabel *)[cell viewWithTag:7];
            UILabel *total_PriceLabel;
            total_PriceLabel = (UILabel *)[cell viewWithTag:8];
            UILabel *prepay_PriceLabel;
            prepay_PriceLabel = (UILabel *)[cell viewWithTag:9];
            UILabel *last_PriceLabel;
            last_PriceLabel = (UILabel *)[cell viewWithTag:10];
            NSString *numberOfPeople =[NSString stringWithFormat:@"%@",[dic valueForKey:@"rentnumber"]];
            NSString *numberOfRoom = [NSString stringWithFormat:@"%@",[dic valueForKey:@"sameroom"]];
            NSString *orderId = [NSString stringWithFormat:@"%@",[dic valueForKey:@"ordernum"]];
            NSString *inDate = [NSString stringWithFormat:@"%@",[dic valueForKey:@"start_date"]];
            NSString *outDate =[NSString stringWithFormat:@"%@",[dic valueForKey:@"end_date"]];
            NSString *total_Price = [NSString stringWithFormat:@"%5.1f",[[dic valueForKey:@"total_price"] floatValue]];
            NSString *prepay_Price = [NSString stringWithFormat:@"%5.1f",[[dic valueForKey:@"prepay_price"] floatValue]];
            NSString *last_Price = [NSString stringWithFormat:@"%5.1f",[total_Price floatValue ] - [prepay_Price floatValue]];
            numberOfPeopleLabel.text = numberOfPeople;
            numberOfRoomLabel.text = numberOfRoom;
            orderIdLabel.text =orderId;
            [orderIdLabel sizeToFit];
            inDateLabel.text = inDate;
            outDateLabel.text = outDate;
            total_PriceLabel.text = total_Price;
            prepay_PriceLabel.text = prepay_Price;
            last_PriceLabel.text =last_Price;
        }
            break;
        case 1:
        {
            UILabel *orderIdLabel;
            orderIdLabel = (UILabel *)[cell viewWithTag:3];
            UILabel *inDateLabel;
            inDateLabel = (UILabel *)[cell viewWithTag:4];
            UILabel *outDateLabel;
            outDateLabel = (UILabel *)[cell viewWithTag:5];
            UILabel *total_PriceLabel;
            total_PriceLabel = (UILabel *)[cell viewWithTag:6];
            NSString *orderId = [NSString stringWithFormat:@"%@",[dic valueForKey:@"ordernum"]];
            NSString *inDate = [NSString stringWithFormat:@"%@",[dic valueForKey:@"start_date"]];
            NSString *outDate =[NSString stringWithFormat:@"%@",[dic valueForKey:@"end_date"]];
            NSString *total_Price = [NSString stringWithFormat:@"金额￥：%5.1f",[[dic valueForKey:@"total_price"] floatValue]];
            orderIdLabel.text =orderId;
            [orderIdLabel sizeToFit];
            inDateLabel.text = inDate;
            outDateLabel.text = outDate;
            total_PriceLabel.text = total_Price;
        }
            break;
        case 2:{
            UILabel *orderIdLabel;
            orderIdLabel = (UILabel *)[cell viewWithTag:3];
            NSString *orderId = [NSString stringWithFormat:@"%@",[dic valueForKey:@"ordernum"]];
            orderIdLabel.text =orderId;
            [orderIdLabel sizeToFit];
            
            UILabel *inDateLabel;
            inDateLabel = (UILabel *)[cell viewWithTag:4];
            UILabel *outDateLabel;
            outDateLabel = (UILabel *)[cell viewWithTag:5];
            NSString *inDate = [NSString stringWithFormat:@"%@",[dic valueForKey:@"start_date"]];
            NSString *outDate =[NSString stringWithFormat:@"%@",[dic valueForKey:@"end_date"]];
            inDateLabel.text = inDate;
            outDateLabel.text = outDate;
            UILabel *userNamelabel;//名字错误为入驻人数
            userNamelabel = (UILabel *)[cell viewWithTag:6];
            NSString *username = [NSString stringWithFormat:@"%@",[dic valueForKey:@"rentnumber"]];
            userNamelabel.text =username;
            [userNamelabel sizeToFit];//自适应修改显示不全的bug
            
            UILabel *numberOfPeopleLabel;
            numberOfPeopleLabel = (UILabel *)[cell viewWithTag:7];
            NSString *numberOfPeople =[NSString stringWithFormat:@"%@",[dic valueForKey:@"sameroom"]];
            numberOfPeopleLabel.text = numberOfPeople;
            [numberOfPeopleLabel sizeToFit];
            
            UILabel *last_PriceLabel;
            last_PriceLabel = (UILabel *)[cell viewWithTag:8];
            NSString *total_Price = [NSString stringWithFormat:@"%5.1f",[[dic valueForKey:@"total_price"] floatValue]];
            NSString *prepay_Price = [NSString stringWithFormat:@"%5.1f",[[dic valueForKey:@"prepay_price"] floatValue]];
            NSString *last_Price = [NSString stringWithFormat:@"%5.1f",[total_Price floatValue ] - [prepay_Price floatValue]];
            last_PriceLabel.text = last_Price;
        }
         
            break;
        case 3:{
            UILabel *numberLabel;
            numberLabel = (UILabel *)[cell viewWithTag:3];
            UILabel *inlabel;
            inlabel = (UILabel *)[cell viewWithTag:4];
            UILabel *outlabel;
            outlabel = (UILabel *)[cell viewWithTag:5];
            UILabel *userNamelabel;
            userNamelabel = (UILabel *)[cell viewWithTag:6];
            
            
            NSString *number =[NSString stringWithFormat:@"%@",[dic valueForKey:@"room_id"]];
            NSString *indate = [NSString stringWithFormat:@"%@",[dic valueForKey:@"start_date"]];
            NSString *outdate = [NSString stringWithFormat:@"%@",[dic valueForKey:@"end_date"]];
            NSString *username = [NSString stringWithFormat:@"%@",[dic valueForKey:@"username"]];
            numberLabel.text =number;
            
            inlabel.text =indate;
            outlabel.text = outdate;
            userNamelabel.text =username;
        }
            break;
        case 4:{
            UILabel *numberLabel;
            numberLabel = (UILabel *)[cell viewWithTag:3];
            UILabel *inlabel;
            inlabel = (UILabel *)[cell viewWithTag:4];
            UILabel *outlabel;
            outlabel = (UILabel *)[cell viewWithTag:5];
            UILabel *userNamelabel;
            userNamelabel = (UILabel *)[cell viewWithTag:6];
            
            
            NSString *number =[NSString stringWithFormat:@"%@",[dic valueForKey:@"room_id"]];
            NSString *indate = [NSString stringWithFormat:@"%@",[dic valueForKey:@"start_date"]];
            NSString *outdate = [NSString stringWithFormat:@"%@",[dic valueForKey:@"end_date"]];
            NSString *username = [NSString stringWithFormat:@"%@",[dic valueForKey:@"username"]];
            numberLabel.text =number;
            
            inlabel.text =indate;
            outlabel.text = outdate;
            userNamelabel.text =username;
        }
            break;
        case 5:{
            UILabel *numberLabel;
            numberLabel = (UILabel *)[cell viewWithTag:3];
            UILabel *inlabel;
            inlabel = (UILabel *)[cell viewWithTag:4];
            UILabel *outlabel;
            outlabel = (UILabel *)[cell viewWithTag:5];
            UILabel *userNamelabel;
            userNamelabel = (UILabel *)[cell viewWithTag:6];
            
            
            NSString *number =[NSString stringWithFormat:@"%@",[dic valueForKey:@"room_id"]];
            NSString *indate = [NSString stringWithFormat:@"%@",[dic valueForKey:@"start_date"]];
            NSString *outdate = [NSString stringWithFormat:@"%@",[dic valueForKey:@"end_date"]];
            NSString *username = [NSString stringWithFormat:@"%@",[dic valueForKey:@"username"]];
            numberLabel.text =number;
            
            inlabel.text =indate;
            outlabel.text = outdate;
            userNamelabel.text =username;
        }
          
            break;
        case 6:{
            UILabel *numberLabel;
            numberLabel = (UILabel *)[cell viewWithTag:3];
            UILabel *inlabel;
            inlabel = (UILabel *)[cell viewWithTag:4];
            UILabel *outlabel;
            outlabel = (UILabel *)[cell viewWithTag:5];
            UILabel *userNamelabel;
            userNamelabel = (UILabel *)[cell viewWithTag:6];
            
            
            NSString *number =[NSString stringWithFormat:@"%@",[dic valueForKey:@"room_id"]];
            NSString *indate = [NSString stringWithFormat:@"%@",[dic valueForKey:@"start_date"]];
            NSString *outdate = [NSString stringWithFormat:@"%@",[dic valueForKey:@"end_date"]];
            NSString *username = [NSString stringWithFormat:@"%@",[dic valueForKey:@"username"]];
            numberLabel.text =number;
            
            inlabel.text =indate;
            outlabel.text = outdate;
            userNamelabel.text =username;
        }
           
            break;
        case 7:
        {
            UILabel *numberLabel ;
            numberLabel = (UILabel *)[cell viewWithTag:3];
            UILabel *inlabel;
            inlabel = (UILabel *)[cell viewWithTag:4];
            UILabel *outlabel;
            outlabel = (UILabel *)[cell viewWithTag:5];
            UILabel *userNamelabel;
            userNamelabel = (UILabel *)[cell viewWithTag:6];
            
            
            NSString *number =[NSString stringWithFormat:@"%@",[dic valueForKey:@"room_id"]];
            NSString *indate = [NSString stringWithFormat:@"%@",[dic valueForKey:@"start_date"]];
            NSString *outdate = [NSString stringWithFormat:@"%@",[dic valueForKey:@"end_date"]];
            NSString *username = [NSString stringWithFormat:@"%@",[dic valueForKey:@"username"]];
            numberLabel.text =number;
            
            inlabel.text =indate;
            outlabel.text = outdate;
            userNamelabel.text =username;
        }
            break;
        case 8:
        {
            UILabel *numberLabel;
            numberLabel = (UILabel *)[cell viewWithTag:3];
            UILabel *inlabel;
            inlabel = (UILabel *)[cell viewWithTag:4];
            UILabel *outlabel;
            outlabel = (UILabel *)[cell viewWithTag:5];
            UILabel *userNamelabel;
            userNamelabel = (UILabel *)[cell viewWithTag:6];
            
            
            NSString *number =[NSString stringWithFormat:@"%@",[dic valueForKey:@"room_id"]];
            NSString *indate = [NSString stringWithFormat:@"%@",[dic valueForKey:@"start_date"]];
            NSString *outdate = [NSString stringWithFormat:@"%@",[dic valueForKey:@"end_date"]];
            NSString *username = [NSString stringWithFormat:@"%@",[dic valueForKey:@"username"]];
            numberLabel.text =number;
            
            inlabel.text =indate;
            outlabel.text = outdate;
            userNamelabel.text =username;
        }
            break;
        case 9:{
            UILabel *roomIdLabel;
            roomIdLabel = (UILabel *)[cell viewWithTag:3];
            NSString *roomId = [NSString stringWithFormat:@"%@",[dic valueForKey:@"roomid"]];
            roomIdLabel.text = roomId;
            UILabel *title2Label;
            title2Label = (UILabel*)[cell viewWithTag:4];
            NSString *title2 = [NSString stringWithFormat:@"%@",[dic valueForKey:@"title2"]];
            title2Label.text = title2;
            UILabel *addressLabel;
            addressLabel = (UILabel *)[cell viewWithTag:5];
            NSString *address = [NSString stringWithFormat:@"%@",[dic valueForKey:@"address"]];
            addressLabel.text =address;
            [addressLabel sizeToFit];
            UILabel *statusOfRoomLabel;
            statusOfRoomLabel = (UILabel*)[cell viewWithTag:6];
            NSString *status =[NSString stringWithFormat:@"%@",[dic valueForKey:@"status"]];
            NSString *statusOfRoom;
            if ([status isEqualToString:@"1"]) {
                statusOfRoom = @"上线";
            }
            else{
                statusOfRoom = @"非上线";
            }
            statusOfRoomLabel.text = statusOfRoom;
            UILabel *numOfRoomLabel;
            numOfRoomLabel = (UILabel*)[cell viewWithTag:8];
            NSString *numOfRoom = [NSString stringWithFormat:@"%@",[dic valueForKey:@"sameroom"]];
            numOfRoomLabel.text = numOfRoom;
            UILabel *priceDayLabel;
            priceDayLabel = (UILabel *)[cell viewWithTag:7];
            NSString *priceDay = [NSString stringWithFormat:@"%@",[dic valueForKey:@"priceday"]];
            priceDayLabel.text = priceDay;
            UILabel *nightLabel;
            nightLabel = (UILabel *)[cell viewWithTag:99];
            [nightLabel setFrame:CGRectMake(priceDayLabel.frame.origin.x + priceDayLabel.text.length * 6 + 10, nightLabel.frame.origin.y, 30, 30)];
        }
            break;
        default:
          
            break;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath: [tableView indexPathForSelectedRow] animated:YES];
    iuiueAllService *service1 = [[iuiueAllService alloc]init];
    if (![service1 isConnectionAvailable]) {
        [[UIApplication sharedApplication].keyWindow makeToast:@"网络连接失败...请检查网络设置" duration:1 position:@"center"];
        return;
    }
    if (self.number == 9) {
        NSDictionary *dic = _fakeData[indexPath.row];
        NSString *roomId = [NSString stringWithFormat:@"%@",[dic valueForKey:@"roomid"]];
        iuiueRoomManageViewController *room = [[iuiueRoomManageViewController alloc]init];
        room.roomId = roomId;
        room.location = [NSString stringWithFormat:@"%@",[dic valueForKey:@"address"]];
        room.roomName = [NSString stringWithFormat:@"%@",[dic valueForKeyPath:@"title"]];
        [self.navigationController pushViewController:room animated:YES];
    }
    else{
        iuiueOrderDetailViewController *detailVC = [[iuiueOrderDetailViewController alloc]init];
        detailVC.dic = _fakeData[indexPath.row];
        detailVC.number = self.number;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}


//-(NSMutableArray *)getorderarray{
//    
//    iuiueAllService *service = [[iuiueAllService alloc]init];
//    NSString *num =[NSString stringWithFormat:@"%ld",_number + 1];
//    NSString *page = [NSString stringWithFormat:@"%ld",(long)pages];
//    [service orderlistDictionaryInit:[NSDictionary dictionaryWithObjectsAndKeys:num,@"status",page,@"page",nil]];
//    NSArray *array = [service.diction valueForKey:@"list"];
//    NSMutableArray *addarray = [NSMutableArray array];
//    for (id _id in array) {
//        [addarray addObject:_id];
//    }
//    pages++;
//    return addarray;
//}

-(void)getOrderArray:(BOOL) UpDown{
    
    NSMutableDictionary *usernamepasswordKVPairs = (NSMutableDictionary *)[iuiueCHKeychain load:KEYCHAIN_USERNAMEPASSWORD];
    NSString *uid =[usernamepasswordKVPairs objectForKey:KEYCHAIN_UID];
    NSString *zend = [usernamepasswordKVPairs objectForKey:KEYCHAIN_ZEND];
    
    if (self.number == 9) {
        request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:URL_MY_ROOMS]];
        //全部房源
        [request addPostValue:@"0" forKey:@"status"];
    }else{
        request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:URL_ORDER_LIST]];
        NSString *num =[NSString stringWithFormat:@"%d",_number + 1];
        [request addPostValue:num forKey:@"status"];
    }
    request.requestMethod = @"POST";
    
    
    NSString *page = [NSString stringWithFormat:@"%ld",(long)pages];
    
    [request addPostValue:page forKey:@"page"];
    [request addPostValue:uid forKey:@"uid"];
    [request addPostValue:zend forKey:@"zend"];
    
    
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
                        [_fakeData addObjectsFromArray:ListArray];
                        [self.tableView reloadData];
                    }
                    else{
                        NSLog(@"5");
                        [_fakeData removeAllObjects];
                        [_fakeData addObjectsFromArray:ListArray];
                        [self.tableView reloadData];
                    }
//                    if (_fakeData.count == 0) {
//                        UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(60,100 , 147, 183)];
//                        imageV.image = [UIImage imageNamed:@"bg_tishi"];
//                        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(imageV.left, imageV.bottom + 5, imageV.width, 30)];
//                        label.textColor = [UIColor orangeColor];
//                        label.text = @"亲，该类别没有找到订单哦~";
//                        [self.tableView.tableFooterView addSubview:imageV];
//                        [self.tableView.tableFooterView addSubview:label];
//                    }
                    
                    //滚动到初始位置
//                    CGPoint position = CGPointMake(0 , -64);
//                    [self.tableView setContentOffset:position animated:YES];

                    if (_number == 9) {
                        NSString *str = [NSString stringWithFormat:@"我的房间(%@套)",resultDict[@"count"]];
                        self.navigationItem.title = str;
                    }
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
    
    [request setFailedBlock:^{
        NSLog(@"%@",[request.error localizedDescription]);
        [_header endRefreshing];
        [_footer endRefreshing];
        hud.labelText = @"加载失败。。";
        [hud hide:YES];
        
    }];

    //异步加载
    NSLog(@"4");
    [request startAsynchronous];

}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}


-(IBAction)ordercanpay:(id)sender{
    iuiueAllService *service1 = [[iuiueAllService alloc]init];
    if (![service1 isConnectionAvailable]) {
        [[UIApplication sharedApplication].keyWindow makeToast:@"网络连接失败...请检查网络设置" duration:1 position:@"center"];
        return;
    }
    UIButton *btn = (UIButton *)sender;
    if (btn.tag % 100000 == 0) {
        NSInteger row = btn.tag/100000;//获得row的行数
        NSLog(@"%d",btn.tag);
        NSDictionary *dic = _fakeData[row];
        NSLog(@"shuchu%@",[dic valueForKey:@"orderid" ]);
        NSLog(@"1");
        [self OrderCanPay:YES Row:row];
    }
    else{
        NSInteger row = btn.tag/100000;//获得row的行数
        [self.tableView reloadData];
        [self OrderCanPay:NO Row:row];
    }
}


-(void)OrderCanPay:(BOOL) CanPay Row:(NSInteger)Row{
    
    
    request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:URL_ORDER_CAN_PAY]];
    request.requestMethod = @"POST";
    NSDictionary *dic = _fakeData[Row];
    [request addPostValue:[dic valueForKey:@"orderid" ] forKey:@"orderid"];
    [request addPostValue:MY_UID forKey:@"uid"];
    [request addPostValue:MY_ZEND forKey:@"zend"];
    if (CanPay) {
        [request addPostValue:@"1" forKey:@"canpay"];
    }else{
        [request addPostValue:@"2" forKey:@"canpay"];
    }
    
    
    [request setCompletionBlock:^{
        NSLog(@"%@",request.responseString);
        NSError *error;
        NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingAllowFragments error:&error];
        if (!error) {
            switch ([resultDict[@"status"] integerValue]) {
                case 0:{
                    [hud hide:YES];
                    pages = 1;
                    NSLog(@"3");
                    [self getOrderArray:NO];
                    if (CanPay) {
                        [[UIApplication sharedApplication].keyWindow makeToast:@"接受订单成功" duration:1 position:@"center"];
                    }
                    else{
                        [[UIApplication sharedApplication].keyWindow makeToast:@"拒绝订单成功！"duration:1 position:@"center"];
                    }
                    
                    //滚动到初始位置
                    //                    CGPoint position = CGPointMake(0 , -64);
                    //                    [self.tableView setContentOffset:position animated:YES];
                    
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
                    [[UIApplication sharedApplication].keyWindow makeToast:resultDict[@"message"]];
                    break;
            }
        }else{
            NSLog(@"%@",[error localizedDescription]);
        }
    }];
    
    [request setFailedBlock:^{
        NSLog(@"%@",[request.error localizedDescription]);
        [_header endRefreshing];
        [_footer endRefreshing];
        hud.labelText = @"加载失败。。";
        [hud hide:YES];
        
    }];
    
    hud =
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"加载中...";
    
    //异步加载
    [request startAsynchronous];
    NSLog(@"2");
    
}








@end
