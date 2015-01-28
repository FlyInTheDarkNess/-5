//
//  iuiueGetcashiViewController.m
//  木鸟房东端
//
//  Created by 赵中良 on 14-8-20.
//  Copyright (c) 2014年 iuiue. All rights reserved.
//

#import "iuiueGetcashiViewController.h"
#import "iuiueOrderTableViewController.h"
#import "iuiueWayForCashViewController.h"
#import "iuiueCashDetailViewController.h"

@interface iuiueGetcashiViewController ()<UITextFieldDelegate,UITextViewDelegate,UIAlertViewDelegate>
{
    BOOL isOn;
    //    UISegmentedControl *mySegement;
    UIScrollView *MyScrollView;
    UILabel *firstLabel;
    UILabel *secondLabel;
    UILabel *thirdLabel;
    MBProgressHUD *hud;
}


@end

@implementation iuiueGetcashiViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UIBarButtonItem *item = [[UIBarButtonItem alloc]init];
        self.navigationItem.backBarButtonItem = item;
        item.title = @"返回";
        self.navigationItem.title = @"提取现金";
//        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(fanhui)];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"租币详情" style:UIBarButtonItemStyleBordered target:self action:@selector(detailButtonClick:)];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.hidden = NO;//取消翻滚后的效果
    
    
    _myRent = [[UILabel alloc]initWithFrame:CGRectMake(0, 64, MY_WIDTH, 20)];
    _myRent.text = @"   您拥有租币 正在查询 租币";
    _myRent.textAlignment = NSTextAlignmentLeft;
    _myRent.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:_myRent];
    
    
    
    //    mySegement = [[UISegmentedControl alloc]initWithItems:@[@"我的租币",@"租币明细",@"提现纪录"]];
    //    [mySegement setFrame:CGRectMake(20, MY_HEIGHT - 60, 280, 40)];
    //    [self.view addSubview:mySegement];
    
    MyScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, _myRent.bottom, MY_WIDTH, MY_HEIGHT - 84)];
    [self.view addSubview:MyScrollView];
    
    UILabel *labelOne = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, 20, 30)];
    labelOne.text = @"申请提现金额";
    [labelOne sizeToFit];
    [MyScrollView addSubview:labelOne];
    _numberOfCash = [[UITextField alloc]initWithFrame:CGRectMake(labelOne.right + 5, labelOne.top - 5, 120, 40)];
    [_numberOfCash setBorderStyle:UITextBorderStyleRoundedRect];
    _numberOfCash.placeholder = @"在此输入金额";
    
    _numberOfCash.layer.cornerRadius=4.0f;
    _numberOfCash.layer.masksToBounds=YES;
    _numberOfCash.layer.borderColor=[[UIColor grayColor]CGColor];
    _numberOfCash.layer.borderWidth= 1.0f;
    [MyScrollView addSubview:_numberOfCash];
    UILabel *labelTwo = [[UILabel alloc]initWithFrame:CGRectMake(_numberOfCash.right + 5, labelOne.top, 20, 30)];
    labelTwo.text = @"租币";
    [labelTwo sizeToFit];
    [MyScrollView addSubview:labelTwo];
    
    UILabel *labelThree = [[UILabel alloc]initWithFrame:CGRectMake(20, _numberOfCash.bottom + 10, 20, 30)];
    labelThree.text = @"备注：";
    [labelThree sizeToFit];
    [MyScrollView addSubview:labelThree];
    
    _detail = [[UITextView alloc]initWithFrame:CGRectMake(40, labelThree.bottom + 10, MY_WIDTH - 80, 130)];
    _detail.layer.cornerRadius = 10.0f;
    _detail.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [MyScrollView addSubview:_detail];
    
    _grayTextLabel = [[UILabel alloc]initWithFrame:CGRectMake(45, labelThree.bottom + 20, 20, 20)];
    _grayTextLabel.text = @"留下您的要求";
    _grayTextLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
    _grayTextLabel.textColor = [UIColor grayColor];
    [_grayTextLabel sizeToFit];
    [MyScrollView addSubview:_grayTextLabel];
    
    _getCash = [[UIButton alloc]initWithFrame:CGRectMake(MY_WIDTH/2 - 40, _detail.bottom + 10, 80, 40)];
    [_getCash setTitle:@"确认提现" forState:UIControlStateNormal];
    _getCash.layer.cornerRadius = 5.0f;
    [_getCash addTarget:self action:@selector(certainToGetCash:) forControlEvents:UIControlEventTouchUpInside];
    [_getCash setBackgroundColor:[UIColor yellowColor]];
    [_getCash setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [MyScrollView addSubview:_getCash];
    
    UILabel *labelFour = [[UILabel alloc]initWithFrame:CGRectMake(20, _getCash.bottom + 10, MY_WIDTH - 40, 30)];
    labelFour.text = @"温馨提示：满200元可免费提现，如果低于200元强制提现，收取银行手续费2元。";
    labelFour.numberOfLines = 0;
    [labelFour sizeToFit];
    [MyScrollView addSubview:labelFour];
    
    
    _hint = [[UILabel alloc]initWithFrame:CGRectMake(labelFour.left, labelFour.bottom + 10, labelFour.width, 20)];
    _hint.text = @"温馨提示：您还有未收取的定金哦！";
    _hint.textColor = [UIColor redColor];
    [_hint sizeToFit];
    [MyScrollView addSubview:_hint];
    
    _returnToOrder = [[UIButton alloc]initWithFrame:CGRectMake(_detail.left, _hint.bottom + 10, _detail.width, 30)];
    [_returnToOrder setTitle:@"点击这里收取" forState:UIControlStateNormal];
    _returnToOrder.layer.cornerRadius = 5.0f;
    [_returnToOrder addTarget:self action:@selector(pushToOrder:) forControlEvents:UIControlEventTouchUpInside];
    [_returnToOrder setBackgroundColor:[UIColor greenColor]];
    [_returnToOrder setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [MyScrollView addSubview:_returnToOrder];
    
    [MyScrollView setContentSize:CGSizeMake(MY_WIDTH, _returnToOrder.bottom + 40)];
    
    
    
    
    
    //添加收键盘
    _numberOfCash.delegate = self;
    _numberOfCash.keyboardType = UIKeyboardTypeDecimalPad;//输入键盘为九宫格数字键
    _detail.delegate = self;//设置delegate
    //    [self viewInit];
    [_getCash addTarget:self action:@selector(certainToGetCash:) forControlEvents:UIControlEventTouchUpInside];
    [_returnToOrder addTarget:self action:@selector(pushToOrder:) forControlEvents:UIControlEventTouchUpInside];
    
    UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, MY_WIDTH, 30)];
    [topView setBarStyle:UIBarStyleBlack];
    
    UIBarButtonItem * helloButton = [[UIBarButtonItem alloc]initWithTitle:@"Hello" style:UIBarButtonItemStyleBordered target:self action:nil];
    
    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyBoard)];
    
    
    NSArray * buttonsArray = [NSArray arrayWithObjects:helloButton,btnSpace,doneButton,nil];
    
    [topView setItems:buttonsArray];
    [_detail setInputAccessoryView:topView];
    [_numberOfCash setInputAccessoryView:topView];

    // Do any additional setup after loading the view.
}

