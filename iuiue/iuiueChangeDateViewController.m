#import "iuiueChangeDateViewController.h"
#import "iuiueRoomSelectViewController.h"


@interface iuiueChangeDateViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

{
    UITableView *mytableView;
    UITextField *priceText;
    UITextField *numberOfRoomText;
    UITextField *ppTF;
    UISegmentedControl *segment;
    UILabel *unableLabel;
    BOOL IsStatusChange;//判断是否为房态管理
    BOOL IsWeek;//判断是否为周价格
    NSMutableArray *WeekArr;
    MBProgressHUD *hud;
}

@end

@implementation iuiueChangeDateViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UIBarButtonItem *item = [[UIBarButtonItem alloc]init];
        self.navigationItem.backBarButtonItem = item;
        item.title = @"返回";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    IsWeek = NO;
    WeekArr = [NSMutableArray arrayWithCapacity:7];
    //判断是从哪个viewcontroller跳转过来的
    if ([[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 3]isKindOfClass:[iuiueRoomSelectViewController class]]) {
        IsStatusChange = YES;
        self.navigationItem.title = @"房态修改";
    }
    else{
        IsStatusChange = NO;
        self.navigationItem.title = @"价格修改";
    }
    NSLog(@"房间名称%@",self.roomName);
    mytableView = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
    mytableView.delegate = self;
    mytableView.dataSource = self;
    mytableView.bounces = NO;
    [self.view addSubview:mytableView];
    priceText.keyboardType = UIKeyboardTypeNumbersAndPunctuation;//输入键盘为九宫格数字键
    numberOfRoomText.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 1;
        case 1:
            return 2;
            break;
        case 2:
            //判断是否为房态管理
            if (IsStatusChange) {
                return 3;
            }else if(IsWeek){
                return 4;
            }
            else{
                return 3;
            }
            
            break;
        case 3:
            return 1;
            break;
            
        default:
            return 0;
            break;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *reused = [NSString stringWithFormat:@"%D-%D",indexPath.section,indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reused];
    NSLog(@"%d:%d",indexPath.section,indexPath.row);
    if (!cell) {
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"dateChangeCell" owner:self options:nil];
        if (indexPath.section == 0) {
            //            cell = [nib objectAtIndex:0];
            //            //房间名称
            //            UILabel *roomLabel = [[UILabel alloc]init];
            //            roomLabel = (UILabel *)[cell viewWithTag:1];
            //            roomLabel.text = self.roomName;
            
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:reused];
            cell.detailTextLabel.text = self.roomName;
            cell.detailTextLabel.numberOfLines = 0;
            cell.detailTextLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
            cell.textLabel.text = @"选择房间:";
            
        }
        else if(indexPath.section == 3){
            cell = [nib objectAtIndex:5];
            //确认和放弃两个按钮
            UIButton *btn1;
            btn1 = (UIButton *)[cell viewWithTag:1];
            UIButton *btn2;
            btn2 = (UIButton *)[cell viewWithTag:2];
            btn1.layer.cornerRadius = 10;//修改button的圆角
            btn2.layer.cornerRadius = 10;//
            [btn1 addTarget:self action:@selector(pressButton:) forControlEvents:UIControlEventTouchUpInside];
            [btn2 addTarget:self action:@selector(pressButton:) forControlEvents:UIControlEventTouchUpInside];
            [cell setFrame:CGRectMake(0, 0, MY_WIDTH, 60)];
        }
        else if(indexPath.section == 2){
            if (!IsStatusChange) {
                if (IsWeek) {
                    {
                        switch (indexPath.row) {
                                //起止日期
                            case 0:
                            {
                                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:reused];
                                cell.textLabel.numberOfLines = 0;
                                cell.detailTextLabel.numberOfLines = 0;
                                cell.textLabel.text = @"起始日期：\n终止日期：";
                                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@\n%@",self.startDate,self.endDate];
                                cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
                                [cell setFrame:CGRectMake(0, 0, MY_WIDTH, 44)];
                            }
                                break;
                            case 1:
                            {
                                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:reused];
                                cell.textLabel.numberOfLines = 0;
                                cell.detailTextLabel.numberOfLines = 0;
                                cell.textLabel.text = @"星期价格修改";
                                cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
                                [cell setFrame:CGRectMake(0, 0, MY_WIDTH, 44)];
                                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                            }
                                break;
                            case 2:{
                                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reused];
                                NSArray *Week = @[@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六"];
                                for (int num = 0; num<7; num++) {
                                    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(20 + num *40, 5, 35, 34)];
                                    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(button.left, button.bottom, button.width, 20)];
                                    label.text = Week[num];
                                    label.textAlignment = NSTextAlignmentCenter;
                                    label.font = [UIFont systemFontOfSize:10];
                                    [cell.contentView addSubview:label];
                                    
                                    [button setImage:[UIImage imageNamed:@"btn_hiresend_on"] forState:UIControlStateNormal];
                                    [button setTag:num];
                                    [button addTarget:self action:@selector(WeekDaySelect:) forControlEvents:UIControlEventTouchUpInside];
                                    button.layer.cornerRadius = 10;
                                    [cell.contentView addSubview:button];
                                    [cell setFrame:CGRectMake(0, 0, MY_WIDTH, label.bottom)];
                                    
                                }
                            }
                                break;
                            case 3:{
                                cell = [nib objectAtIndex:2];
                                ppTF = (UITextField *)[cell viewWithTag:1];
                                ppTF.delegate = self;
                                [cell setFrame:CGRectMake(0, 0, MY_WIDTH, 44)];
                            }
                                break;
                                
                            default:
                                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reused];
                                break;
                        }
                    }
                    
                }
                else{
                    switch (indexPath.row) {
                            //起止日期
                        case 0:
                        {
                            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:reused];
                            cell.textLabel.numberOfLines = 0;
                            cell.detailTextLabel.numberOfLines = 0;
                            cell.textLabel.text = @"起始日期：\n终止日期：";
                            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@\n%@",self.startDate,self.endDate];
                            cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
                                [cell setFrame:CGRectMake(0, 0, MY_WIDTH, 44)];
                        }
                            break;
                        case 1:
                        {
                            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:reused];
                            cell.textLabel.numberOfLines = 0;
                            cell.detailTextLabel.numberOfLines = 0;
                            cell.textLabel.text = @"星期价格修改";
                            cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
                                [cell setFrame:CGRectMake(0, 0, MY_WIDTH, 44)];
                             cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                        }
                            break;
                        case 2:{
                            cell = [nib objectAtIndex:2];
                            ppTF = (UITextField *)[cell viewWithTag:1];
                            ppTF.delegate = self;
                            ppTF.returnKeyType = UIReturnKeyDone;
                                [cell setFrame:CGRectMake(0, 0, MY_WIDTH, 44)];
                        }
                            break;
                            
                        default:
                            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reused];
                            break;
                    }

                }
            }else{
                switch (indexPath.row) {
                        //起止日期
                    case 0:
                    {
                        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:reused];
                        cell.textLabel.numberOfLines = 0;
                        cell.detailTextLabel.numberOfLines = 0;
                        cell.textLabel.text = @"起始日期：\n终止日期：";
                        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@\n%@",self.startDate,self.endDate];
                        cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
                            [cell setFrame:CGRectMake(0, 0, MY_WIDTH, 44)];
                    }
                        break;

                    case 1:{
                        cell = [nib objectAtIndex:3];
                        numberOfRoomText =(UITextField *)[cell viewWithTag:1];
                        numberOfRoomText.returnKeyType = UIReturnKeyDone;
                        numberOfRoomText.delegate= self;
                        unableLabel = (UILabel *)[cell viewWithTag:2];
                        unableLabel.hidden = YES;
                            [cell setFrame:CGRectMake(0, 0, MY_WIDTH, 44)];
                    }
                        break;
                    case 2:{
                        cell = [nib objectAtIndex:4];
                        segment = (UISegmentedControl *)[cell viewWithTag:1];
                        [segment addTarget:self action:@selector(segmentValueChange:) forControlEvents:UIControlEventValueChanged];
                        //默认不可租
                        segment.selectedSegmentIndex = 1;
                        numberOfRoomText.hidden = YES;
                        unableLabel.hidden = NO;
                        numberOfRoomText.text = @"0";
                        [cell setFrame:CGRectMake(0, 0, MY_WIDTH, 44)];
                    }
                        
                        break;
                    default:
                        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reused];
                        break;
                }
                
            }
            
        }
        else if(indexPath.section == 1){
            switch (indexPath.row) {
                case 0:
                    //设置当前cell
                    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:reused];
                    cell.detailTextLabel.text = self.roomId;
                    cell.detailTextLabel.numberOfLines = 0;
                    //                    cell.detailTextLabel
                    cell.textLabel.text = @"房间编号:";
                    cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
                        [cell setFrame:CGRectMake(0, 0, MY_WIDTH, 44)];
                    
                    break;
                case 1:
                    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:reused];
                    cell.detailTextLabel.text = self.location;
                    cell.detailTextLabel.numberOfLines = 0;
                    cell.textLabel.text = @"地理位置:";
                    cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
                        [cell setFrame:CGRectMake(0, 0, MY_WIDTH, 44)];
                    
                    
                    break;
                    
                default:
                    break;
            }
        }
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2&&indexPath.row ==1 &&IsStatusChange == NO) {
        IsWeek = !IsWeek;
        [mytableView reloadData];
        if (!mytableView.frame.origin.y==0) {
            [mytableView setFrame:CGRectMake(mytableView.frame.origin.x, 0, mytableView.frame.size.width, mytableView.frame.size.height)];
        }
    }
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

