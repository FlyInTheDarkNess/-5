//
//  iuiueMyAppRaiseViewController.m
//  木鸟房东端
//
//  Created by 赵中良 on 14-7-22.
//  Copyright (c) 2014年 iuiue. All rights reserved.
//

#import "iuiueMyAppRaiseViewController.h"
#import "UIImageView+WebCache.h"//引入加载图片的头文件
#import "MJRefresh.h"
#import "iuiueMyView.h"
#import "iuiueAppReRaiseViewController.h"

@interface iuiueMyAppRaiseViewController ()<MJRefreshBaseViewDelegate,UITableViewDataSource,UITableViewDelegate,iuiueMyViewDelegate>
{
    UILabel *countLabel;
    UITableView *MyTableView;//列表view
    MJRefreshHeaderView *_header;
    MJRefreshFooterView *_footer;
    NSInteger pages;
    MBProgressHUD *hud;
    NSTimer *_timer;//添加线程
    NSMutableArray *MyArray;
    iuiueMyView *View;
    NSInteger RasiStarus; //评论状态 0,1，2
}

@end

@implementation iuiueMyAppRaiseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationItem.title = @"全部评论";
        UIBarButtonItem * right = [[UIBarButtonItem alloc]initWithTitle:@"分类" style:UIBarButtonItemStylePlain target:self action:@selector(addButton)];
        self.navigationItem.rightBarButtonItem = right;
//        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemUndo target:self action:@selector(addButton)];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //初始化
    MyArray = [NSMutableArray array];
    
    
    countLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, 20)];
    countLabel.backgroundColor = [UIColor blueColor];
    countLabel.textColor = [UIColor whiteColor];
    countLabel.textAlignment = NSTextAlignmentRight;
    countLabel.text = @"共有 待查询 条评论";
    
    //navigationbar.translut = yes;是透明的
    MyTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, countLabel.height,[UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - countLabel.height) style:UITableViewStylePlain];
    MyTableView.tableFooterView = [[UIView alloc]init];
    MyTableView.delegate = self;
    MyTableView.dataSource = self;
    
    [self.view addSubview:MyTableView];
    [self.view addSubview:countLabel];
    
    //添加刷新
    [self setFreshView];
    
    
    // Do any additional setup after loading the view.
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
        [self getAppRaise:NO];
        
    } else {
        
        [self getAppRaise:YES];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    [_header endRefreshing];
    [_footer endRefreshing];
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return MyArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *reuseIdentifier = @"reuseIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    //
//    if (!cell) {
    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    UITableViewCell *titleCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"titleCell"];
    
    NSDictionary *dic = MyArray[indexPath.row];
    NSString *titleStr = [NSString stringWithFormat:@"%@",dic[@"title"]];
    NSString *titledetailStr = [NSString stringWithFormat:@"(%@)",dic[@"ordernum"]];
    NSString *imageUrl = [NSString stringWithFormat:@"%@",dic[@"picurl"]];
    NSString *roomNumberStr = [NSString stringWithFormat:@"房间编号：%@",dic[@"roomid"]];
    NSString *userStr = [NSString stringWithFormat:@"房客昵称：%@",dic[@"username"]];
    
    
    
    //标题设置
    [titleCell setFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 50)];
    titleCell.backgroundColor = [UIColor clearColor];
    titleCell.selectionStyle = UITableViewCellEditingStyleNone;
    titleCell.textLabel.text = titleStr;
    titleCell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    titleCell.detailTextLabel.text = titledetailStr;
    
    //横线
    UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(titleCell.left + 15, titleCell.bottom, titleCell.width - 30, 1)];
    line.image = [UIImage imageNamed:@"line"];
    [cell.contentView addSubview:line];
    
    
    //加载详细信息
    UIFont *font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
    [cell.contentView addSubview:titleCell];
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(15, titleCell.bottom + 10, 130, 100)];
    imageV.image = [UIImage imageNamed:@"backgroud"];
    [imageV setImageWithURL:[NSURL URLWithString:imageUrl]];
    [cell.contentView addSubview:imageV];
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    UILabel *roomLabel = [[UILabel alloc]initWithFrame:CGRectMake(imageV.right + 10, titleCell.bottom + 10, titleCell.width - imageV.right - 10, 20)];
    roomLabel.text = roomNumberStr;
    roomLabel.font = font;
    UILabel *userLabel = [[UILabel alloc]initWithFrame:CGRectMake(roomLabel.left, roomLabel.bottom + 5, roomLabel.width, roomLabel.height)];
    userLabel.font = font;
    userLabel.text = userStr;
    UILabel *raiseLabel = [[UILabel alloc]initWithFrame:CGRectMake(userLabel.left, userLabel.bottom + 5, userLabel.width, roomLabel.height)];
    raiseLabel.font = font;
    raiseLabel.text = @"评价等级：";
    
    [cell.contentView addSubview:roomLabel];
    [cell.contentView addSubview:userLabel];
    [cell.contentView addSubview:raiseLabel];
    
    //加载星星
    
    NSString *RaiseStatus = [NSString stringWithFormat:@"%@",dic[@"ping"]];
    NSInteger status = [RaiseStatus integerValue] * 2 - 1;
    int num;
    for (num = 0; num < status; num++) {
        UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(raiseLabel.left + num * 30, raiseLabel.bottom + 5, 25, 25)];
        imageV.image = [UIImage imageNamed:@"starYes"];
        [cell.contentView addSubview:imageV];
    }
    for (; num < 5; num ++) {
        UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(raiseLabel.left + num * 30, raiseLabel.bottom + 5, 25, 25)];
        imageV.image = [UIImage imageNamed:@"starNo"];
        [cell.contentView addSubview:imageV];
    }
    
