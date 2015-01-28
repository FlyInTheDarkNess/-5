//
//  iuiueAppReRaiseViewController.m
//  木鸟房东端
//
//  Created by 赵中良 on 14-7-23.
//  Copyright (c) 2014年 iuiue. All rights reserved.
//

#import "iuiueAppReRaiseViewController.h"

@interface iuiueAppReRaiseViewController ()<UITextViewDelegate>
{
    
    UIScrollView *MyScrollView;
    
    UITextView *reraiseTextView;//回评textView
    
    UIView *view;//第一个块的view
    
    UIButton *btn;//清空btn
    
}

@end

@implementation iuiueAppReRaiseViewController

@synthesize MyDic;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationItem.title = @"评价详情";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //设置不透明
    self.view.backgroundColor = [UIColor whiteColor];
    //scrollView 相关设置
    MyScrollView = [[UIScrollView alloc]initWithFrame:MY_SCREEN];
    MyScrollView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:MyScrollView];
    
    view = [[UIView alloc]initWithFrame:CGRectMake(5, 5, MY_WIDTH - 10, 200)];
    view.backgroundColor = [UIColor whiteColor];
    view.layer.cornerRadius = 10.0f;
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, view.width - 10, 30)];
    titleLabel.text = [NSString stringWithFormat:@"%@",MyDic[@"title"]];
    titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    [view addSubview:titleLabel];
    
    UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(titleLabel.left, titleLabel.bottom + 2, titleLabel.width - 15, 1)];
    imgV.image = [UIImage imageNamed:@"line"];
    [view addSubview:imgV];
    
    UILabel *detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(50,titleLabel.bottom + 20, 30, 110)];
    detailLabel.text = @"房客评论";
    detailLabel.numberOfLines = 4;
    detailLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:22];
    detailLabel.textColor = [UIColor lightGrayColor];
    [view addSubview:detailLabel];
    
    NSArray *array = [NSArray arrayWithObjects:@"设施装潢:",@"图片真实:",@"卫生情况:",@"服务态度:", nil];
    NSArray *arr = [NSArray arrayWithObjects:@"sheshi",@"tupian",@"weisheng",@"fuwu", nil];
    int num;
    for (num = 0; num < 4; num++) {
      UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(detailLabel.right + 10 , titleLabel.bottom + 20 + 30 * num, 70, 25)];
        label.text = array[num];
        label.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
        [view addSubview:label];
        NSString *str = arr[num];
        NSString *RaiseStatus = [NSString stringWithFormat:@"%@",MyDic[str]];
        NSInteger status = [RaiseStatus integerValue];
        int number;
        for (number = 0; number < status; number++) {
            UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(label.right + number * 25, label.top , 23, 23)];
            imageV.image = [UIImage imageNamed:@"starYes"];
            [view addSubview:imageV];
        }
        for (; number < 5; number ++) {
            UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(label.left + number * 25, label.top , 23, 23)];
            imageV.image = [UIImage imageNamed:@"starNo"];
            [view addSubview:imageV];
        }
    }
    
    
    [MyScrollView addSubview:view];
    
    
    UILabel *raiseLabel = [[UILabel alloc]initWithFrame:CGRectMake(view.left, view.bottom + 10, view.width, 20)];
    raiseLabel.text = [NSString stringWithFormat:@"%@ 评价：",MyDic[@"username"]];
    [MyScrollView addSubview:raiseLabel];
    
    UITextView *raiseTextView = [[UITextView alloc]initWithFrame:CGRectMake(view.left, raiseLabel.bottom + 10, view.width, 100)];
    raiseTextView.text = MyDic[@"pingyu"];
    raiseTextView.layer.cornerRadius = 10.0f;
    raiseTextView.editable = NO;
    raiseTextView.exclusiveTouch = NO;
    [MyScrollView addSubview:raiseTextView];
    
    UILabel *reraiseLabel = [[UILabel alloc]initWithFrame:CGRectMake(view.left, raiseTextView.bottom + 10, view.width, 20)];
    reraiseLabel.text = [NSString stringWithFormat:@"我的回评："];
    [MyScrollView addSubview:reraiseLabel];
    
    reraiseTextView = [[UITextView alloc]initWithFrame:CGRectMake(view.left, reraiseLabel.bottom + 10, view.width, 100)];
    reraiseTextView.layer.cornerRadius = 10.0f;
    NSString *str = [NSString stringWithFormat:@"%@",MyDic[@"repingyu"]];
    if ([str isEqualToString:@""] ) {
        reraiseTextView.delegate = self;
        [[UIApplication sharedApplication].keyWindow makeToast:@"点击此处添加回评"];
    }
    else{
        reraiseTextView.editable = NO;
        reraiseTextView.text = MyDic[@"repingyu"];
    }
   
    [MyScrollView addSubview:reraiseTextView];
    
    
    //清空button设置
    btn = [[UIButton alloc]initWithFrame:CGRectMake(MY_WIDTH - 50 , reraiseTextView.top - 40, 40, 40)];
    [btn setTitle:@"清空" forState:UIControlStateNormal];
    [btn addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    
    [MyScrollView addSubview:btn];
    btn.hidden = YES;
    
    [MyScrollView setContentSize:CGSizeMake(MY_WIDTH, MY_HEIGHT - 64)];
    
    
    
    
    // Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//换行手机键盘
/*
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text; {
    
    if ([@"\n" isEqualToString:text] == YES) {
//        你的响应方法
        [self hideKeyBoad];
        return NO;
    }
    return YES;
}
 */

-(void)textViewDidBeginEditing:(UITextView *)textView{
    
    btn.hidden = NO;
    [MyScrollView setFrame:CGRectMake(0, 0, MY_WIDTH, MY_HEIGHT - 216)];
    [MyScrollView setContentSize:CGSizeMake(MY_WIDTH, MY_HEIGHT - 20)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"发表" style:UIBarButtonItemStylePlain target:self action:@selector(PostReRaise)];
    //滚动
    CGPoint position = CGPointMake(0 , view.bottom - 64);
    [MyScrollView setContentOffset:position animated:YES];
}

-(void)textViewDidEndEditing:(UITextView *)textView{
//    [textView resignFirstResponder];
//    [reraiseTextView setFrame:MY_SCREEN];
}


//发送数据，提交回评
-(void)PostReRaise{
    __weak ASIFormDataRequest *request;
    request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:URL_RE_APPRAISE]];
    
    request.requestMethod = @"POST";
    
    
    NSString *idStr = [NSString stringWithFormat:@"%@",MyDic[@"id"]];
    [request addPostValue: idStr forKey:@"id"];
    [request addPostValue:MY_UID forKey:@"uid"];
    [request addPostValue:MY_ZEND forKey:@"zend"];
    [request addPostValue:reraiseTextView.text forKey:@"repingyu"];
    
    [request setCompletionBlock:^{
        NSLog(@"%@",request.responseString);
        NSError *error;
        NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingAllowFragments error:&error];
        if (!error) {
            switch ([resultDict[@"status"] integerValue]) {
                case 0:{
                    [self.navigationController popViewControllerAnimated:YES];
                    [_delegate Transmit:@"回评成功！"];
                }
                    break;
                    
                default:
                    [[UIApplication sharedApplication].keyWindow makeToast:resultDict[@"message"] duration:1 position:@"center"];
                    break;
            }
        }
        else
        {
            NSLog(@"%@",[error localizedDescription]);
        }
    }];
    
    //获取数据失败处理
    [request setFailedBlock:^{
        NSLog(@"%@",[request.error localizedDescription]);
        [[UIApplication sharedApplication].keyWindow makeToast:@"网络连接失败，请检查网络设置"];
        
    }];
    
    
    //异步加载
    [request startSynchronous];
    
}




//收起键盘
-(void)hideKeyBoad{
    [reraiseTextView resignFirstResponder];
}

-(void)qingkong{
    reraiseTextView.text = @"";
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
