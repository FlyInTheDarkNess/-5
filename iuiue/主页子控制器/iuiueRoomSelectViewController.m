//
//  iuiueRoomSelectViewController.m
//  木鸟房东端
//
//  Created by 赵中良 on 14-7-9.
//  Copyright (c) 2014年 iuiue. All rights reserved.
//

#import "iuiueRoomSelectViewController.h"

#import "UIImageView+WebCache.h"//引入加载图片的头文件
#import "MJRefresh.h"
#import "iuiueRoomManageViewController.h"

@interface iuiueRoomSelectViewController ()<UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate,UIAlertViewDelegate>
{
    UILabel *MyLabel;
    UITableView *MyTableView;//列表view
    MJRefreshHeaderView *_header;
    MJRefreshFooterView *_footer;
    NSInteger pages;

    NSMutableArray *StrArray;//关闭房间id的array
    MBProgressHUD *hud;
    UIButton *RightButton;
    UIButton *LeftButton;
    BOOL IsSelect;
    
    NSTimer *_timer;//添加线程
}

@end

@implementation iuiueRoomSelectViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationItem.title = @"房态管理";
//        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(fanhui)];
        //添加一键关房按钮
//        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"一键关房" style: UIBarButtonItemStyleDone target:self action:@selector(CloseAllRoom:)];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    self.navigationController.navigationBar.hidden = NO;//取消翻滚后的效果
    
    IsSelect = NO;//初始化选择状态为no
    
    //全局变量测初始化
    _MyArray = [NSMutableArray arrayWithCapacity:10];
    StrArray = [NSMutableArray arrayWithCapacity:10];
    //设置背景颜色不透明
    [self.view setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    
    //提示text设置
    MyLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 64, MY_WIDTH, 20)];
    [MyLabel setBackgroundColor:[UIColor orangeColor]];
    MyLabel.text = @"您已发布 待查询 套房";
    MyLabel.textAlignment = NSTextAlignmentRight;
    MyLabel.textColor = [UIColor whiteColor];
    
    [self.view addSubview:MyLabel];
    //两个button设置
    LeftButton = [[UIButton alloc]initWithFrame:CGRectMake(20, MyLabel.bottom + 5, [UIScreen mainScreen].bounds.size.width/2 - 30, 40)];
    RightButton = [[UIButton alloc]initWithFrame:CGRectMake(LeftButton.right + 20, MyLabel.bottom + 5, LeftButton.width, LeftButton.height)];
    
    //Button Title 设置
    [LeftButton setTitle:@"关闭今日所有房间" forState:UIControlStateNormal];
    [RightButton setTitle:@"关闭今日部分房间" forState:UIControlStateNormal];
    
    //Button 背景颜色设置
    [LeftButton setBackgroundColor:[UIColor redColor]];
    [RightButton setBackgroundColor:[UIColor blueColor]];
    
    //Button 圆角设置
    LeftButton.layer.cornerRadius = 5.0f;
    RightButton.layer.cornerRadius = 5.0f;
    
    //设置button的字体自动调整
    LeftButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    RightButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    
    //tagret 设置
    [LeftButton addTarget:self action:@selector(LeftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [RightButton addTarget:self action:@selector(RightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    //添加到view上
    [self.view addSubview:LeftButton];
    [self.view addSubview:RightButton];
    
    MyTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, LeftButton.bottom + 5, LeftButton.screenX, LeftButton.screenY - LeftButton.bottom - 5)];
    MyTableView.delegate = self;
    MyTableView.dataSource = self;
    MyTableView.tableFooterView = [[UIView alloc]init];
    
    [self.view addSubview:MyTableView];
    
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    hud =
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"加载中...";
    pages = 1;
    [self getOrderArray:NO];
    CGPoint position = CGPointMake(0 , 0);
    [MyTableView setContentOffset:position animated:YES];
//    self.navigationController.navigationBar.translucent = YES;
//    self.tabBarController.tabBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    self.tabBarController.tabBar.hidden = NO;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    [_header endRefreshing];
    [_footer endRefreshing];
    [self ChangeButtonTitle];
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return _MyArray.count;;
}



/**
 为了保证内部不泄露，在dealloc中释放占用的内存
 */
- (void)dealloc
{
    NSLog(@"MJTableViewController--dealloc---");
    [_header free];
    [_footer free];

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *reuseindentify = [NSString stringWithFormat:@"Cell%d%d", [indexPath section], [indexPath row]];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseindentify];
    if (!cell) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseindentify];
        //添加横线
        UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(15, 35, MY_WIDTH - 30, 1)];
        line.image = [UIImage imageNamed:@"line"];
        [cell addSubview:line];
        
        
        UILabel *titlelabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, MY_WIDTH - 30, 30)];
        [titlelabel setTag:1];
        [cell.contentView addSubview:titlelabel];
        
        UIImageView *imgeV = [[UIImageView alloc]initWithFrame:CGRectMake(15, 40, 130, 100)];
        [imgeV setTag:2];
        [cell.contentView addSubview:imgeV];
        
        //房间编号
        UILabel *room = [[UILabel alloc]initWithFrame:CGRectMake(imgeV.right + 5, 45, 30, 15)];
        room.text = @"房间编号：";
        room.font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
        [room sizeToFit];
        [cell.contentView addSubview:room];
        
        UILabel *roomid = [[UILabel alloc]initWithFrame:CGRectMake(imgeV.right + 5 + room.frame.size.width, room.top, 80, 15)];
        roomid.font = [UIFont fontWithName:@"Helvetica-Bold" size:11];
        [roomid setTag:3];
        [cell.contentView addSubview:roomid];
        
        //房间别名
        UILabel *roomt = [[UILabel alloc]initWithFrame:CGRectMake(imgeV.right + 5, room.bottom + 10, 30, 15)];
        roomt.text = @"房间别名：";
        roomt.font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
        [roomt sizeToFit];
        [cell.contentView addSubview:roomt];
        
        UILabel *roomtitle = [[UILabel alloc]initWithFrame:CGRectMake(roomt.right, roomt.frame.origin.y, 90, 15)];
        roomtitle.font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
        [roomtitle setTag:4];
        [cell.contentView addSubview:roomtitle];
        
        UILabel *statu = [[UILabel alloc]initWithFrame:CGRectMake(imgeV.right + 5, roomt.frame.size.height + roomt.frame.origin.y + 15, 50, 15)];
        statu.text = @"房间状态:";
        statu.font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
        [statu sizeToFit];
        [cell.contentView addSubview:statu];
        
        UILabel *status = [[UILabel alloc]initWithFrame:CGRectMake(statu.right +5, statu.frame.origin.y - 8, 70, 30)];
        [status setTag:6];
        status.textColor = [UIColor blueColor];
        status.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
        [cell.contentView addSubview:status];
        
        
        UILabel *num = [[UILabel alloc]initWithFrame:CGRectMake(imgeV.right + 5, statu.frame.size.height + statu.frame.origin.y + 10 , 50, 15)];
        num.text = @"默认数量：";
        num.font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
        [num sizeToFit];
        [cell.contentView addSubview:num];
        
        UILabel *numberOfRoom = [[UILabel alloc]initWithFrame:CGRectMake(imgeV.right + 5 + num.frame.size.width, num.frame.origin.y, 40, 15)];
        [numberOfRoom setTag:8];
        numberOfRoom.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
        [cell.contentView addSubview:numberOfRoom];
        
        
        
        UILabel *location = [[UILabel alloc]initWithFrame:CGRectMake(imgeV.left, imgeV.bottom + 10, 50, 20)];
        location.text = @"地理位置:";
        location.font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
        [location sizeToFit];
        [cell.contentView addSubview:location];
        
        UILabel *address = [[UILabel alloc]initWithFrame:CGRectMake(location.right + 5, location.top, 200, 20)];
        address.numberOfLines = 0;
        [address setTag:5];
        address.font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
        [cell.contentView addSubview:address];

        //cell的高度计算
        CGFloat height = address.bottom + 10;
        
        //添加typeview图片
        CGRect frame = CGRectMake(MY_WIDTH - 32, height/2 - 10, 20, 20 );
        UIImageView * imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"dgh"]];
        [imgView setFrame:frame];
        [imgView setTag:98];
        [cell addSubview:imgView];
        
        //设置cell的高度
        [cell setFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, height)];
        
        
    }
    
    //根据选择状态判断框存在与否
    UIImageView *oneImageView = (UIImageView *)[cell viewWithTag:98];
    if (IsSelect) {
        oneImageView.hidden = NO;
    }else{
        oneImageView.hidden = YES;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    NSDictionary *dic = _MyArray[indexPath.row];
    UILabel *titlelabel;
    titlelabel = (UILabel *)[cell viewWithTag:1];
    NSString *title =[NSString stringWithFormat:@"%@",[dic valueForKey:@"title"]];
    titlelabel.text = title;
    UIImageView *imageView;
    imageView = (UIImageView *)[cell viewWithTag:2];
    [imageView setImage:[UIImage imageNamed:@"woodbird"]];
    [imageView performSelector:@selector(setImageWithURL:) withObject:[NSURL URLWithString:[dic valueForKey:@"picurl"]]];    
    
    UILabel *roomIdLabel;
    roomIdLabel = (UILabel *)[cell viewWithTag:3];
    NSString *roomId = [NSString stringWithFormat:@"%@",[dic valueForKey:@"roomid"]];
    for (NSString* str in StrArray) {
        if ([str isEqualToString:roomId]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
    
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
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //显示点击
//    [[UIApplication sharedApplication].keyWindow makeToast:@"dianji"];
    
    //取消选中状态
    [tableView deselectRowAtIndexPath: [tableView indexPathForSelectedRow] animated:YES];
    if (IsSelect) {
        //视图变化
        UITableViewCell *oneCell = [tableView cellForRowAtIndexPath: indexPath];
        if (oneCell.accessoryType == UITableViewCellAccessoryNone) {
            oneCell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else
            oneCell.accessoryType = UITableViewCellAccessoryNone;
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        //数据变化
        for (NSString* str in StrArray) {
            NSString *str1 = [NSString stringWithFormat:@"%@",_MyArray[indexPath.row][@"roomid"]];
            if ([str isEqualToString:str1]) {
                [StrArray removeObject:str];
                [self ChangeButtonTitle];
                //                NSLog(@"%@",str);
                return;
            }
        }
        NSString *str = [NSString stringWithFormat:@"%@",_MyArray[indexPath.row][@"roomid"]];
        [StrArray addObject:str];
        [self ChangeButtonTitle];
    }
    else{
        [tableView deselectRowAtIndexPath: [tableView indexPathForSelectedRow] animated:YES];
        iuiueAllService *service1 = [[iuiueAllService alloc]init];
        if (![service1 isConnectionAvailable]) {
            [[UIApplication sharedApplication].keyWindow makeToast:@"网络连接失败...请检查网络设置" duration:1 position:@"center"];
            return;
        }
        
        NSDictionary *dic = _MyArray[indexPath.row];
        NSString *roomId = [NSString stringWithFormat:@"%@",[dic valueForKey:@"roomid"]];
        iuiueRoomManageViewController *room = [[iuiueRoomManageViewController alloc]init];
        room.roomId = roomId;
        room.location = [NSString stringWithFormat:@"%@",[dic valueForKey:@"address"]];
        room.roomName = [NSString stringWithFormat:@"%@",[dic valueForKeyPath:@"title"]];
        [self.navigationController pushViewController:room animated:YES];
    }
}

//判断修改button
-(void)ChangeButtonTitle{
    if (!IsSelect) {
        [RightButton setTitle:@"关闭今日部分房间" forState:UIControlStateNormal];
        [RightButton setBackgroundColor:[UIColor blueColor]];
    }else{
        [RightButton setTitle:@"取消选择" forState:UIControlStateNormal];
        [RightButton.titleLabel sizeToFit];
        [RightButton setBackgroundColor:[UIColor purpleColor]];
    }
}

//获取数据
-(void)getOrderArray:(BOOL) UpDown{
    
    //获取钥匙串中得uid与zend
    NSMutableDictionary *usernamepasswordKVPairs = (NSMutableDictionary *)[iuiueCHKeychain load:KEYCHAIN_USERNAMEPASSWORD];
    NSString *uid =[usernamepasswordKVPairs objectForKey:KEYCHAIN_UID];
    NSString *zend = [usernamepasswordKVPairs objectForKey:KEYCHAIN_ZEND];
    __weak ASIFormDataRequest *request;
    
    request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:URL_MY_ROOMS]];
    
    request.requestMethod = @"POST";
    
    
    NSString *page = [NSString stringWithFormat:@"%ld",(long)pages];
    [request addPostValue:page forKey:@"page"];
    [request addPostValue:uid forKey:@"uid"];
    [request addPostValue:zend forKey:@"zend"];
    //全部房源
    [request addPostValue:@"0" forKey:@"status"];

    
    
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
                        [_MyArray addObjectsFromArray:ListArray];
                        [MyTableView reloadData];
                    }
                    else{
                        [_MyArray removeAllObjects];
                        [_MyArray addObjectsFromArray:ListArray];
                        [MyTableView reloadData];
                    }
                    //获取数据后更新发布房间数量
                    MyLabel.text = [NSString stringWithFormat:@"您已发布 %@ 套房",resultDict[@"count"]];
                                        
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


//row的高度自适应
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
    iuiueAllService *service = [[iuiueAllService alloc]init];
    if (btn.tag % 2 == 0) {
        NSInteger row = btn.tag/2;//获得row的行数
        NSDictionary *dic = _MyArray[row];
        NSLog(@"shuchu%@",[dic valueForKey:@"orderid" ]);
        [service ConfirmingOrderDictionaryInit:[NSDictionary dictionaryWithObjectsAndKeys:[dic valueForKey:@"orderid" ],@"orderid",@"1",@"canpay", nil]];
        NSDictionary *dic2;
        dic2 = service.diction;
        [[UIApplication sharedApplication].keyWindow makeToast:[dic2 valueForKey:@"message"]];
        [_MyArray removeObjectAtIndex:row];
        [MyTableView reloadData];
    }
    else{
        NSInteger row = btn.tag/2;//获得row的行数
        NSDictionary *dic = _MyArray[row];
        [service ConfirmingOrderDictionaryInit:[NSDictionary dictionaryWithObjectsAndKeys:[dic valueForKey:@"orderid" ],@"orderid",@"2",@"canpay", nil]];
        [_MyArray removeObjectAtIndex:row];
        [MyTableView reloadData];
    }
}

