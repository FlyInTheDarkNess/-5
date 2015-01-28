//
//  iuiueOrderDetailViewController.m
//  iuiue
//
//  Created by 赵中良 on 14-5-21.
//  Copyright (c) 2014年 iuiue. All rights reserved.
//

#import "iuiueOrderDetailViewController.h"

@interface iuiueOrderDetailViewController (){
    UIWebView *phoneCallWebView;
    UIButton * lianxiButton;
}

@property (strong, nonatomic) IBOutlet UIView *myView;
@property (strong, nonatomic) IBOutlet UIScrollView *myscrollView;
@property (weak, nonatomic) IBOutlet UIButton *getCash;
- (IBAction)getCash:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *orderId;
@property (weak, nonatomic) IBOutlet UILabel *orderDate;
@property (weak, nonatomic) IBOutlet UILabel *orderStatus;
@property (weak, nonatomic) IBOutlet UILabel *roomTitle;
@property (weak, nonatomic) IBOutlet UILabel *roomName;
@property (weak, nonatomic) IBOutlet UILabel *totalPrice;
@property (weak, nonatomic) IBOutlet UILabel *prepay;
@property (weak, nonatomic) IBOutlet UILabel *startDate;
@property (weak, nonatomic) IBOutlet UILabel *endDate;
@property (weak, nonatomic) IBOutlet UILabel *rent_type;
@property (weak, nonatomic) IBOutlet UILabel *rent_number;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *peopleNumber;
@property (weak, nonatomic) IBOutlet UILabel *refundtype;





@end

@implementation iuiueOrderDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UIBarButtonItem *item = [[UIBarButtonItem alloc]init];
        self.navigationItem.backBarButtonItem = item;
        item.title = @"返回";
        self.navigationItem.title = @"订单详情";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _getCash.hidden = YES;
    [_myscrollView addSubview:_myView];
    [_myscrollView setFrame:[UIScreen mainScreen].applicationFrame];
    [_myscrollView setContentSize:CGSizeMake(MY_WIDTH,744)];
    _orderId.text = [NSString stringWithFormat:@"%@",[_dic valueForKey:@"ordernum"]];
    _orderDate.text =[NSString stringWithFormat:@"%@",[_dic valueForKey:@"adddate"]];
    _roomTitle.text = [NSString stringWithFormat:@"%@",[_dic valueForKey:@"title"]];
    _roomName.text = [NSString stringWithFormat:@"%@",[_dic valueForKey:@"title2"]];
    _totalPrice.text = [NSString stringWithFormat:@"%@",[_dic valueForKey:@"total_price"]];
    _prepay.text = [NSString stringWithFormat:@"%@",[_dic valueForKey:@"prepay_price"]];
    _startDate.text = [NSString stringWithFormat:@"%@",[_dic valueForKey:@"start_date"]];
    _endDate.text = [NSString stringWithFormat:@"%@",[_dic valueForKey:@"end_date"]];
    _rent_type.text = [NSString stringWithFormat:@"%@",[_dic valueForKey:@"rent_type"]];
    _rent_number.text = [NSString stringWithFormat:@"%@",[_dic valueForKey:@"sameroom"]];
    _username.text = [NSString stringWithFormat:@"%@",[_dic valueForKey:@"username"]];
    _peopleNumber.text = [NSString stringWithFormat:@"%@",[_dic valueForKey:@"rentnumber"]];
    _refundtype.text = [NSString stringWithFormat:@"%@",[_dic valueForKey:@"refundtype"]];
    _refundtype.numberOfLines = 0;
    [_refundtype sizeThatFits:CGSizeMake(200, 60)];
    switch (_number) {
        case 0:
            _orderStatus.text = @"待确认";
            break;
        case 1:
            _orderStatus.text = @"待付款";
            break;
        case 2:{
            _orderStatus.text = @"已付款";
            UILabel *phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(_refundtype.frame.origin.x - 80, _refundtype.frame.origin.y +_refundtype.frame.size.height + 30, 80, 30)];
            phoneLabel.text = @"联系电话：";
            phoneLabel.font = _orderId.font;
            
            lianxiButton = [[UIButton alloc]initWithFrame:CGRectMake(phoneLabel.frame.origin.x + 80, phoneLabel.frame.origin.y, 180, 30)];
            [lianxiButton setBackgroundColor:[UIColor greenColor]];
            [lianxiButton setTitle:[_dic valueForKey:@"mobile"] forState:UIControlStateNormal];
            [lianxiButton addTarget:self action:@selector(call:) forControlEvents:UIControlEventTouchUpInside];
            lianxiButton.layer.cornerRadius = 5;
            [_myscrollView addSubview:phoneLabel];
            [_myscrollView addSubview:lianxiButton];
            
            
        }
            break;
        case 3:
            _orderStatus.text = @"已完成";
            break;
        case 4:
            _orderStatus.text = @"待处理退款";
            break;
        case 5:
            _orderStatus.text = @"已退款";
            break;
        case 6:
            _orderStatus.text = @"已拒绝";
            break;
        case 7:
            _orderStatus.text = @"已过确认时间";
            break;
        case 8:
            _orderStatus.text = @"可以收取定金";
            _getCash.hidden = NO;
            [_getCash setTitle:@"点击收取定金" forState:UIControlStateNormal];
            break;
            
        default:
            break;
    }
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)getCash:(id)sender {
    iuiueAllService *service = [[iuiueAllService alloc]init];
    [service getDepositDictionaryInit:[NSDictionary dictionaryWithObjectsAndKeys:[_dic valueForKey:@"orderid"],@"orderid", nil]];
    NSDictionary *dic = service.diction;
    [[UIApplication sharedApplication].keyWindow makeToast:[dic valueForKey:@"message"]];
}

- (IBAction)call:(id)sender {
    
    NSString *phoneNum = lianxiButton.titleLabel.text;// 电话号码
    NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",phoneNum]];
    if ( !phoneCallWebView ) {
        phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];// 这个webView只是一个后台的View 不需要add到页面上来  效果跟方法二一样 但是这个方法是合法的
    }
    [phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
}


@end