-(IBAction)pressButton:(id)sender{
    UIButton * btn = (UIButton *)sender;
    if (btn.tag == 1) {
        iuiueAllService *service = [[iuiueAllService alloc]init];
        
        //判断当前网络
        if (![service isConnectionAvailable]) {
            [[UIApplication sharedApplication].keyWindow makeToast:@"网络连接失败，请检查"];
            return;
        }
        else{
            if (IsStatusChange) {
                [self ChangeStatus];
            }
            else{
                [self changePrice];
            }
            
        }
    }
    else{
        [self.navigationController popViewControllerAnimated:YES];
        [self.delegate Transmit:@"放弃修改"];
    }
}

//改变排期价格
-(void)changePrice{
   
    __weak ASIFormDataRequest *request;
    
    if (IsWeek) {
        request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:URL_WEEK_PRICE_CHANGE]];
        //合并_MyArray 生成传递字符串
        NSString *ArrayStr = [WeekArr componentsJoinedByString:@","];
        [request addPostValue:ArrayStr forKey:@"weeks"];
    }
    else{
    request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:URL_ROOM_PRICE_CHANGE]];
    }
    request.requestMethod = @"POST";
    
    [request addPostValue:self.roomId forKey:@"roomid"];
    [request addPostValue:MY_UID forKey:@"uid"];
    [request addPostValue:MY_ZEND forKey:@"zend"];
    [request addPostValue:self.startDate forKey:@"start_date"];
    [request addPostValue:self.endDate forKey:@"end_date"];
    [request addPostValue:ppTF.text forKey:@"priceday"];
    NSLog(@"ghjgj:%@",ppTF.text);
    [request setCompletionBlock:^{
        NSLog(@"%@",request.responseString);
        NSError *error;
        NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingAllowFragments error:&error];
        [hud hide:YES];
        if (!error) {
            switch ([resultDict[@"status"] integerValue]) {
                case 0:{
                    [self.navigationController popViewControllerAnimated:YES];
                    [_delegate Transmit:@"修改房间价格成功"];
                }
                    break;
                    
                default:
                    [[UIApplication sharedApplication].keyWindow makeToast:resultDict[@"message"] duration:1 position:@"center"];
                    break;
            }
        }else{
            NSLog(@"%@",[error localizedDescription]);
        }
    }];
    
    //获取数据失败处理
    [request setFailedBlock:^{
        NSLog(@"%@",[request.error localizedDescription]);
        [[UIApplication sharedApplication].keyWindow makeToast:@"网络连接失败，请检查网络设置"];
    }];
    
    hud =
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //异步加载
    [request startAsynchronous];
    
}

