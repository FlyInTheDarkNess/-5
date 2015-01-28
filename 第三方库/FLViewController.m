//
//  FLViewController.m
//  15-QQ聊天布局
//
//  Created by Liu Feng on 13-12-3.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import "FLViewController.h"
#import "MessageFrame.h"
#import "Message.h"
#import "MessageCell.h"
#import "MJRefresh.h"

@interface FLViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
{
    NSMutableArray  *_allMessagesFrame;
    
    MJRefreshHeaderView *_header;
    MJRefreshFooterView *_footer;
    MBProgressHUD *hud;
    NSMutableArray *MyArray;
    UIWebView *phoneCallWebView;
    NSString *PhoneNumber;

}
@end

@implementation FLViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationItem.title = @"求租应答";
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"phone"] style:UIBarButtonItemStyleBordered target:self action:@selector(phoneCall)];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView setFrame:CGRectMake(0, 64, MY_WIDTH, MY_HEIGHT - 64 - 44)];
    if (MY_HEIGHT <= 480) {
        [self.tableView setFrame:CGRectMake(0, 64, MY_WIDTH, MY_HEIGHT - 44)];
    }
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.allowsSelection = NO;
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chat_bg_default.jpg"]];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    //使用本地plist文件
//    NSArray *array = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"messages" ofType:@"plist"]];
    
    //初始化聊天arr
    _allMessagesFrame = [NSMutableArray array];
    MyArray = [NSMutableArray array];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    //设置textField输入起始位置
    _messageField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
    _messageField.leftViewMode = UITextFieldViewModeAlways;
    
    _messageField.delegate = self;
    [self.bottomView setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 44, MY_WIDTH, 44)];
}
#pragma mark - 键盘处理
#pragma mark 键盘即将显示
- (void)keyBoardWillShow:(NSNotification *)note{
    CGRect rect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat ty = - rect.size.height;
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
            self.view.transform = CGAffineTransformMakeTranslation(0, ty);
    }];

    
    
    
}
#pragma mark 键盘即将退出
- (void)keyBoardWillHide:(NSNotification *)note{
    
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
        self.view.transform = CGAffineTransformIdentity;
    }];
}
#pragma mark - 文本框代理方法
#pragma mark 点击textField键盘的回车按钮
- (BOOL)textFieldShouldReturn:(UITextField *)textField{

    // 1、增加数据源
    NSString *content = textField.text;
    
    [self sendMessage:content];
    /*
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    NSDate *date = [NSDate date];
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss"; // @"yyyy-MM-dd HH:mm:ss"
    NSString *time = [fmt stringFromDate:date];
    [self addMessageWithContent:content time:time];
    // 2、刷新表格
    [self.tableView reloadData];
    // 3、滚动至当前行
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_allMessagesFrame.count - 1 inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    // 4、清空文本框内容
    _messageField.text = nil;
     */
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
   
}

#pragma mark 给数据源增加内容
- (void)addMessageWithContent:(NSString *)content time:(NSString *)time{
    
    MessageFrame *mf = [[MessageFrame alloc] init];
    Message *msg = [[Message alloc] init];
    msg.content = content;
    msg.time = time;
    msg.icon = @"icon02.png";
    msg.type = MessageTypeMe;
    mf.message = msg;
    [_allMessagesFrame addObject:mf];
}