//alertView点击事件
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    //关闭所有房间
    if (alertView.tag == 1) {
        switch (buttonIndex) {
            case 0:
            {
                [self PostCloseRoom:YES];
            }
                
                break;
            case 1:
                
                break;
                
            default:
                break;
        }

    }
    //关闭部分房间
    else{
        switch (buttonIndex) {
            case 0:
            {
                [self PostCloseRoom:NO];
            }
                
                break;
            case 1:
                
                break;
                
            default:
                break;
        }

    }
}


//关闭所选房间
-(void)PostCloseRoom:(BOOL) isAll{
    //合并_MyArray 生成传递字符串
    NSString *ArrayStr = [StrArray componentsJoinedByString:@","];
    //    NSLog(@"关闭房间id字符串：%@",ArrayStr);
    
    NSMutableDictionary *usernamepasswordKVPairs = (NSMutableDictionary *)[iuiueCHKeychain load:KEYCHAIN_USERNAMEPASSWORD];
    NSString *uid =[usernamepasswordKVPairs objectForKey:KEYCHAIN_UID];
    NSString *zend = [usernamepasswordKVPairs objectForKey:KEYCHAIN_ZEND];
    __weak ASIFormDataRequest *request;
    
    request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:URL_ROOM_CLOSE]];
    
    request.requestMethod = @"POST";
    [request addPostValue:uid forKey:@"uid"];
    [request addPostValue:zend forKey:@"zend"];
    
    //判断是否关闭所有房间
    if (isAll) {
        [request addPostValue:@"1" forKey:@"type"];
    }else{
        [request addPostValue:@"2" forKey:@"type"];
        [request addPostValue:ArrayStr forKey:@"roomids"];
    }
    
    
    
    [request setCompletionBlock:^{
        NSLog(@"%@",request.responseString);
        NSError *error;
        NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingAllowFragments error:&error];
        if (!error) {
            switch ([resultDict[@"status"] integerValue]) {
                case 0:{
                    
                    //根据是否关闭所有房间来显示提醒
                    if (isAll){
//                        [[UIApplication sharedApplication].keyWindow makeToast:@"全部房间已成功关闭"];
                        [self fanhui];
                        [self.delegate Transmit:@"全部房间已成功关闭"];
                       
                    }
                    else
                    {
//                        [[UIApplication sharedApplication].keyWindow makeToast:@"所选房间已成功关闭"];
                        [self fanhui];
                        [self.delegate Transmit:@"所选房间已成功关闭"];
                        
                    }
                    
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
        [[UIApplication sharedApplication].keyWindow makeToast:@"关闭房间失败，请检查网络设置"];
    }];
    
    //异步加载
    [request startAsynchronous];
}



//左键点击出现alertView
-(IBAction)LeftButtonClick:(id)sender{
    
    //所有房间
    if (!IsSelect) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"关闭全部房间" message:@"确认关闭后，全部房间今日将不能预订" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        alert.tag = 1;
        [alert show];

    }
    //部分房间
    else{
        if (StrArray.count == 0) {
            [[UIApplication sharedApplication].keyWindow makeToast:@"请先选择要关闭的房间"];
        }else{
//            NSString *message;
//            if (IsSelect) {
//                message = @"确认关闭后，所选房间今日将不能预订";
//            }else{
//                
//            }
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"关闭部分房间" message:@"确认关闭后，所选房间今日将不能预订" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
            [alert show];
        }

    }
}

//右键点击选择
-(IBAction)RightButtonClick:(id)sender{
    IsSelect = !IsSelect;
    if (IsSelect) {
        [LeftButton setTitle:@"确认关闭" forState:UIControlStateNormal];
        [LeftButton setBackgroundColor:[UIColor orangeColor]];
    }else{
        [LeftButton setTitle:@"关闭今日所有房间" forState:UIControlStateNormal];
        [LeftButton setBackgroundColor:[UIColor redColor]];
    }
    UIButton *button = (UIButton *)sender;
    if ([button.titleLabel.text isEqualToString:@"选择全部"]) {
        [StrArray removeAllObjects];
        for (NSDictionary *dic in _MyArray) {
            NSString *RoomIdStr = [NSString stringWithFormat:@"%@",dic[@"roomid"]];
            [StrArray addObject:RoomIdStr];
        }
    }
    else{
        [StrArray removeAllObjects];
    }
    [self ChangeButtonTitle];
    [MyTableView reloadData];
//    [[UIApplication sharedApplication].keyWindow makeToast:button.titleLabel.text];
}

//一键关房响应事件
-(IBAction)CloseAllRoom:(id)sender{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确认关闭后，所有房间今日将不能预订" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    alert.tag = 1;
    [alert show];
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
