//
//  iuiueWayForCashViewController.m
//  iuiue
//
//  Created by 赵中良 on 14-5-22.
//  Copyright (c) 2014年 iuiue. All rights reserved.
//

#import "iuiueWayForCashViewController.h"

@interface iuiueWayForCashViewController ()<UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIActionSheetDelegate>
{
    MBProgressHUD *hud;
    NSString *title;
    NSDictionary *MyDic;//默认收款方式数据
}
@end

@implementation iuiueWayForCashViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UIBarButtonItem *item = [[UIBarButtonItem alloc]init];
        self.navigationItem.backBarButtonItem = item;
        item.title = @"返回";
        self.navigationItem.title = @"收款方式";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
   
   
    // Do any additional setup after loading the view from its nib.
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//弹出选择收款方式
-(void)showActionSheet{
    UIActionSheet *ActionSheet = [[UIActionSheet alloc]initWithTitle:@"请选择收款方式" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"支付宝",@"财付通",@"银行卡", nil];
    ActionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [ActionSheet showFromRect:CGRectMake(50, 100, 220, 300) inView:self.view animated:YES];
}

//第一次加载默认收款方式时调用
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//    UIButton *btn = [[UIButton alloc]init];
//    btn = (UIButton *)[self.view viewWithTag:1];
    switch (buttonIndex) {
        case 2:
            title = @"银行卡";
            _myBankTextField.hidden = NO;
            _myBankLabel.hidden = NO;
            _alert1.hidden =NO;
            [_alert2 setFrame:CGRectMake(33, 338, 267, 44)];
            [_changeButton setFrame:CGRectMake(49, 390, 223, 30)];
            
            break;
        case 0:
            title = @"支付宝";
            _myBankTextField.hidden = YES;
            _myBankLabel.hidden = YES;
            _alert1.hidden =YES;
            CGFloat height = 50;
            [_alert2 setFrame:CGRectMake(33, 338 - height, 267, 44)];
            [_changeButton setFrame:CGRectMake(49, 390 - height, 223, 30)];
            
            break;
        case 1:{
            title = @"财付通";
            _myBankTextField.hidden = YES;
            _myBankLabel.hidden = YES;
            _alert1.hidden =YES;
            CGFloat height = 50;
            [_alert2 setFrame:CGRectMake(33, 338 - height, 267, 44)];
            [_changeButton setFrame:CGRectMake(49, 390 - height, 223, 30)];
        }
            break;
            
        default:
            break;
    }
    UITableView *tableview;
    tableview = (UITableView *)[self.view viewWithTag:20];
    [tableview reloadData];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseIdentifier =@"reuseIdentifier";
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    cell.textLabel.text = title;
    cell.backgroundColor = [UIColor lightGrayColor];
    cell.textLabel.font =[UIFont fontWithName:@"Helvetica-Bold" size:14];
    UIImageView *imgV= [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 10, 5)];
    imgV.image = [UIImage imageNamed:@"sanjiao"];
    cell.accessoryView = imgV;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self showActionSheet];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30;
}