//    }
    return cell;
}

-(void)getAppRaise:(BOOL)UpDown{
    __weak ASIFormDataRequest *request;
    request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:URL_APP_RAISE]];
    
    request.requestMethod = @"POST";
    
    
    NSString *page = [NSString stringWithFormat:@"%ld",(long)pages];
    NSString *numberStr = [NSString stringWithFormat:@"%d",RasiStarus];
    [request addPostValue:page forKey:@"page"];
    [request addPostValue:MY_UID forKey:@"uid"];
    [request addPostValue:MY_ZEND forKey:@"zend"];
    [request addPostValue:numberStr forKey:@"type"];
    
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
                    countLabel.text = [NSString stringWithFormat:@"共有 %@ 条评论",resultDict[@"count"]];
                    
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
        }
        else
        {
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
    return 175;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//释放内存
-(void)dealloc{
    NSLog(@"我的评价dealloc");
    [_header free];
    [_footer free];
}



//标题下添加button
-(void)addButton{
    if (!View) {
        View = [[iuiueMyView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        View.delegate = self;
        [self.view addSubview:View];
    }
    else if(View.isOn){
        View = [[iuiueMyView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        View.delegate = self;
        [self.view addSubview:View];
    }
    else{
        [View hideView];
    }
}

-(void)clickButtonIndex:(NSInteger)index{
    [View hideView];
    hud =
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.labelText = @"加载中...";
    //滚动到初始位置
    CGPoint position = CGPointMake(0 , -64);
    [MyTableView setContentOffset:position animated:YES];


    switch (index) {
        case 0:
            self.navigationItem.title = @"全部评价";
            break;
        case 1:
            self.navigationItem.title = @"未回评评价";
            break;
        case 2:
            self.navigationItem.title = @"双方已评评价";
            break;
        default:
            break;
    }
    RasiStarus = index;
    pages = 1;
    [self getAppRaise:NO];

    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    pages = 1;
    hud =
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"加载中...";
    
    [self getAppRaise:NO];
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    iuiueAppReRaiseViewController *reraise = [[iuiueAppReRaiseViewController alloc]init];
    reraise.MyDic = MyArray[indexPath.row];
    reraise.delegate = self;
    [self.navigationController pushViewController:reraise animated:YES];
}

-(void)Transmit:(NSString *)string{
    [[UIApplication sharedApplication].keyWindow makeToast:string];
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

@end
