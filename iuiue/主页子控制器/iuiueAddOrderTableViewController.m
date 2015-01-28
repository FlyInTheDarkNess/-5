//
//  iuiueAddOrderTableViewController.m
//  木鸟房东端
//
//  Created by 赵中良 on 14-7-25.
//  Copyright (c) 2014年 iuiue. All rights reserved.
//

#import "iuiueAddOrderTableViewController.h"
#import "UIImageView+WebCache.h"//引入加载图片的头文件
#import "Toast+UIView.h"
#import "MJRefresh.h"

#import "iuiueAppDelegate.h"
#import "UMSocialScreenShoter.h"
#import "iuiueZhiDingViewController.h"
#import "ViewController.h"
#import "UMSocial.h"
#import "MobClick.h"
#import "UMSocialYixinHandler.h"
#import "UMSocialFacebookHandler.h"
#import "UMSocialLaiwangHandler.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialTwitterHandler.h"
#import "UMSocialQQHandler.h"
#import "UMSocialSinaHandler.h"
#import "UMSocialTencentWeiboHandler.h"
#import "UMSocialRenrenHandler.h"
#import "UMSocialInstagramHandler.h"

@interface iuiueAddOrderTableViewController ()<MJRefreshBaseViewDelegate>
{
    UILabel *MyLabel;
    MJRefreshHeaderView *_header;
    MJRefreshFooterView *_footer;
    NSInteger pages;
    MBProgressHUD *hud;
    UIButton *RightButton;
    UIButton *LeftButton;
    BOOL IsSelect;
    
    NSTimer *_timer;//添加线程
    NSMutableArray *_MyArray;
}

@end

@implementation iuiueAddOrderTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.navigationItem.title = @"提高销量";
//        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(fanhui)];
        UIBarButtonItem *item = [[UIBarButtonItem alloc]init];
        self.navigationItem.backBarButtonItem = item;
        item.title = @"返回";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//     self.navigationController.navigationBar.hidden = NO;//取消翻滚后的效果
    
    self.tableView.tableFooterView = [[UIView alloc]init];
    
    _MyArray = [NSMutableArray array];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//去掉翻滚时箭头效果

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self setFreshView];
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
//        if (pages == 10) {
//            [self OutFreshView];
//        }
        [self getOrderArray:YES];
    }
}