//确认修改收款方式
-(IBAction)certainToChange:(id)sender{
    iuiueAllService *service = [[iuiueAllService alloc]init];
    if ([title isEqualToString:@"银行卡"]) {
        [service wayForGetCashDictinaryInit:[NSDictionary dictionaryWithObjectsAndKeys:@"3",@"chargetype",_myNumberTextField.text,@"idcard",_myAccountTextField.text,@"banknum",_nameTextield.text,@"uname",_myBankTextField.text,@"bankname", nil]];
        if (service.error) {
            [[UIApplication sharedApplication].keyWindow makeToast:@"网络连接失败。。。"];
        }
        else{
            NSDictionary *dic = service.diction;
            [[UIApplication sharedApplication].keyWindow makeToast:[dic valueForKey:@"message"]];
        }
    }
    else if([title isEqualToString:@"支付宝"]){
        [service wayForGetCashDictinaryInit:[NSDictionary dictionaryWithObjectsAndKeys:@"1",@"chargetype",_myNumberTextField.text,@"idcard",_myAccountTextField.text,@"banknum",_nameTextield.text,@"uname", nil]];
        if (service.error) {
            [[UIApplication sharedApplication].keyWindow makeToast:@"网络连接失败。。。"];
        }
        else{
            NSDictionary *dic = service.diction;
            [[UIApplication sharedApplication].keyWindow makeToast:[dic valueForKey:@"message"]];
        }

    }
    else if([title isEqualToString:@"财付通"]){
        [service wayForGetCashDictinaryInit:[NSDictionary dictionaryWithObjectsAndKeys:@"2",@"chargetype",_myNumberTextField.text,@"idcard",_myAccountTextField.text,@"banknum",_nameTextield.text,@"uname", nil]];
        if (service.error) {
            [[UIApplication sharedApplication].keyWindow makeToast:@"网络连接失败。。。"];
        }
        else{
            NSDictionary *dic = service.diction;
            [[UIApplication sharedApplication].keyWindow makeToast:[dic valueForKey:@"message"]];
        }

    }
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_myAccountTextField resignFirstResponder];
    [_myBankTextField resignFirstResponder];
    [_myNumberTextField resignFirstResponder];
    [_nameTextield resignFirstResponder];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    CGRect frame = [UIScreen mainScreen].bounds;
    if (textField.frame.origin.y > frame.size.height - 216 - textField.frame.size.height) {
        [self.view setFrame:CGRectMake(frame.origin.x, frame.origin.y - 100, frame.size.width, frame.size.height)];
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (self.view.frame.origin.y == -100) {
        CGRect frame = [UIScreen mainScreen].bounds;
        [self.view setFrame:frame];
    }
}

//收键盘
-(IBAction)dismissKeyBoard
{
    [_nameTextield resignFirstResponder];
    [_myBankTextField resignFirstResponder];
    [_myAccountTextField resignFirstResponder];
    [_myBankTextField resignFirstResponder];
}

//限定只能输入数字或字母
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([textField isEqual:_myNumberTextField]||[textField isEqual:_myAccountTextField]) {
        return [self validateNumber:string];
    }
    return YES;
}

- (BOOL)validateNumber:(NSString*)number {
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789xX"];
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

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
//    UIButton *btn = [[UIButton alloc]init];
//    btn = (UIButton *)[self.view viewWithTag:1];
    switch (buttonIndex) {
        case 2:
            title = @"银行卡";
            
            //切换后置空
            _myBankTextField.text = @"";
            _myAccountTextField.text = @"";
            _nameTextield.text = @"";
            
            
            _myBankTextField.hidden = NO;
            _myBankLabel.hidden = NO;
            _alert1.hidden =NO;
            [_alert2 setFrame:CGRectMake(33, 338, 267, 44)];
            [_changeButton setFrame:CGRectMake(49, 390, 223, 30)];
            
            break;
        case 0:
            title = @"支付宝";
            _myBankTextField.text = @"";
            _myAccountTextField.text = @"";
            _nameTextield.text = @"";
            _myBankTextField.hidden = YES;
            _myBankLabel.hidden = YES;
            _alert1.hidden =YES;
            CGFloat height = 50;
            [_alert2 setFrame:CGRectMake(33, 338 - height, 267, 44)];
            [_changeButton setFrame:CGRectMake(49, 390 - height, 223, 30)];
            
            break;
        case 1:{
            title = @"财付通";
            _myBankTextField.text = @"";
            _myAccountTextField.text = @"";
            _nameTextield.text = @"";
            
            
            _myBankTextField.hidden = YES;
            _myBankLabel.hidden = YES;
            _alert1.hidden =YES;
            CGFloat height = 50;
            [_alert2 setFrame:CGRectMake(33, 338 - height, 267, 44)];
            [_changeButton setFrame:CGRectMake(49, 390 - height, 223, 30)];
        }
            break;
            
        default:
            break;
    }
    UITableView *tableview;
    tableview = (UITableView *)[self.view viewWithTag:20];
    [tableview reloadData];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getMyCharge];
    //加载
    [self viewInit];
}

