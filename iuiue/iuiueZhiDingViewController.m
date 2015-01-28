//
//  iuiueZhiDingViewController.m
//  木鸟房东端
//
//  Created by 赵中良 on 14-8-20.
//  Copyright (c) 2014年 iuiue. All rights reserved.
//

#import "iuiueZhiDingViewController.h"
#import "ASIFormDataRequest.h"
#import "ViewController.h"

@interface iuiueZhiDingViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *MytableView;
    MBProgressHUD *hud;
    UISegmentedControl *firstSegment;//置顶类型
    UISegmentedControl *secondSegment;//置顶时长
    UILabel *timeLabel;//时长显示
    UILabel *priceLabel;//置顶花费
    UILabel *accountsLabel;//租币数量
    UILabel *startTimeLabel;//置顶开始时间
    float ZDone;//置顶月价格
    float ZDthree;//置顶季度价格
    float CCone;//橱窗月价格
    float CCthree;//橱窗季度价格
    float accounts;//租币数量
    NSInteger TotalTime;//时长
    float Price;//花费
    NSString *startTime;//开始时间
    NSInteger Type;//置顶类型
    NSInteger UseAccount;//是否使用租币
    UISwitch *Sw;
}
@end

@implementation iuiueZhiDingViewController
@synthesize MyTitle,roomId;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationItem.title = @"推荐置顶";
        UIBarButtonItem *item = [[UIBarButtonItem alloc]init];
        self.navigationItem.backBarButtonItem = item;
        item.title = @"返回";

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    //初始化数据
    Type = 1;
    TotalTime = 30;
    Price = 0.0;
    MytableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, MY_WIDTH, MY_HEIGHT) style:UITableViewStyleGrouped];
    MytableView.delegate = self;
    MytableView.dataSource = self;
    [self.view addSubview:MytableView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 1;
            break;
            
        case 1:
            return 8;
            break;
        default:
            break;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *string = [NSString stringWithFormat:@"%d",indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:string];
    if (!cell) {
            NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"zhidingCell" owner:self options:nil];
            cell = [nib objectAtIndex:indexPath.row];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
    if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0:
            {
                if (!firstSegment) {
                    firstSegment = (UISegmentedControl *)[cell viewWithTag:1];
                    [firstSegment addTarget:self action:@selector(chose:) forControlEvents:UIControlEventValueChanged];
                }
            }
                break;
            case 1:{
                if (!startTimeLabel) {
                    startTimeLabel = (UILabel *)[cell viewWithTag:1];
                }
            }
                break;
            case 2:{
                if (!timeLabel) {
                    timeLabel = (UILabel *)[cell viewWithTag:1];
                    timeLabel.text = @"30天";
                }
            }
                break;
            case 3:{
                if (!secondSegment) {
                    secondSegment = (UISegmentedControl *)[cell viewWithTag:1];
                    [secondSegment addTarget:self action:@selector(chose:) forControlEvents:UIControlEventValueChanged];
                }
            }
                break;
            case 4:{
                accountsLabel = (UILabel *)[cell viewWithTag:1];
                accountsLabel.text = [NSString stringWithFormat:@"%.2f元",accounts];
                if (!Sw) {
                    Sw = (UISwitch *)[cell viewWithTag:2];
                    [Sw addTarget:self action:@selector(IsUsedAccount:) forControlEvents:UIControlEventValueChanged];
                }
            }
                break;
            case 5:{
                priceLabel = (UILabel *)[cell viewWithTag:1];
                priceLabel.text = [NSString stringWithFormat:@"%.2f元",Price];
            }
                break;
            case 6:{
                UIButton *certainBtn = (UIButton *)[cell viewWithTag:1];
                [certainBtn addTarget:self action:@selector(certainToTop:) forControlEvents:UIControlEventTouchUpInside];
            }
                break;
                
            default:
                break;
        }
    }
    else{
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"title"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 7, 320, 30)];
        label.text = MyTitle;
        label.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
        label.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:label];
    }
    

    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 7) {
        return 145;
    }
    return 44;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    hud =
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"加载中...";
    [self getOrderArray];
}

//获取数据
-(void)getOrderArray{
    
    __weak ASIFormDataRequest *request;
    
    request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:URL_TOTOP_PRICE]];
    
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
                    ZDone = [resultDict[@"zhiding_yue"] floatValue];
                    ZDthree =[resultDict[@"zhiding_jidu"] floatValue];
                    CCone = [resultDict[@"chuchuang_yue"] floatValue];
                    CCthree = [resultDict[@"chuchuang_jidu"] floatValue];
                    accounts = [resultDict[@"accounts"] floatValue];
                    startTime = [NSString stringWithFormat:@"%@",resultDict[@"servertime"]];
                    startTime = [startTime substringToIndex:10];
                    startTimeLabel.text = startTime;
                    priceLabel.text = [NSString stringWithFormat:@"%.2f元",ZDone];
                    [priceLabel sizeToFit];
                    accountsLabel.text = [NSString stringWithFormat:@"%.2f元",accounts];
                    [accountsLabel sizeToFit];
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

-(IBAction)chose:(id)sender{
    switch (firstSegment.selectedSegmentIndex) {
        case 0:
            switch (secondSegment.selectedSegmentIndex) {
                case 0:
                    Type = 1;
                    timeLabel.text = @"30天";
                    priceLabel.text = [NSString stringWithFormat:@"%.2f元",ZDone];
                    break;
                case 1:
                    Type = 2;
                    timeLabel.text = @"90天";
                    priceLabel.text = [NSString stringWithFormat:@"%.2f元",ZDthree];
                    break;
                default:
                    break;
            }
            break;
        case 1:
            switch (secondSegment.selectedSegmentIndex) {
                case 0:
                    Type = 3;
                     timeLabel.text = @"30天";
                    priceLabel.text = [NSString stringWithFormat:@"%.2f元",CCone];
                    break;
                case 1:
                    Type = 4;
                   timeLabel.text = @"90天";
                    priceLabel.text = [NSString stringWithFormat:@"%.2f元",CCthree];
                    break;
                default:
                    break;
            }
            break;
            
        default:
            break;
    }
}

-(IBAction)IsUsedAccount:(id)sender{
    UISwitch *swic = (UISwitch *)sender;
    if (swic.on) {
        UseAccount = 1;
    }else{
        UseAccount = 0;
    }
}

-(IBAction)certainToTop:(id)sender{
    ViewController *Vc = [[ViewController alloc]init];
    Vc.Type = [NSString stringWithFormat:@"%d",Type];
    Vc.UsedAccout = [NSString stringWithFormat:@"%d",UseAccount];
    Vc.RoomName = self.MyTitle;
    Vc.RoomId = self.roomId;
    [self.navigationController pushViewController:Vc animated:YES];
}


@end