//跳转返回
-(void)fanhui{
//    self.navigationController.navigationBar.hidden = YES;//取消翻滚后的效果
    [self dismissFlipWithCompletion:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = YES;
//    self.tabBarController.tabBar.hidden = YES;
//    self.tabBarController.tabBar.translucent = YES;

    [self.tableView setFrame:CGRectMake(0, 0, MY_WIDTH, MY_HEIGHT)];
    hud =
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"加载中...";
    pages = 1;
    [self getOrderArray:NO];
    CGPoint position = CGPointMake(0 , 0);
    [self.tableView setContentOffset:position animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    self.tabBarController.tabBar.hidden = NO;
//    self.tabBarController.tabBar.translucent = NO;
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
    return _MyArray.count;
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
    
    NSString *reuseindentify = [NSString stringWithFormat:@"Cell%d:%d", [indexPath section], [indexPath row]];
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
        statu.text = @"当前排名:";
        statu.font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
        [statu sizeToFit];
        [cell.contentView addSubview:statu];
        
        UILabel *status = [[UILabel alloc]initWithFrame:CGRectMake(statu.right +5, statu.frame.origin.y - 8, 70, 30)];
        [status setTag:6];
        status.textColor = [UIColor blueColor];
        status.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
        [cell.contentView addSubview:status];
        
        
        UILabel *num = [[UILabel alloc]initWithFrame:CGRectMake(imgeV.right + 5, statu.frame.size.height + statu.frame.origin.y + 10 , 50, 15)];
        num.text = @"推荐状态：";
        num.font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
        [num sizeToFit];
        [cell.contentView addSubview:num];
        
        UILabel *numberOfRoom = [[UILabel alloc]initWithFrame:CGRectMake(imgeV.right + 5 + num.frame.size.width, num.frame.origin.y -2, 40, 15)];
        [numberOfRoom setTag:8];
        numberOfRoom.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
        [cell.contentView addSubview:numberOfRoom];
        
        UIButton *leftButton = [[UIButton alloc]initWithFrame:CGRectMake( (MY_WIDTH - 290)/2, imgeV.bottom + 10, 90, 30)];
        leftButton.tag = 9;
        [leftButton setTitle:@"免费推广" forState:UIControlStateNormal];
        [leftButton addTarget:self action:@selector(showShareList1:) forControlEvents:UIControlEventTouchUpInside];
        leftButton.backgroundColor = [UIColor redColor];
        leftButton.titleLabel.adjustsFontSizeToFitWidth = YES;
        [cell.contentView addSubview:leftButton];
        leftButton.layer.cornerRadius = 5.0f;

        UIButton *midButton = [[UIButton alloc]initWithFrame:CGRectMake(leftButton.right + 10, leftButton.top, 90, 30)];
        [midButton setTitle:@"刷新一下" forState:UIControlStateNormal];
        [midButton addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventTouchUpInside];
        midButton.backgroundColor = [UIColor blueColor];
        midButton.tag = 10;
        midButton.layer.cornerRadius = 5.0f;
        midButton.titleLabel.adjustsFontSizeToFitWidth = YES;
        [cell.contentView addSubview:midButton];

        UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(midButton.right + 10, midButton.top, 90, 30)];
        [rightButton setTitle:@"我要置顶" forState:UIControlStateNormal];
        [rightButton addTarget:self action:@selector(zhiding:) forControlEvents:UIControlEventTouchUpInside];
        rightButton.backgroundColor = [UIColor orangeColor];
        rightButton.titleLabel.adjustsFontSizeToFitWidth = YES;
        rightButton.layer.cornerRadius = 5.0f;
        rightButton.tag = 11;
        [cell.contentView addSubview:rightButton];
        
        
        //设置cell的高度
        [cell setFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, imgeV.bottom + 50)];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone]; 
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
    
    
    roomIdLabel.text = roomId;
    UILabel *title2Label;
    title2Label = (UILabel*)[cell viewWithTag:4];
    NSString *title2 = [NSString stringWithFormat:@"%@",[dic valueForKey:@"title2"]];
    title2Label.text = title2;
    
    UILabel *statusOfRoomLabel;
    statusOfRoomLabel = (UILabel*)[cell viewWithTag:6];
    NSString *status =[NSString stringWithFormat:@"%@名",[dic valueForKey:@"paiming"]];
    statusOfRoomLabel.text = status;
    UILabel *numOfRoomLabel;
    numOfRoomLabel = (UILabel*)[cell viewWithTag:8];
    NSString *numOfRoom = [NSString stringWithFormat:@"%@",[dic valueForKey:@"istop"]];
    if ([numOfRoom isEqualToString:@"1"]) {
        numOfRoomLabel.text = @"右侧置顶";
    }
    else if([numOfRoom isEqualToString:@"2"]){
        numOfRoomLabel.text = @"橱窗推荐";
    }else if([numOfRoom isEqualToString:@"3"]){
        numOfRoomLabel.text = @"右侧置顶+推荐";
    }
    else if([numOfRoom isEqualToString:@"0"]){
        numOfRoomLabel.text = @"未开通";
    }
    [numOfRoomLabel sizeToFit];
    
    UILabel *priceDayLabel;
    priceDayLabel = (UILabel *)[cell viewWithTag:7];
    NSString *priceDay = [NSString stringWithFormat:@"%@",[dic valueForKey:@"priceday"]];
    priceDayLabel.text = priceDay;
    UILabel *nightLabel;
    nightLabel = (UILabel *)[cell viewWithTag:99];
    [nightLabel setFrame:CGRectMake(priceDayLabel.frame.origin.x + priceDayLabel.text.length * 6 + 10, nightLabel.frame.origin.y, 30, 30)];
    
    UIButton *btn1 = (UIButton *)[cell viewWithTag:9];
    btn1.tag = indexPath.row * 3 + 9;
    
    
    UIButton *btn2 = (UIButton *)[cell viewWithTag:10];
    btn2.tag = indexPath.row * 3 + 10;
    
    UIButton *btn3 = (UIButton *)[cell viewWithTag:11];
    btn3.tag = indexPath.row * 3 + 11;
    
    return cell;
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
    [request addPostValue:@"1" forKey:@"status"];//只查看已通过房间
    
    
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
                        [self.tableView reloadData];
                    }
                    else{
                        [_MyArray removeAllObjects];
                        [_MyArray addObjectsFromArray:ListArray];
                        [self.tableView reloadData];
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

-(void)didCloseUIViewController:(UMSViewControllerType)fromViewControllerType
{
    NSLog(@"didClose is %d",fromViewControllerType);
}

//下面得到分享完成的回调
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    NSLog(@"didFinishGetUMSocialDataInViewController with response is %@",response);
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的微博平台名
        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
    }
}
-(void)didFinishShareInShakeView:(UMSocialResponseEntity *)response
{
    NSLog(@"finish share with response is %@",response);
}
-(IBAction)showShareList1:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    NSInteger row = (btn.tag - 11)/3;
    NSDictionary *dic = _MyArray[row];
    NSString *picurl = [NSString stringWithFormat:@"%@",[dic valueForKey:@"picurl"]];
    NSString *roomId = [NSString stringWithFormat:@"%@",[dic valueForKey:@"roomid"]];
    NSString *roomName = [NSString stringWithFormat:@"%@",[dic valueForKey:@"title"]];
    NSString *roomUrl = [NSString stringWithFormat:@"http://www.muniao.com/room/%@.html",roomId];
    
    //打开调试log的开关
    [UMSocialData openLog:YES];
    //设置友盟社会化组件appkey
    [UMSocialData setAppKey:UmengAppkey];
    
    //设置微信AppId，设置分享url，默认使用友盟的网址
    [UMSocialWechatHandler setWXAppId:@"wx9f5cf3106ee65c89" url:roomUrl];
    
    //打开新浪微博的SSO开关
    [UMSocialSinaHandler openSSOWithRedirectURL:roomUrl];