#pragma mark - tableView数据源方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
        return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _allMessagesFrame.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"%d",indexPath.row];
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    UILabel *label;
    if (cell == nil) {
        cell = [[MessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        label = [[UILabel alloc]initWithFrame:CGRectMake(10, 80, 45, 30)];
//        label.adjustsFontSizeToFitWidth = YES;
        label.font = [UIFont systemFontOfSize:10];
        label.numberOfLines = 0;
        NSDictionary *dic = MyArray[indexPath.row];
        label.text = [NSString stringWithFormat:@"%@",dic[@"username"]];
        [cell.contentView addSubview:label];
    }
    
    // 设置数据
    if (indexPath.row > 0) {
        [label setFrame:CGRectMake(MY_WIDTH - 55, 80, 45, 30)];
        label.textAlignment = NSTextAlignmentCenter;
    }
    
    
    cell.messageFrame = _allMessagesFrame[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [_allMessagesFrame[indexPath.row] cellHeight];
}

#pragma mark - 代理方法

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
} 

#pragma mark - 语音按钮点击
- (IBAction)voiceBtnClick:(UIButton *)sender {
    if (_messageField.hidden) { //输入框隐藏，按住说话按钮显示
        _messageField.hidden = NO;
        _speakBtn.hidden = YES;
        [sender setBackgroundImage:[UIImage imageNamed:@"chat_bottom_voice_nor.png"] forState:UIControlStateNormal];
        [sender setBackgroundImage:[UIImage imageNamed:@"chat_bottom_voice_press.png"] forState:UIControlStateHighlighted];
        [_messageField becomeFirstResponder];
    }else{ //输入框处于显示状态，按住说话按钮处于隐藏状态
        _messageField.hidden = YES;
        _speakBtn.hidden = NO;
        [sender setBackgroundImage:[UIImage imageNamed:@"chat_bottom_keyboard_nor.png"] forState:UIControlStateNormal];
        [sender setBackgroundImage:[UIImage  imageNamed:@"chat_bottom_keyboard_press.png"] forState:UIControlStateHighlighted];
        [_messageField resignFirstResponder];
    }
}

//获取数据
-(void)getHistoryArray:(BOOL) UpDown{
    
    __weak ASIFormDataRequest *request;
    
    request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:URL_REQIUZU_LIST]];
    
    request.requestMethod = @"POST";
    [request addPostValue:_UserId forKey:@"id"];
    [request addPostValue:MY_UID forKey:@"uid"];
    [request addPostValue:MY_ZEND forKey:@"zend"];
    [request addPostValue:@"1" forKey:@"page"];
    
    
    [request setCompletionBlock:^{
        NSLog(@"%@",request.responseString);
        NSError *error;
        NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingAllowFragments error:&error];
        if (!error) {
            switch ([resultDict[@"status"] integerValue]) {
                case 0:{
                    [hud hide:YES];
                    if (self.IsPass) {
                        UILabel *label = [[UILabel alloc]initWithFrame:self.bottomView.frame];
                        label.textColor = [UIColor whiteColor];
                        label.backgroundColor = [UIColor grayColor];
                        label.text = @"该求租已过期";
                        self.navigationItem.rightBarButtonItem = nil;
                        label.font = [UIFont systemFontOfSize:20];
                        label.textAlignment = NSTextAlignmentCenter;
                        [self.view addSubview:label];
                        self.bottomView.hidden =YES;
                    }
                    else
                    {
                        NSString *string = [NSString stringWithFormat:@"%@",resultDict[@"reqiuzu"]];
                        if ([string isEqualToString:@"0"]) {
                            self.bottomView.hidden = NO;
                            [self.tableView setFrame:CGRectMake(0, 64, MY_WIDTH, MY_HEIGHT - 64 - 44)];
                        }else{
                            self.bottomView.hidden = YES;
                            [self.tableView setFrame:CGRectMake(0, 64, MY_WIDTH, MY_HEIGHT - 64)];
                            PhoneNumber = resultDict[@"mobile"];
                        }

                    }
                    NSArray *ListArray = resultDict[@"list"];
                    
                    if (UpDown) {
                        [MyArray addObjectsFromArray:ListArray];
                        [_tableView reloadData];
                    }
                    else{
                        [MyArray removeAllObjects];
                        [MyArray addObjectsFromArray:ListArray];
                        
                        NSString *previousTime = nil;
                        [_allMessagesFrame removeAllObjects];
                        for (NSDictionary *dict in MyArray) {
                            
                            MessageFrame *messageFrame = [[MessageFrame alloc] init];
                            Message *message = [[Message alloc] init];
                            message.dict = dict;
                            if ([dict isEqual:MyArray[0]]) {
                                message.type = 1;
                            }
                            else{
                                message.type = 0;
                            }
                            
                            messageFrame.showTime = ![previousTime isEqualToString:message.time];
                            
                            messageFrame.message = message;
                            
                            previousTime = message.time;
                            
                            [_allMessagesFrame addObject:messageFrame];
                        }

                        [_tableView reloadData];
                    }
                    
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

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    hud =
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"加载中...";

    [self getHistoryArray:NO];
}

//发送数据
-(void)sendMessage:(NSString *) TextString{
    
    __weak ASIFormDataRequest *request;
    
    request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:URL_REQIUZU]];
    
    request.requestMethod = @"POST";
    [request addPostValue:_UserId forKey:@"id"];
    [request addPostValue:MY_UID forKey:@"uid"];
    [request addPostValue:MY_ZEND forKey:@"zend"];
    [request addPostValue:TextString forKey:@"contents"];
    
    
    [request setCompletionBlock:^{
        NSLog(@"%@",request.responseString);
        NSError *error;
        NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingAllowFragments error:&error];
        if (!error) {
            switch ([resultDict[@"status"] integerValue]) {
                case 0:{
                    //再次获取求租回复列表
                    [self getHistoryArray:NO];
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
    
    hud =
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"发送中...";

    //异步加载
    [request startAsynchronous];
    
}

-(void)phoneCall{
    if (PhoneNumber.length > 2) {
        //播电话
        NSString *phoneNum = [NSString stringWithFormat:@"%@",PhoneNumber];// 电话号码
        NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",phoneNum]];
        if ( !phoneCallWebView ) {
            phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];// 这个webView只是一个后台的View 不需要add到页面上来  效果跟方法二一样 但是这个方法是合法的
        }
        [phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];

    }else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"回复后可拨打房客电话，请先回复求租信息" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    
}


@end
