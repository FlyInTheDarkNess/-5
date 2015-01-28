//
//  iuiueloginViewController.m
//  iuiues//
//  Created by 赵中良 on 14-5-14.
//  Copyright (c) 2014年 iuiue. All rights reserved.
//

#import "iuiueloginViewController.h"
#import "iuiueRootViewController.h"
#import "iuiueAllService.h"
#import "iuiueForgetPassWordViewController.h"
#import "Toast+UIView.h"

#import "iuiueChatListViewController.h"
#import "iuiueMainViewController.h"
#import "iuiueMoreViewController.h"
@interface iuiueloginViewController ()<UITextFieldDelegate,TransmitProtocol>
{
    UITextField *userTextField;//用户名输入框
    UITextField *passWordTextField;//密码输入框
    MBProgressHUD *hud;
}

@end

@implementation iuiueloginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UIBarButtonItem *item = [[UIBarButtonItem alloc]init];
        self.navigationItem.backBarButtonItem = item;
        item.title = @"返回";
        // Custom initialization
    }
    return self;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:NO_APNS_JB object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:NO_APNS_BD object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(JieBangTokenOfAPNS) name:NO_APNS_JB object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(ClearNumberOfAPNS) name:NO_APNS_BD object:nil];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    //设置图片
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"woodbird"]];
    [imageView setFrame:CGRectMake((MY_WIDTH - 260)/2, 64, 260 , 145)];
    [self.view addSubview:imageView];
    
