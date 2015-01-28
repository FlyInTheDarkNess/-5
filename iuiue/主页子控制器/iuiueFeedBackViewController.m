//
//  iuiueFeedBackViewController.m
//  iuiue
//
//  Created by 赵中良 on 14-5-27.
//  Copyright (c) 2014年 iuiue. All rights reserved.
//

#import "iuiueFeedBackViewController.h"

@interface iuiueFeedBackViewController ()<UITextViewDelegate,UITextFieldDelegate>

@end

@implementation iuiueFeedBackViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationItem.title = @"用户反馈";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _detailTextView.delegate = self;
    _contactWayTextfield.delegate = self;
    _contactWayTextfield.keyboardType = UIKeyboardTypeDecimalPad;//输入键盘为九宫格数字键
    
    //给textfield 键盘上添加按钮
    UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, MY_WIDTH, 30)];
    [topView setBarStyle:UIBarStyleBlack];
    
    UIBarButtonItem * helloButton = [[UIBarButtonItem alloc]initWithTitle:@"Hello" style:UIBarButtonItemStyleBordered target:self action:nil];
    
    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyBoard)];
    
    
    NSArray * buttonsArray = [NSArray arrayWithObjects:helloButton,btnSpace,doneButton,nil];
    
    [topView setItems:buttonsArray];
    [_detailTextView setInputAccessoryView:topView];
    [_contactWayTextfield setInputAccessoryView:topView];
    
    
  
    [_present addTarget:self action:@selector(feedBack:) forControlEvents:UIControlEventTouchUpInside];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length > 0) {
        _grayLabel.hidden = YES;
    }
    else{
        _grayLabel.hidden = NO;
    }
    _yellowLabel.text = [NSString stringWithFormat:@"还可以输入%d字",201 -textView.text.length];
    if (textView.text.length >= 200) {
        NSString *text = textView.text;
        textView.text = [text substringToIndex:200];
        [[UIApplication sharedApplication].keyWindow makeToast:@"字数已超过200字" duration:1 position:@"center"];
        NSLog(@"%lu",(unsigned long)textView.text.length);
    }
}

//点击屏幕空白处收起键盘

//-(void)touchesBegan:(NSSet *)touches withEveskdjfnt:(UIEvent *)event{
//    [_detailTextView resignFirstResponder];
//    [_contactWayTextfield resignFirstResponder];
//    if (self.view.frame.origin.y == -130||self.view.frame.origin.y == -30) {
//        CGRect frame = [UIScreen mainScreen].bounds;
//        [self.view setFrame:frame];
//    }
//}
//限定只能输入数字或字母
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return [self validateNumber:string];
}

- (BOOL)validateNumber:(NSString*)number {
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789abcdefghijklmnopqrstuvwxyz.@"];
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

//避免被键盘挡住
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    CGRect frame = [UIScreen mainScreen].bounds;
    if (textField.frame.origin.y > frame.size.height - 216 - textField.frame.size.height-40) {
        [self.view setFrame:CGRectMake(frame.origin.x, frame.origin.y - 130, frame.size.width, frame.size.height)];
    }
}
//避免被键盘挡住
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (self.view.frame.origin.y == -130) {
        CGRect frame = [UIScreen mainScreen].bounds;
        [self.view setFrame:frame];
    }
}

-(void)textViewDidBeginEditing:(UITextView *)textView{
    CGRect frame = [UIScreen mainScreen].bounds;
    if (textView.frame.origin.y > frame.size.height - 216 - textView.frame.size.height) {
        [self.view setFrame:CGRectMake(frame.origin.x, frame.origin.y - 30, frame.size.width, frame.size.height)];
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    if (self.view.frame.origin.y == -30) {
        CGRect frame = [UIScreen mainScreen].bounds;
        [self.view setFrame:frame];
    }
}

-(IBAction)dismissKeyBoard
{
    [_contactWayTextfield resignFirstResponder];
    [_detailTextView resignFirstResponder];
}

-(IBAction)feedBack:(id)sender{
    iuiueAllService *service = [[iuiueAllService alloc]init];
    [service feedBackDictionaryInit:[NSDictionary dictionaryWithObjectsAndKeys:_contactWayTextfield.text,@"contact",_detailTextView.text,@"content", nil]];
    if (service.error) {
        [[UIApplication sharedApplication].keyWindow makeToast:@"网络连接失败"];
    }
    else{
        NSDictionary *dic = service.diction;
        [[UIApplication sharedApplication].keyWindow makeToast:[dic valueForKey:@"message"]];
    }
}




@end
