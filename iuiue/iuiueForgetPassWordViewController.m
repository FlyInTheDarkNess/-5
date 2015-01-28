//
//  iuiueForgetPassWordViewController.m
//  iuiue
//
//  Created by 赵中良 on 14-5-20.
//  Copyright (c) 2014年 iuiue. All rights reserved.
//

#import "iuiueForgetPassWordViewController.h"

@interface iuiueForgetPassWordViewController ()<UITextFieldDelegate>

@end

@implementation iuiueForgetPassWordViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UIBarButtonItem *item = [[UIBarButtonItem alloc]init];
        self.navigationItem.backBarButtonItem = item;
        item.title = @"返回";
        self.navigationItem.title =@"密码找回";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _changeButton.layer.cornerRadius = 5;//圆角
    _mobileNumber.delegate = self;
    _captcha.delegate = self;
    _firstPassWord.delegate = self;
    _secondPassWord.delegate =self;
    _mobileNumber.keyboardType = UIKeyboardTypeNumbersAndPunctuation;//输入键盘为数字键
    _captcha.keyboardType = UIKeyboardTypeNumbersAndPunctuation;//输入键盘为数字键
    _firstPassWord.keyboardType = UIKeyboardTypeNamePhonePad;//输入键盘为英文键盘
    _secondPassWord.keyboardType = UIKeyboardTypeNamePhonePad;//输入键盘为英文键盘可改
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)getCaptcha:(id)sender {
    if (_mobileNumber.text.length == 11) {
        iuiueAllService *service = [[iuiueAllService alloc]init];
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:_mobileNumber.text,@"mobile", nil];
        [service captchaDictionaryInit:dic];
        if (service.error.length < 1) {
            [[UIApplication sharedApplication].keyWindow makeToast:@"网络连接失败，请检查网络设置"];
        }
        else{
            [[UIApplication sharedApplication].keyWindow makeToast:[dic valueForKey:@"message"]];
        }

    }
    else{
       [[UIApplication sharedApplication].keyWindow makeToast:@"请输入11位有效数字"];
    }
}

- (IBAction)change:(id)sender {
    iuiueAllService *service = [[iuiueAllService alloc]init];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:_mobileNumber.text,@"mobile",_captcha.text,@"vaildatecode",_firstPassWord.text,@"password", nil];
    if ([service passwordFindDictionaryInit:dic]) {
        NSString *str = [NSString stringWithFormat:@"%@",[service.diction valueForKey:@"status"]];
        if ([str isEqualToString:@"0"]) {
            [[UIApplication sharedApplication].keyWindow makeToast:@"密码修改成功，请使用新密码登陆"];
        }
        else{
            [[UIApplication sharedApplication].keyWindow makeToast:[dic valueForKey:@"message"]];
        }
    }
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_captcha resignFirstResponder];
    [_mobileNumber resignFirstResponder];
    [_firstPassWord resignFirstResponder];
    [_secondPassWord resignFirstResponder];
}
//限定只能输入数字或字母
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([textField isEqual:_mobileNumber]) {
       return [self validateNumber:string];
    }
    else{
    return [self validateWord:string];
    }
    return NO;
}

- (BOOL)validateNumber:(NSString*)number {
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
- (BOOL)validateWord:(NSString*)number {
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"];
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




@end