//跳转返回
-(void)fanhui{
//    self.navigationController.navigationBar.hidden = YES;
    [self dismissFlipWithCompletion:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)certainToGetCash:(id)sender{
    
    iuiueAllService *service1 = [[iuiueAllService alloc]init];
    if (![service1 isConnectionAvailable]) {
        [[UIApplication sharedApplication].keyWindow makeToast:@"网络连接失败...请检查网络设置" duration:1 position:@"center"];
        return;
    }
    if (isOn) {
        [self showView];
    }
    else{
        iuiueAllService *service = [[iuiueAllService alloc]init];
        NSLog(@"提现金额：%@",_numberOfCash);
        [service applyforCashDictionaryInit:[NSDictionary dictionaryWithObjectsAndKeys:_numberOfCash.text,@"cashmoney",_detail.text,@"remark", nil]];
        if (service.error == nil) {
            NSDictionary *dic = service.diction;
            if ([[dic valueForKey:@"status"] integerValue] == 0) {
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您的提现申请已受理，请在3个工作日内查询账户" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert setTag:1];
                alert.delegate = self;
                [alert show];
            }
            else{
                //提款失败提示
                [[UIApplication sharedApplication].keyWindow makeToast:[dic valueForKey:@"message"] duration:1 position:@"center"];
            }
            iuiueAllService *service2 = [[iuiueAllService alloc]init];
            
            [service2 landlordRentDictionaryInit:[NSDictionary dictionary]];
            
            // 获取数据成功处理
            if (service.error == nil) {
                NSDictionary *dic = service2.diction;
                _myRent.text =[NSString stringWithFormat:@"   您拥有租币 %5.2f 租币",[[dic valueForKey:@"accounts"] floatValue]];
                //        [[UIApplication sharedApplication].keyWindow makeToast:[dic valueForKey:@"message"]];
                //成功显示
                NSString *hashire = [NSString stringWithFormat:@"%@",[dic valueForKey:@"hashire"]];
                if ([hashire isEqualToString:@"true"]) {
                    _hint.hidden = YES;
                    _returnToOrder.hidden = YES;
                }
            }
        }
        else{
            [[UIApplication sharedApplication].keyWindow makeToast:service.error];
        }
        //刷新界面
    }
}

-(void)viewInit{
    
    iuiueAllService *service1 = [[iuiueAllService alloc]init];
    if (![service1 isConnectionAvailable]) {
        [[UIApplication sharedApplication].keyWindow makeToast:@"网络连接失败...请检查网络设置" duration:1 position:@"center"];
        return;
    }
    //重置输入
    _detail.text =@"";
    _numberOfCash.text =@"";
    
    iuiueAllService *service = [[iuiueAllService alloc]init];
    
    [service landlordRentDictionaryInit:[NSDictionary dictionary]];
    
    // 获取数据成功处理
    if (service.error == nil) {
        NSDictionary *dic = service.diction;
        _myRent.text =[NSString stringWithFormat:@"   您拥有租币 %5.2f 租币",[[dic valueForKey:@"accounts"] floatValue]];
        //        [[UIApplication sharedApplication].keyWindow makeToast:[dic valueForKey:@"message"]];
        //成功显示
        NSString *hashire = [NSString stringWithFormat:@"%@",[dic valueForKey:@"hashire"]];
        NSString *charge = [NSString stringWithFormat:@"%@",[dic valueForKey:@"charge"]];
        if ([hashire isEqualToString:@"0"]) {
            _hint.hidden = YES;
            _returnToOrder.hidden = YES;
        }
        if ([charge isEqualToString:@"1"]) {
            [[UIApplication sharedApplication].keyWindow makeToast:@"您已设置收款方式"];
            isOn = NO;
        }
        else{
            isOn = YES;
            [self showView];
        }
    }
    //获取数据失败处理
    else{
        
        [[UIApplication sharedApplication].keyWindow makeToast:service.error];
    }
}

-(void)viewOneInit{
    _myRent.text = @"共有 待查询 条";
    _myRent.backgroundColor = [UIColor blueColor];
    _myRent.textAlignment = NSTextAlignmentRight;
    
    firstLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, _myRent.bottom, MY_WIDTH/4, 20)];
    firstLabel.text = @"时间";
    firstLabel.textAlignment = NSTextAlignmentCenter;
    firstLabel.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:firstLabel];
    
    secondLabel = [[UILabel alloc]initWithFrame:CGRectMake(firstLabel.right, firstLabel.top, MY_WIDTH/2, 20)];
    secondLabel.text = @"描述";
    secondLabel.textAlignment = NSTextAlignmentCenter;
    secondLabel.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:secondLabel];
    
    thirdLabel = [[UILabel alloc]initWithFrame:CGRectMake(secondLabel.right, secondLabel.top, MY_WIDTH/4, 20)];
    thirdLabel.text = @"租币";
    thirdLabel.textAlignment = NSTextAlignmentCenter;
    thirdLabel.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:thirdLabel];
}