//    //读取钥匙串
//    NSMutableDictionary *usernamepasswordKVPairs = (NSMutableDictionary *)[iuiueCHKeychain load:KEYCHAIN_USERNAMEPASSWORD];
//    NSString *zend = [usernamepasswordKVPairs objectForKey:KEYCHAIN_ZEND];
//    if (zend.length >0) {
//        iuiueRootViewController * rootVc = [[iuiueRootViewController alloc]initWithNibName:@"iuiueRootViewController" bundle:nil];
//        [self.navigationController pushViewController:rootVc animated:YES];
//    }
    //登录名textField的创建
    userTextField = [[UITextField alloc]initWithFrame:CGRectMake((MY_WIDTH - 290)/2, imageView.bottom + 10, 290, 50)];
    [self.view addSubview:userTextField];
    userTextField.placeholder = @"用户名";
    [userTextField setBorderStyle:UITextBorderStyleRoundedRect];
    userTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    userTextField.delegate = self;
    userTextField.layer.cornerRadius=4.0f;
    userTextField.layer.masksToBounds=YES;
    userTextField.layer.borderColor=[[UIColor grayColor]CGColor];
    userTextField.layer.borderWidth= 1.0f;
    
    //密码textField的创建
    passWordTextField = [[UITextField alloc]initWithFrame:CGRectMake((MY_WIDTH - 290)/2, userTextField.bottom + 20, 290, 50)];
    passWordTextField.keyboardType = UIKeyboardTypeAlphabet;//输入键盘为英文键盘
    [self.view addSubview:passWordTextField];
    passWordTextField.placeholder = @"密码";
    passWordTextField.layer.cornerRadius=4.0f;
    passWordTextField.layer.masksToBounds=YES;
    passWordTextField.layer.borderColor=[[UIColor grayColor]CGColor];
    passWordTextField.layer.borderWidth= 1.0f;
    [passWordTextField setBorderStyle:UITextBorderStyleRoundedRect];
    passWordTextField.delegate =self;
    [passWordTextField setSecureTextEntry:YES];
    
    //登陆button的创建
    UIButton *loginButton = [[UIButton alloc]initWithFrame:CGRectMake((MY_WIDTH - 240)/2, passWordTextField.bottom + 20, 240, 50)];
    [self.view addSubview:loginButton];
    [loginButton setTitle:@"登陆" forState:UIControlStateNormal];
    loginButton.layer.cornerRadius = 25;
    loginButton.tintColor = [UIColor blackColor];
    [loginButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    loginButton.backgroundColor = [UIColor yellowColor];
    [loginButton addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *forgetPassWordButton = [[UIButton alloc]initWithFrame:CGRectMake(loginButton.right - 90, loginButton.bottom + 20, 60, 10)];
    forgetPassWordButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
    [forgetPassWordButton setTitle:@"忘记密码" forState:UIControlStateNormal];
    [forgetPassWordButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [forgetPassWordButton addTarget:self action:@selector(forgetPassWord:) forControlEvents:UIControlEventTouchUpInside];
    
    
//    //给textfield 键盘上添加按钮
//    UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
//    [topView setBarStyle:UIBarStyleBlack];
//    
//    UIBarButtonItem * helloButton = [[UIBarButtonItem alloc]initWithTitle:@"Hello" style:UIBarButtonItemStyleBordered target:self action:nil];
//    
//    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
//    
//    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyBoard)];
//    
//    
//    NSArray * buttonsArray = [NSArray arrayWithObjects:helloButton,btnSpace,doneButton,nil];
//    
//    [topView setItems:buttonsArray];
//    [userTextField setInputAccessoryView:topView];
//    [passWordTextField setInputAccessoryView:topView];
    
    
    [self.view addSubview:forgetPassWordButton];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
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
-(IBAction)login:(id)sender{
    
    [userTextField resignFirstResponder];
    [passWordTextField resignFirstResponder];
    if (self.view.frame.origin.y != 0) {
        [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + 150, self.view.frame.size.width, self.view.frame.size.height)];
    }
    __weak ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:URL_NEW_LOGIN]];
    
    [request addPostValue:userTextField.text forKey:@"mobile"];
    [request addPostValue:passWordTextField.text forKey:@"password"];
    
    
    //request.requestMethod = @"POST";
    
    
    [request setCompletionBlock:^{
        NSLog(@"%@",request.responseString);
        NSError *error;
        [hud hide:YES];
        NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingAllowFragments error:&error];
        if (!error) {
            
            if([resultDict[@"status"]intValue] == 0){
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self LoginToMainVC: YES];//跳转到主页
                });
                [[UIApplication sharedApplication].keyWindow makeToast:@"登陆成功"];
                
                NSMutableDictionary *usernamepasswordKVPairs = [NSMutableDictionary dictionary];
                [usernamepasswordKVPairs setObject:[resultDict valueForKey:@"uid"] forKey:KEYCHAIN_UID];
                [usernamepasswordKVPairs setObject:[resultDict valueForKey:@"zend"] forKey:KEYCHAIN_ZEND];
                //房东店铺名称存储
                [usernamepasswordKVPairs setObject:[resultDict valueForKey:@"username"] forKey:KEYCHAIN_OWNERNAME];
                [iuiueCHKeychain save:KEYCHAIN_USERNAMEPASSWORD data:usernamepasswordKVPairs];
                [iuiueCHKeychain save:KEYCHAIN_UUID data:resultDict[@"urnd"]];
                [iuiueCHKeychain save:KEYCHAIN_UZEND data:resultDict[@"uzend"]];
                
                //1. 创建一个plist文件
//                NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
//                NSString *path=[paths objectAtIndex:0];
//                NSLog(@"path = %@",path);
//                NSString *name = [NSString stringWithFormat:@"%@.plist",MY_UID];
//                NSString *filename=[path stringByAppendingPathComponent:name];
//                
//                NSDictionary* dic2 = [NSDictionary dictionaryWithContentsOfFile:filename];
//                NSLog(@"dic is:%@",dic2);
//                if (!dic2) {
//                    NSFileManager* fm = [NSFileManager defaultManager];
//                    [fm createFileAtPath:filename contents:nil attributes:nil];
                    //NSDictionary* dic = [NSDictionary dictionaryWithContentsOfFile:plistPath];
                    
//                    //创建一个dic，写到plist文件里
//                    NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:@"sina",@"1",@"163",@"2",nil];
//                    [dic writeToFile:filename atomically:YES];
//                    NSDictionary *dic1 = [NSDictionary dictionaryWithObjectsAndKeys:@"tian",@"1",nil];
//                    [dic1 writeToFile:filename atomically:YES];
//                }
//                NSDictionary *dic1 = [NSDictionary dictionaryWithObjectsAndKeys:@"tian",@"1",nil];
//                [dic1 writeToFile:filename atomically:YES];
                
                
                //读文件

            }else{
                NSString *srr = [NSString stringWithFormat:@"%@",resultDict[@"message"]];
                [[UIApplication sharedApplication].keyWindow makeToast:srr];
            }
            
        }else{
            [hud hide:YES];
            NSString *srr = [NSString stringWithFormat:@"%@",resultDict[@"message"]];
            [[UIApplication sharedApplication].keyWindow makeToast:srr];
        }
    }
     ];
    [request setFailedBlock:^{
        [[UIApplication sharedApplication].keyWindow makeToast:@"网络连接失败，请检查网络设置"];
    }];
    [request startAsynchronous];
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    hud.labelText = @"正在登陆...";

    
    //
    
}