//    [UMSocialSinaHandler openSSOWithRedirectURL:@"https://api.weibo.com/oauth2/default.html"];
    
    //    //打开腾讯微博SSO开关，设置回调地址
    //    [UMSocialTencentWeiboHandler openSSOWithRedirectUrl:@"http://sns.whalecloud.com/tencent2/callback"];
    
    //    //打开人人网SSO开关
    //    [UMSocialRenrenHandler openSSO];
    
    //设置分享到QQ空间的应用Id，和分享url 链接
    [UMSocialQQHandler setQQWithAppId:@"1101888196" appKey:@"40YsQ0tdaWh43hzZ" url:roomUrl];
    //设置支持没有客户端情况下使用SSO授权
    [UMSocialQQHandler setSupportWebView:YES];
    
    //    //设置易信Appkey和分享url地址
    //    [UMSocialYixinHandler setYixinAppKey:@"yx35664bdff4db42c2b7be1e29390c1a06" url:@"http://www.umeng.com/social"];
    //
    //    //设置来往AppId，appscret，显示来源名称和url地址
    //    [UMSocialLaiwangHandler setLaiwangAppId:@"8112117817424282305" appSecret:@"9996ed5039e641658de7b83345fee6c9" appDescription:@"友盟社会化组件" urlStirng:@"http://www.umeng.com/social"];
    //
    //使用友盟统计
    [MobClick startWithAppkey:UmengAppkey];
    //
    //    //设置facebook应用ID，和分享纯文字用到的url地址
    //    //    [UMSocialFacebookHandler setFacebookAppID:@"91136964205" shareFacebookWithURL:@"http://www.umeng.com/social"];
    //
    ////    //下面打开Instagram的开关
    ////    [UMSocialInstagramHandler openInstagramWithScale:NO paddingColor:[UIColor blackColor]];
    //    
    //    [UMSocialTwitterHandler openTwitter];
    //设置分享到空间，微信朋友圈的标题
    [UMSocialData defaultData].extConfig.wechatSessionData.title = @"木鸟短租房东助手";
    [UMSocialData defaultData].extConfig.qzoneData.title = @"木鸟短租房东助手";
    
    NSString *shareText = [NSString stringWithFormat:@"%@。%@",roomName,roomUrl];             //分享内嵌文字
    UIImage *shareImage = [UIImage imageNamed:@"backgroud"];          //分享内嵌图片
    
    //如果得到分享完成回调，需要设置delegate为self
    [UMSocialSnsService presentSnsIconSheetView:self appKey:UmengAppkey shareText:shareText shareImage:shareImage shareToSnsNames:@[UMShareToQQ,UMShareToQzone,UMShareToSina,UMShareToWechatTimeline,UMShareToWechatSession] delegate:self];
    [[UMSocialData defaultData].extConfig.wechatSessionData.urlResource setResourceType:UMSocialUrlResourceTypeImage url:picurl];
    [[UMSocialData defaultData].extConfig.wechatTimelineData.urlResource setResourceType:UMSocialUrlResourceTypeImage url:picurl];
    [[UMSocialData defaultData].extConfig.qqData.urlResource setResourceType:UMSocialUrlResourceTypeImage url:picurl];
    [[UMSocialData defaultData].extConfig.sinaData.urlResource setResourceType:UMSocialUrlResourceTypeImage url:picurl];
    [[UMSocialData defaultData].extConfig.qzoneData.urlResource setResourceType:UMSocialUrlResourceTypeImage url:picurl];
}
-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    /*
     如果要弹出的分享列表支持不同方向，需要在这里设置一下重新布局
     如果当前UIViewController有UINavigationController,则用self.navigationController.view，否则用self.view
     */
    UIView * iconActionSheet = [self.tabBarController.view viewWithTag:kTagSocialIconActionSheet];
    
    [iconActionSheet setNeedsDisplay];
    UIView * shakeView = [self.tabBarController.view viewWithTag:kTagSocialShakeView];
    [shakeView setNeedsDisplay];
}