-(void)getMyCharge{
    //获取钥匙串中得uid与zend
    NSMutableDictionary *usernamepasswordKVPairs = (NSMutableDictionary *)[iuiueCHKeychain load:KEYCHAIN_USERNAMEPASSWORD];
    NSString *uid =[usernamepasswordKVPairs objectForKey:KEYCHAIN_UID];
    NSString *zend = [usernamepasswordKVPairs objectForKey:KEYCHAIN_ZEND];
    __weak ASIFormDataRequest *request;
    
    request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:URL_MY_WAY_FORCASH]];
    
    request.requestMethod = @"POST";
    
    [request addPostValue:uid forKey:@"uid"];
    [request addPostValue:zend forKey:@"zend"];
    
    [request setCompletionBlock:^{
        NSLog(@"%@",request.responseString);
        NSError *error;
        NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingAllowFragments error:&error];
        if (!error) {
            [hud hide:YES];
            switch ([resultDict[@"status"] integerValue]) {
                case 0:{
                    MyDic = [NSDictionary dictionaryWithDictionary:resultDict];
                    [self alertView:[UIAlertView alloc] clickedButtonAtIndex:[resultDict[@"chargetype"] integerValue]-1];
                    //页面加载
                    _nameTextield.text = [NSString stringWithFormat:@"%@",resultDict[@"uname"]];
                    
                    //判断是否为银行卡
                    if ([resultDict[@"chargetype"] integerValue] == 3) {
                        _myBankTextField.text = [NSString stringWithFormat:@"%@",resultDict[@"bankname"]];
                    }
                    _myAccountTextField.text = [NSString stringWithFormat:@"%@",resultDict[@"banknum"]];
                    
                    //判断有没有设置身份证号码
                    if ([resultDict[@"checkidcard"] integerValue] == 1) {
                        _myNumberTextField.text = [NSString stringWithFormat:@"%@",resultDict[@"idcard"]];
                        _myNumberTextField.enabled = NO;
                        _myNumberTextField.textColor = [UIColor grayColor];
                    }
                    else{
                        _alert2.text = @"注意：身份证一经填写保存后将无法修改，请谨慎填写";
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
    
    //获取数据失败处理
    [request setFailedBlock:^{
        NSLog(@"%@",[request.error localizedDescription]);
//        [[UIApplication sharedApplication].keyWindow makeToast:@"网络连接失败，请检查网络设置"];
        hud.labelText = @"加载失败";
        [hud hide:YES afterDelay:1];
    }];
    
    hud =
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"加载中...";
    self.view.backgroundColor = [UIColor grayColor];
    //异步加载
    [request startAsynchronous];
}

-(void)viewInit{
    title = @"银行卡";
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(20, 100, 100, 30)];
    [tableView setTag:20];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    [_changeButton addTarget:self action:@selector(certainToChange:) forControlEvents:UIControlEventTouchUpInside];
    _nameTextield.delegate = self;
    _myNumberTextField.delegate =self;
    _myNumberTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;//输入键盘数字符号键盘
    _myBankTextField.delegate = self;
    _myAccountTextField.delegate =self;
    _myAccountTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;//输入键盘为数字符号键盘
    _myAccountTextField.returnKeyType = UIReturnKeyDone;
    _myNumberTextField.returnKeyType = UIReturnKeyDone;
    _nameTextield.returnKeyType = UIReturnKeyDone;
    _myBankTextField.returnKeyType = UIReturnKeyDone;
 }

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [_nameTextield resignFirstResponder];
    [_myBankTextField resignFirstResponder];
    [_myAccountTextField resignFirstResponder];
    [_myBankTextField resignFirstResponder];
    return YES;
}


@end