//点击空白处收起键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [userTextField resignFirstResponder];
    [passWordTextField resignFirstResponder];
    if (self.view.frame.origin.y != 0) {
        [self.view MoveView:self.view  To:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + 150, self.view.frame.size.width, self.view.frame.size.height) During:0.2];
    }
}

//开始输入时改变边框为实线
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    NSLog(@"%@",textField.layer);
    NSLog(@"%f",self.view.frame.origin.y);
    if ((int)self.view.frame.origin.y == 0) {
        [self.view MoveView:self.view  To:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y - 150, self.view.frame.size.width, self.view.frame.size.height) During:0.2];
        NSLog(@"%f",self.view.frame.origin.y);
//        [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y - 150, self.view.frame.size.width, self.view.frame.size.height)];
    }
    [textField setBorderStyle:UITextBorderStyleLine];
    textField.layer.cornerRadius=8.0f;
    textField.layer.masksToBounds=YES;
    textField.layer.borderColor=[[UIColor yellowColor]CGColor];
    textField.layer.borderWidth= 3.0f;
}

//结束输入时改变边框为虚线
-(void)textFieldDidEndEditing:(UITextField *)textField{
    [textField setBorderStyle:UITextBorderStyleRoundedRect];
    textField.layer.cornerRadius=4.0f;
    textField.layer.masksToBounds=YES;
    textField.layer.borderColor=[[UIColor grayColor]CGColor];
    textField.layer.borderWidth= 1.0f;
}

-(void)showView :(NSString *)string
{
    NSLog(@"%@",string);
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:string delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
//    //读取钥匙串
//    NSMutableDictionary *usernamepasswordKVPairs = (NSMutableDictionary *)[iuiueCHKeychain load:KEYCHAIN_USERNAMEPASSWORD];
//    NSString *zend = [usernamepasswordKVPairs objectForKey:KEYCHAIN_ZEND];
    if (MY_UUID.length >0&&MY_ZEND.length > 0) {
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
            //老版首页
            //            iuiueRootViewController * rootVc = [[iuiueRootViewController alloc]initWithNibName:@"iuiueRootViewController" bundle:nil];
            
            [self LoginToMainVC:NO];
            
//        });
    }

}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

-(IBAction)forgetPassWord:(id)sender{
    iuiueForgetPassWordViewController *forgetPWC = [[iuiueForgetPassWordViewController alloc]initWithNibName:@"iuiueForgetPassWordViewController" bundle:nil];
    [self.navigationController pushViewController:forgetPWC animated:YES];

//    [self presentViewController:forgetPWC animated:YES completion:nil];
}

//限定只能输入数字或字母
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([textField isEqual:userTextField]) {
        return [self validateNumber1:string];
    }
    return [self validateNumber:string];
}

- (BOOL)validateNumber:(NSString*)number {
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM"];
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
- (BOOL)validateNumber1:(NSString*)number {
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
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

//收起键盘，已更改停用
/*
-(IBAction)dismissKeyBoard
{
    [userTextField resignFirstResponder];
    [passWordTextField resignFirstResponder];
}
 */


//点击键盘上的
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [userTextField resignFirstResponder];
    [passWordTextField resignFirstResponder];
    
    //收起键盘时，让画面滑回原处
    if (self.view.frame.origin.y != 0) {
        [self.view MoveView:self.view  To:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + 150, self.view.frame.size.width, self.view.frame.size.height) During:0.2];
    }
    return YES;
}

-(void)Transmit:(NSString *)string{
    [[UIApplication sharedApplication].keyWindow makeToast:string];
}

