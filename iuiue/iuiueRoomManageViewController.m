//
//  iuiueRoomManageViewController.m
//  iuiue
//
//  Created by mizilang on 14-5-9.
//  Copyright (c) 2014年 iuiue. All rights reserved.
//

#import "iuiueRoomManageViewController.h"
#import "NSDate+calendar.h"
#import "iuiueChangeDateViewController.h"

@interface iuiueRoomManageViewController ()<TransmitProtocol>
{
    //未来四个月的时间arr
    MBProgressHUD *hud;
    NSArray *array;
    UIButton *firstbtn;
    UIButton *secondbtn;
    UIView *firstView;
    UIScrollView *myscrollView;
    BOOL IsLongPress;
}
@end

@implementation iuiueRoomManageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.title = @"房态管理";
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
    IsLongPress = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    NSLog(@"房间管理加载。。。。");
    NSLog(@"%@",self.roomName);
//    NSDate *now = [NSDate date];
//    NSLog(@"%@",[now firstDayOfThisMonth]);
//    NSLog(@"%d",[now daylyOrdinality]+[[now firstDayOfCurrentMonth] weeklyOrdinality] - 1);
//    NSLog(@"dateArray%d",[self getDateArry].count);
    
        // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//点击按钮
-(IBAction)click:(id)sender{
    //    NSLog(@"点击了按钮");
    UIColor *white =[UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
    UIColor *black= [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    UIButton *button = (UIButton *)sender;//获得当前的button
    //    NSLog(@"buttom:%d",button.tag);
    UIView *view = [button superview];//获得当前的view
    //    secondbtn.tag = button.tag;
    //    NSLog(@"%d",view.tag);
    //第一次点击
    if (firstbtn.tag == 0) {
        NSLog(@"第一次点击");
        button.backgroundColor = black;
    }
    else if([firstbtn.backgroundColor isEqual:white]){
        NSLog(@"第二次点击，第一次为白色");
        button.backgroundColor = black;
    }
    else if([firstbtn.backgroundColor isEqual:black]){
        if (view.tag ==firstView.tag&& button.tag == firstbtn.tag) {
            button.backgroundColor = white;
            NSLog(@"二次点击，第一次为黑色");
            return;
        }
        if (view.tag == firstView.tag&&button.tag >firstbtn.tag) {
            NSLog(@"相同view，不同的button");
            NSLog(@"%d月%d,%d月%d",firstView.tag,firstbtn.tag,view.tag,button.tag);
            for (id obj in view.subviews) {
                if ([obj isKindOfClass:[UIButton class]]) {
                    UIButton* theButton = (UIButton*)obj;
                    if (theButton.enabled == YES&&theButton.tag>firstbtn.tag&&theButton.tag<=button.tag) {
                        theButton.backgroundColor = black;
                    }
                }
            }
            
            iuiueChangeDateViewController *change = [[iuiueChangeDateViewController alloc]init];
            NSDate *now=[NSDate date];
            change.startDate = firstbtn.titleLabel.text;
            if (view.tag <firstView.tag) {
                change.endDate = button.titleLabel.text;
            }
            else{
                change.endDate = button.titleLabel.text;
            }
            change.roomId = self.roomId;
            change.roomName = self.roomName;
            change.location = self.location;
            change.delegate = self;
            NSLog(@"push:%@",change.roomName);
            [self.navigationController pushViewController:change animated:YES];
            
            
            
        }
        else if(view.tag > firstView.tag){
            NSLog(@"%d月%d,%d月%d",firstView.tag,firstbtn.tag,view.tag,button.tag);
            for (id obj in firstView.subviews) {
                if ([obj isKindOfClass:[UIButton class]]) {
                    UIButton* theButton = (UIButton*)obj;
                    if (theButton.enabled == YES&&theButton.tag>=firstbtn.tag) {
                        theButton.backgroundColor = black;
                    }
                }
            }
            for (id obj in view.subviews) {
                if ([obj isKindOfClass:[UIButton class]]) {
                    UIButton* theButton = (UIButton*)obj;
                    if (theButton.enabled == YES&&theButton.tag<=button.tag) {
                        theButton.backgroundColor = black;
                    }
                }
            }
            iuiueChangeDateViewController *change = [[iuiueChangeDateViewController alloc]init];
            NSDate *now=[NSDate date];
            change.startDate = firstbtn.titleLabel.text;
            //不考虑过年问题
            if (view.tag <firstView.tag) {
                change.endDate = button.titleLabel.text;
            }
            else{
                change.endDate = button.titleLabel.text;
            }
            change.roomId = self.roomId;
            change.roomName = self.roomName;
            change.location = self.location;
            change.delegate = self;
            NSLog(@"push:%@",change.roomName);
            [self.navigationController pushViewController:change animated:YES];
            
            
        }
        else{
            NSLog(@"%d第二次点击在第一次点击之前%d",firstView.tag,view.tag);
            [[UIApplication sharedApplication].keyWindow makeToast:@"第二次点击应在第一次点击之后"];
            return;
        }
    }
    
    
    
    //点击后留下
    //    firstbtn = (UIButton *)[view viewWithTag:button.tag];
    firstbtn = button;
    //    firstbtn.tag = button.tag;
    NSLog(@"第一个按钮%@",firstbtn.backgroundColor);
    firstView = [myscrollView viewWithTag:view.tag];
    
    //判断是否在一个view上
    //    if (view.tag == fistView.tag) {
    //        secondbtn.tag = button.tag;
    //        //第一次点击
    //        if (firstbtn.tag==0) {
    //            if ([button.backgroundColor isEqual:white]) {
    //                [secondbtn setBackgroundColor:black];
    //                [button setBackgroundColor:black];
    //            }
    //            else{
    //                [secondbtn setBackgroundColor:white];
    //                [button setBackgroundColor:white];
    //            }
    //            firstbtn.tag = secondbtn.tag;
    //            firstbtn.backgroundColor = secondbtn.backgroundColor;
    //        }
    //        else if(secondbtn.tag > firstbtn.tag && [firstbtn.backgroundColor isEqual:black]){
    //            NSLog(@"%d,%d,%d,%d",fistView.tag, firstbtn.tag,view.tag, secondbtn.tag);
    //
    //            firstbtn = (UIButton *)[fistView viewWithTag:firstbtn.tag];
    //            firstbtn.backgroundColor = white;
    //            firstbtn.tag = 0;
    //        }
    //        else{
    //            NSLog(@"不可被点击");
    //        }
    //    }
    //    else if(view.tag > fistView.tag){
    //        
    //    }
    //    fistView = [myscrollView viewWithTag:view.tag];
}






//从接口获取数据
-(void)getDateArray{
    
    //获取uid 与zend
    NSMutableDictionary *usernamepasswordKVPairs = (NSMutableDictionary *)[iuiueCHKeychain load:KEYCHAIN_USERNAMEPASSWORD];
    NSString *uid =[usernamepasswordKVPairs objectForKey:KEYCHAIN_UID];
    NSString *zend = [usernamepasswordKVPairs objectForKey:KEYCHAIN_ZEND];
    
    __weak ASIFormDataRequest *request;
    
    request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:URL_PAIQI]];
    
    request.requestMethod = @"POST";
    [request addPostValue:uid forKey:@"uid"];
    [request addPostValue:zend forKey:@"zend"];
    
    //房间编号
    [request addPostValue:_roomId forKey:@"roomid"];
    
    
    [request setCompletionBlock:^{
        NSLog(@"%@",request.responseString);
        NSError *error;
        NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingAllowFragments error:&error];
        if (!error) {
            switch ([resultDict[@"status"] integerValue]) {
                case 0:{
                    array = [resultDict valueForKey:@"list"];
                    [self viewinit];
                    [hud hide:YES];
                    self.view.backgroundColor = [UIColor whiteColor];
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
//        [[UIApplication sharedApplication].keyWindow makeToast:@"关闭房间失败，请检查网络设置"];
        hud.labelText =@"网络连接失败，请检查网络设置";
        [hud hide:YES];
    }];
    
    //添加加载提示
    hud =
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"加载中...";
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    //异步加载
    [request startAsynchronous];
    
}
-(NSMutableArray *)getDateArry{
    iuiueAllService *service = [[iuiueAllService alloc]init];
    [service calendarsDictionaryInit:[NSDictionary dictionaryWithObjectsAndKeys:_roomId,@"roomid",nil]];
    NSArray *listarray;
    listarray = [service.diction valueForKey:@"list"];
    NSMutableArray *addarray = [NSMutableArray array];
    for (id _id in listarray) {
        [addarray addObject:_id];
    }
    NSLog(@"addarray :%@",addarray);
    return addarray;
}

-(void) viewinit{
    firstbtn = [[UIButton alloc]init];//标识button
    secondbtn = [[UIButton alloc]init];//标识button2
    firstView = [[UIView alloc]init];
    //屏幕尺寸的获得，适配屏幕尺寸
    CGRect r = [ UIScreen mainScreen ].bounds;
    //创建日历页
    NSDate *now = [NSDate date];
    
    //打印当前月份有几周
    //    NSLog(@"%d",[[now firstDayOfNextMonth] weeklyOrdinality]);
    r.size.height = r.size.height - 64;
    myscrollView = [[UIScrollView alloc]initWithFrame:r];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(2, 0, MY_WIDTH - 4, 80)];
    
    
    label.backgroundColor = [UIColor colorWithRed:0 green:0 blue:180 alpha:0.5];
    label.font =[UIFont fontWithName:@"Helvetica-Bold" size:12];
    label.numberOfLines = 6;
    [self.view addSubview:label];
    int datenumber = 0;
    label.text = @"操作方式：1.单击为选择日期，两次单击不同日期，为选择开始和结束日期。\n2.长按为选择修改当天排期。\n3.点击之后，再次点击为取消已选择日期。";
    UIView *dateView=[[UIView alloc]init];
    UIView *dateView1=[[UIView alloc]init];
    UIView *dateView2=[[UIView alloc]init];
    UIView *dateView3=[[UIView alloc]init];
    NSArray *viewarray = [[NSArray alloc] initWithObjects: dateView,dateView1,dateView2,dateView3,nil];
    NSDate *currentDay;
    currentDay = [NSDate date];
    currentDay = [currentDay firstDayOfThisMonth];
    NSLog(@"%d",[currentDay weeklyOrdinality]);
    UIView * currentView = [[UIView alloc]initWithFrame:CGRectMake(0, 80, 0, 0)];
    for (UIView *dView in viewarray) {
        dView.tag = [currentDay monthlyOrdinality];
        NSInteger hight = (6 - [currentDay numberOfWeeksInCurrentMonth]) * 50;
        [dView setFrame:CGRectMake(0, currentView.frame.origin.y + currentView.frame.size.height, MY_WIDTH, 350 - hight)];
        NSLog(@"%f",dView.frame.size.height);
        UILabel *monthLabel = [[UILabel alloc]initWithFrame:CGRectMake((MY_WIDTH - 240)/2, 0, 240, 29)];
        monthLabel.backgroundColor = [UIColor clearColor];
        monthLabel.text = [NSString stringWithFormat:@"%d年%d月",[currentDay yearlyOrdinality],[currentDay monthlyOrdinality]];
        NSString *monthstring = [NSString stringWithFormat:@"%d",[currentDay monthlyOrdinality]];
        if ([currentDay monthlyOrdinality]<10) {
            monthstring = [NSString stringWithFormat:@"0%d",[currentDay monthlyOrdinality]];
        }
//        NSString *month = [NSString stringWithFormat:@"%d%@",[currentDay yearlyOrdinality],monthstring];
//        dView.tag = [month integerValue];
        monthLabel.layer.cornerRadius = 5;
        
        monthLabel.textAlignment = NSTextAlignmentCenter;
        
        [dView addSubview:monthLabel];
        
        NSArray *weekArr = @[@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六"];
        for (int weeknum = 0;weeknum <7 ; weeknum++) {
            UILabel *weekLabel = [[UILabel alloc]initWithFrame:CGRectMake(2.5 + weeknum * (MY_WIDTH - 5)/7, 30, (MY_WIDTH - 5)/7 - 1, 19)];
            weekLabel.text = weekArr[weeknum];
            weekLabel.textAlignment = NSTextAlignmentCenter;
            weekLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
            [dView addSubview:weekLabel];
        }
        int day = 1;
        int dayay = 1;
        for (int num = 0; num < [currentDay numberOfWeeksInCurrentMonth]; num++)
        {
            for (int num1 = 0; num1 < 7; num1++)
            {
                UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(2.5 + num1 * (MY_WIDTH - 5)/7, 50 + num * 50, (MY_WIDTH - 5)/7 - 1, 49)];
                [btn setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.1]];
                [btn setTag:num1 + 1 + num * 7 ];
                NSString *str = [NSString stringWithFormat:@"%d-%d-%d",[currentDay yearlyOrdinality],[currentDay monthlyOrdinality],btn.tag];
                [btn setTitle:str forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
                btn.enabled = NO;
                [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
                //添加长按事件
                
                UILongPressGestureRecognizer *longPressGR =
                [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                              action:@selector(handleLongPress:)];
                longPressGR.minimumPressDuration = 0.5;
                longPressGR.allowableMovement = NO;
                //                longPressGR.numberOfTapsRequired= 1;
                longPressGR.numberOfTouchesRequired= 1;
                [btn addGestureRecognizer:longPressGR];
                
                [dView addSubview:btn];
                //判断得出日历上的顺序
                NSInteger firstWeek = (long)[currentDay weeklyOrdinality] - 2;
                if ([currentDay weeklyOrdinality]==1) {
                    firstWeek = 6;
                }
                if (num1 + 1 + num * 7>firstWeek&&num1 + 1 + num * 7<[currentDay numberOfDaysInCurrentMonth]+firstWeek + 1)
                {
                    NSDate *current;
                    current = [NSDate date];
                    current = [current firstDayOfThisMonth];
                    NSString *month = [NSString stringWithFormat:@"%d",[current monthlyOrdinality]];
//                    NSString *dadada = [NSString stringWithFormat:@"%d%d",[now yearlyOrdinality],[now monthlyOrdinality]];
                    if (dView.tag == [month integerValue]&&num1 + 1 + num * 7 < [now daylyOrdinality]+[[now firstDayOfCurrentMonth] weeklyOrdinality] - 1) {
                        UILabel *dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,0,44,10)];
                        [dateLabel setTextAlignment:NSTextAlignmentCenter];
                        dateLabel.font = [UIFont fontWithName:@"Helvetica" size:10];
                        dateLabel.text =[NSString stringWithFormat:@"%d",day];
                        [btn addSubview:dateLabel];
                        day ++;
                        dayay ++;
                        
                    }
                    else{
                        UILabel *dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,0,44,10)];
                        [dateLabel setTextAlignment:NSTextAlignmentCenter];
                        dateLabel.font = [UIFont fontWithName:@"Helvetica" size:10];
                        UILabel *stateLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,10,44,10)];
                        UILabel *priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,30,44,19)];
                        NSDictionary *dateDic;
                        dateDic = array[datenumber];
                        NSString *dateStr = [dateDic valueForKey:@"date"];
                        NSString *str = [dateStr substringFromIndex:8];
                        NSString *str1 = [NSString stringWithFormat:@"%d",dayay];
                        dateLabel.text = str1;
                        [btn setTag:[str1 integerValue]];
                        NSString *StateStr = [NSString stringWithFormat:@"%@",[dateDic valueForKey:@"sameroom"]];
                        NSString *stateStr;
                        if ([StateStr intValue] > 0) {
                            stateStr = [NSString stringWithFormat:@"可租：%@",StateStr];
                        }
                        else
                        {
                            stateStr = [NSString stringWithFormat:@"不可租"];
                        }
                        stateLabel.text = stateStr;
                        stateLabel.adjustsFontSizeToFitWidth = YES;
                        [stateLabel setTextAlignment:NSTextAlignmentCenter];
                        stateLabel.font = [UIFont fontWithName:@"Helvetica" size:10];
                        NSString *priceStr = [NSString stringWithFormat:@"￥%@",[dateDic valueForKey:@"priceday"]];
                        priceLabel.text = priceStr;
                        [priceLabel setTextAlignment:NSTextAlignmentCenter];
                        priceLabel.font = [UIFont fontWithName:@"Helvetica" size:13];
                        [btn addSubview:dateLabel];
                        [btn addSubview:stateLabel];
                        [btn addSubview:priceLabel];
                        NSString *date = [NSString stringWithFormat:@"%d-%d-%d",[currentDay yearlyOrdinality],[currentDay monthlyOrdinality],btn.tag];
                        [btn setTitle:date forState:UIControlStateNormal];
                        [btn setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
                        if ([str1 intValue] == [now daylyOrdinality]&&dView.tag == [now monthlyOrdinality]) {
                            stateLabel.textColor = [UIColor redColor];
                            priceLabel.textColor = [UIColor redColor];
                            dateLabel.textColor = [UIColor redColor];
                        }
                        btn.enabled = YES;
                        datenumber++;
                        dayay ++;
                        
                    }
                    
                    
                }
            }
            
        }
        
        currentDay = [currentDay firstDayOfNextMonth];
        [currentView setFrame:dView.frame];
        
    }
    
    [myscrollView addSubview:label];
    [myscrollView addSubview:dateView];
    [self.view addSubview:myscrollView];
    [myscrollView addSubview:dateView1];
    [myscrollView addSubview:dateView2];
    [myscrollView addSubview:dateView3];
    [myscrollView setContentSize:CGSizeMake(MY_WIDTH, dateView3.frame.origin.y +dateView3.frame.size.height)];
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
    [myscrollView removeFromSuperview];
    array = [NSMutableArray array];
    [self getDateArray];
    
//    [self viewinit];
    IsLongPress = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.translucent = YES;
//    [myscrollView removeAllSubviews];
}


//长按按钮处理

- (void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer {
    
    //设置长按处理
    if (IsLongPress) {
        UIButton *button = (UIButton *)gestureRecognizer.view;
        NSLog(@"%@",button.titleLabel.text);
        UIView *view = [button superview];
        iuiueChangeDateViewController *change = [[iuiueChangeDateViewController alloc]init];
        NSDate *now=[NSDate date];
        change.startDate = button.titleLabel.text;
        change.endDate = button.titleLabel.text;
        
        change.roomId = self.roomId;
        change.roomName = self.roomName;
        change.location = self.location;
        //设置代理
        change.delegate = self;
        NSLog(@"push:%@",change.roomName);
        [self.navigationController pushViewController:change animated:YES];
        IsLongPress = NO;
    }
    NSLog(@"长按日期。。。");

}
-(void)Transmit:(NSString *)string{
    [[UIApplication sharedApplication].keyWindow makeToast:string];
}


@end