//改变房态
-(void)ChangeStatus{
    //获取钥匙串中得uid与zend
    NSMutableDictionary *usernamepasswordKVPairs = (NSMutableDictionary *)[iuiueCHKeychain load:KEYCHAIN_USERNAMEPASSWORD];
    NSString *uid =[usernamepasswordKVPairs objectForKey:KEYCHAIN_UID];
    NSString *zend = [usernamepasswordKVPairs objectForKey:KEYCHAIN_ZEND];
    __weak ASIFormDataRequest *request;
    
    request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:URL_ROOM_STATUS_CHANGE]];
    
    request.requestMethod = @"POST";
    
    
    [request addPostValue:self.roomId forKey:@"roomid"];
    [request addPostValue:uid forKey:@"uid"];
    [request addPostValue:zend forKey:@"zend"];
    [request addPostValue:self.startDate forKey:@"start_date"];
    [request addPostValue:self.endDate forKey:@"end_date"];
    [request addPostValue:numberOfRoomText.text forKey:@"sameroom"];
    
    
    
    [request setCompletionBlock:^{
        NSLog(@"%@",request.responseString);
        NSError *error;
        NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingAllowFragments error:&error];
        [hud hide:YES];
        if (!error) {
            switch ([resultDict[@"status"] integerValue]) {
                case 0:{
                    [self.navigationController popViewControllerAnimated:YES];
                    [_delegate Transmit:@"修改房间状态成功"];
                    
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
        [hud hide:YES];
        NSLog(@"%@",[request.error localizedDescription]);
        [[UIApplication sharedApplication].keyWindow makeToast:@"网络连接失败，请检查网络设置"];
        
    }];
    hud =
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //异步加载
    [request startAsynchronous];
    
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if ( mytableView.frame.origin.y == [UIScreen mainScreen].bounds.origin.y) {
        if (IsWeek) {
            [mytableView setFrame:CGRectMake(mytableView.frame.origin.x, mytableView.frame.origin.y - 130, mytableView.frame.size.width, mytableView.frame.size.height)];
        }else{
            [mytableView setFrame:CGRectMake(mytableView.frame.origin.x, mytableView.frame.origin.y - 100, mytableView.frame.size.width, mytableView.frame.size.height)];
        }
        
    }
    if ([textField isEqual:numberOfRoomText]) {
        segment.selectedSegmentIndex = 0;
    }
}


-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (IsStatusChange) {
        numberOfRoomText.text = textField.text;
    }else{
        ppTF.text = textField.text;
    }
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    NSLog(@" ");
    [textField resignFirstResponder];
//    [numberOfRoomText resignFirstResponder];
    [self.view endEditing:YES];
    
    [mytableView setFrame:CGRectMake(0, 0, mytableView.frame.size.width, mytableView.frame.size.height)];
    return YES;
}