-(IBAction)zhiding:(id)sender{
    UIButton *btn = (UIButton *)sender;
    iuiueZhiDingViewController *zhiding = [[iuiueZhiDingViewController alloc]init];
    NSInteger row = (btn.tag - 11)/3;
    NSDictionary *dic = _MyArray[row];
    NSString *title =[NSString stringWithFormat:@"%@",[dic valueForKey:@"title"]];
    zhiding.MyTitle = title;
    NSString *roomId = [NSString stringWithFormat:@"%@",[dic valueForKey:@"roomid"]];
    zhiding.roomId = roomId;
    [self.navigationController pushViewController:zhiding animated:YES];
//    ViewController *Vc = [[ViewController alloc]init];
//    [self.navigationController pushViewController:Vc animated:YES];
}

-(IBAction)refresh:(id)sender{
    UIButton *btn = (UIButton *)sender;
    NSInteger row = (btn.tag - 11)/3;
    NSDictionary *dic = _MyArray[row];
    NSString *roomId = [NSString stringWithFormat:@"%@",[dic valueForKey:@"roomid"]];
    [self postToRefresh:roomId];
}


//获取数据
-(void)postToRefresh:(NSString *) roomId{
    
    //获取钥匙串中得uid与zend
    __weak ASIFormDataRequest *request;
    
    request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:URL_REFRESH_ROOM]];
    
    request.requestMethod = @"POST";

    [request addPostValue:MY_UID forKey:@"uid"];
    [request addPostValue:MY_ZEND forKey:@"zend"];
    [request addPostValue:roomId forKey:@"id"];
    
    
    [request setCompletionBlock:^{
        NSLog(@"%@",request.responseString);
        NSError *error;
        NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingAllowFragments error:&error];
        if (!error) {
            switch ([resultDict[@"status"] integerValue]) {
                case 0:{
                    [hud hide:YES];
                    [self.navigationController.view  makeToast:[NSString stringWithFormat:@"%@",resultDict[@"message"]]];
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
                    [hud hide:YES];
                    [self.navigationController.view makeToast:[NSString stringWithFormat:@"%@",resultDict[@"message"]]];
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
    hud =
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"加载中...";
    //异步加载
    [request startAsynchronous];
    
}




@end