//跳转主页
-(void)LoginToMainVC:(BOOL)UpDown{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NO_APNS_BD object:nil];
    iuiueMainViewController *rootVc = [[iuiueMainViewController alloc]init];
    iuiueChatListViewController *myEarn = [[iuiueChatListViewController alloc]init];
    myEarn.title = @"聊天";
    iuiueMoreViewController *setting = [[iuiueMoreViewController alloc]init];
    UINavigationController *nav1 = [[UINavigationController alloc]initWithRootViewController:myEarn];
    UINavigationController *nav2 = [[UINavigationController alloc]initWithRootViewController:rootVc];
    UINavigationController *nav3 = [[UINavigationController alloc]initWithRootViewController:setting];
    UITabBarController *tabar = [[UITabBarController alloc]init];
    //设置tabbar的颜色
    [tabar.tabBar setTintColor:[UIColor orangeColor]];
    
    tabar.viewControllers = @[nav1,nav2 ,nav3];
    if ([UIApplication sharedApplication].applicationIconBadgeNumber>99) {
        nav1.tabBarItem.badgeValue = @"99+";
    }else if([UIApplication sharedApplication].applicationIconBadgeNumber>0){
        nav1.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d",[UIApplication sharedApplication].applicationIconBadgeNumber];
    }else{
        nav1.tabBarItem.badgeValue = nil;
    }
    
    nav1.tabBarItem.image = [UIImage imageNamed:@"收益"];
    nav1.tabBarItem.title = @"聊天";
    nav2.tabBarItem.image = [UIImage imageNamed:@"首页"];
    nav2.tabBarItem.title = @"首页";
    nav3.tabBarItem.image = [UIImage imageNamed:@"设置"];
    nav3.tabBarItem.title = @"设置";
    [tabar setSelectedIndex:1];
    [self presentViewController:tabar animated:UpDown completion:nil];
    [myEarn BeginWeb];
}


-(void)JieBangTokenOfAPNS{
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    __weak ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:URL_JIEBANG_TOKEN]];
    
    request.requestMethod = @"POST";
    
    [request addPostValue:MY_TOKEN forKey:@"devicetoken"];
    NSLog(@"%@",MY_TOKEN);
    [request addPostValue:@"1" forKey:@"type"];
    [request addPostValue:@"0" forKey:@"os"];
    
    //    NSLog(@"%@",MY_TOKEN);
    [request setCompletionBlock:^{
        NSLog(@"%@",request.responseString);
        NSError *error;
        NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingAllowFragments error:&error];
        if (!error) {
            if ([resultDict[@"success"] boolValue] ) {
                NSLog(@"解除推送token成功");
                
            }else{
                [[UIApplication sharedApplication].keyWindow makeToast:resultDict[@"error_msg"] duration:1.5 position:@"center"];
            }
        }else{
            NSLog(@"%@",[error localizedDescription]);
        }
    }];
    
    [request setFailedBlock:^{
        //        [hud hide:YES];
        NSLog(@"%@",[request.error localizedDescription]);
        //        [self.view makeToast:@"网络连接失败，请检查网络设置" duration:1.0f position:@"center"];
        
    }];
    [request startAsynchronous];
}

-(void)ClearNumberOfAPNS{
    __weak ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:URL_BANGDING_TOKEN]];
    
    NSString *number = [NSString stringWithFormat:@"%d",[UIApplication sharedApplication].applicationIconBadgeNumber];
    request.requestMethod = @"POST";
    [request addPostValue:MY_UID forKey:@"uid"];
    [request addPostValue:@"1" forKey:@"utype"];
    [request addPostValue:MY_UUID forKey:@"urnd"];
    [request addPostValue:MY_UZEND forKey:@"uzend"];
    [request addPostValue:MY_TOKEN forKey:@"devicetoken"];
    [request addPostValue:number forKey:@"msgcount"];
    [request addPostValue:@"0" forKey:@"os"];
    
    //    NSLog(@"%@",MY_TOKEN);
    [request setCompletionBlock:^{
        NSLog(@"%@",request.responseString);
        NSError *error;
        NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingAllowFragments error:&error];
        if (!error) {
            if ([resultDict[@"success"] boolValue] ) {
                NSLog(@"登陆修改推送数量成功");
                [UIApplication sharedApplication].applicationIconBadgeNumber = [number integerValue];
            }else{
//                [[UIApplication sharedApplication].keyWindow makeToast:resultDict[@"error_msg"] duration:1.5 position:@"center"];
            }
        }else{
            NSLog(@"%@",[error localizedDescription]);
        }
    }];
    
    [request setFailedBlock:^{
        //        [hud hide:YES];
        NSLog(@"%@",[request.error localizedDescription]);
        //        [self.view makeToast:@"网络连接失败，请检查网络设置" duration:1.0f position:@"center"];
        
    }];
    [request startAsynchronous];
}


@end