//限定只能输入数字
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    return [self validateNumber:string];
}

- (BOOL)validateNumber:(NSString*)number {
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789."];
    int i = 0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return res;
}
-(void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length > 0) {
        _grayTextLabel.hidden = YES;
    }
    else{
        _grayTextLabel.hidden = NO;
    }
}

-(IBAction)pushToOrder:(id)sender{
    iuiueAllService *service1 = [[iuiueAllService alloc]init];
    if (![service1 isConnectionAvailable]) {
        [[UIApplication sharedApplication].keyWindow makeToast:@"网络连接失败...请检查网络设置" duration:1 position:@"center"];
        return;
    }
    iuiueOrderTableViewController *order = [[iuiueOrderTableViewController alloc]init];
    order.number = 8;
    order.title = @"可收取订单";
    [self.navigationController pushViewController:order animated:YES];
}

//避免被键盘挡住
-(void)textViewDidBeginEditing:(UITextView *)textView{
    CGRect frame = [UIScreen mainScreen].bounds;
    if (textView.frame.origin.y > frame.size.height - 216 - textView.frame.size.height) {
        [self.view setFrame:CGRectMake(frame.origin.x, frame.origin.y - 50, frame.size.width, frame.size.height)];
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    if (self.view.frame.origin.y == -50) {
        CGRect frame = [UIScreen mainScreen].bounds;
        [self.view setFrame:frame];
    }
}


-(IBAction)dismissKeyBoard
{
    [_detail resignFirstResponder];
    [_numberOfCash resignFirstResponder];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self viewInit];
}

//点击确定后返回首页
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0 && alertView.tag == 1 ) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if(buttonIndex == 1){
        iuiueWayForCashViewController *change = [[iuiueWayForCashViewController alloc]initWithNibName:@"iuiueWayForCashViewController" bundle:nil];
        [self.navigationController pushViewController:change animated:YES];
    }
}

//未设置收款方式处理
-(void)showView{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您尚未设置收款方式，是否马上设置？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.delegate = self;
    [alert show];
}

-(IBAction)detailButtonClick:(id)sender{
    iuiueCashDetailViewController *cashDetail = [[iuiueCashDetailViewController alloc]init];
    [self.navigationController pushViewController:cashDetail animated:YES];
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