-(IBAction)segmentValueChange:(id)sender{
    
    UISegmentedControl *Msegment = (UISegmentedControl *)sender;
    
    if (Msegment.selectedSegmentIndex == 0) {
        numberOfRoomText.text = @"";
        numberOfRoomText.hidden = NO;
        unableLabel.hidden = YES;
    }
    else{
        numberOfRoomText.hidden = YES;
        unableLabel.hidden = NO;
        numberOfRoomText.text = @"0";
    }
}

//限定只能输入数字或字母
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//    if (segment.selectedSegmentIndex == 1&&IsStatusChange == YES){
//        return NO;
//    }
    NSLog(@"text:%@",ppTF.text);
    return [self validateNumber:string];
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

//选择周价格修改

-(IBAction)WeekDaySelect:(id)sender{
    UIButton *btn = (UIButton *)sender;
    for (NSString* str in WeekArr) {
        NSString *str1 = [NSString stringWithFormat:@"%d",btn.tag];
        if ([str isEqualToString:str1]) {
            [WeekArr removeObject:str];
            [btn setImage:[UIImage imageNamed:@"btn_hiresend_on"] forState:UIControlStateNormal];
            return;
        }
    }
    NSString *str = [NSString stringWithFormat:@"%d",btn.tag];
    [WeekArr addObject:str];
    [btn setImage:[UIImage imageNamed:@"btn_hiresend_in"] forState:UIControlStateNormal];

}


//设置section header的高度
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5;
}

//设置section header的高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5;
}



@end