//
//  iuiueCashDetailViewController.m
//  木鸟房东端
//
//  Created by 赵中良 on 14-7-30.
//  Copyright (c) 2014年 iuiue. All rights reserved.
//

#import "iuiueCashDetailViewController.h"
#import "MJRefresh.h"

@interface iuiueCashDetailViewController ()<UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate>
{
    UISegmentedControl *mySegement;
    UILabel *numberLabel;   
    UILabel *firstLabel;
    UILabel *secondLabel;
    UILabel *thirdLabel;
    UITableView *MyTableView;
    
    MJRefreshHeaderView *_header;
    MJRefreshFooterView *_footer;
    
    NSMutableArray *MyArray;
    NSInteger pages;
    MBProgressHUD *hud;
   
    
}

@end

@implementation iuiueCashDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //初始化
    MyArray = [NSMutableArray array];
    
    self.view.backgroundColor = [UIColor whiteColor];
    numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 64, MY_WIDTH, 20)];
    numberLabel.textAlignment = NSTextAlignmentRight;
    numberLabel.textColor = [UIColor whiteColor];
    numberLabel.text = @"共有 待查询 条";
    numberLabel.backgroundColor = [UIColor blueColor];
    
    firstLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,numberLabel.bottom , MY_WIDTH/4, 20)];
    firstLabel.textAlignment = NSTextAlignmentCenter;
    firstLabel.text = @"时间";
    firstLabel.textColor = [UIColor whiteColor];
    firstLabel.backgroundColor = [UIColor orangeColor];
    
    secondLabel = [[UILabel alloc]initWithFrame:CGRectMake(firstLabel.right, firstLabel.top, MY_WIDTH/2, 20)];
    secondLabel.textAlignment = NSTextAlignmentCenter;
    secondLabel.text = @"描述";
    secondLabel.textColor = firstLabel.textColor;
    secondLabel.backgroundColor = firstLabel.backgroundColor;
    
    thirdLabel = [[UILabel alloc]initWithFrame:CGRectMake(secondLabel.right, firstLabel.top, MY_WIDTH/4, 20)];
    thirdLabel.textAlignment = NSTextAlignmentCenter;
    thirdLabel.text = @"租币";
    thirdLabel.textColor = secondLabel.textColor;
    thirdLabel.backgroundColor = firstLabel.backgroundColor;
    
    UIImageView *firstImg = [[UIImageView alloc]initWithFrame:CGRectMake(firstLabel.width - 1, 0, 1, firstLabel.height)];
    firstImg.image = [UIImage imageNamed:@"shuxian"];
    [firstLabel addSubview:firstImg];
    
    UIImageView *secondImg = [[UIImageView alloc]initWithFrame:CGRectMake(secondLabel.width - 1, 0, 1, secondLabel.height)];
    secondImg.image = [UIImage imageNamed:@"shuxian"];
    [secondLabel addSubview:secondImg];

    [self.view addSubviews:@[numberLabel,firstLabel,secondLabel,thirdLabel]];
    
    
    //MyTableView的设置
    MyTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, firstLabel.bottom, MY_WIDTH, MY_HEIGHT - firstLabel.bottom)];
    MyTableView.tableFooterView = [[UIView alloc]init];
    MyTableView.tableFooterView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    MyTableView.delegate = self;
    MyTableView.dataSource = self;
    
    [self.view addSubview:MyTableView];
    
    //添加下拉刷新
    [self setFreshView];
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - mjfresh
- (void)setFreshView{
    // 下拉刷新
    _header = [[MJRefreshHeaderView alloc] init];
    _header.delegate = self;
    _header.scrollView = MyTableView;
    
    // 上拉加载更多
    _footer = [[MJRefreshFooterView alloc] init];
    _footer.delegate = self;
    _footer.scrollView = MyTableView;
}

#pragma mark 代理方法-进入刷新状态就会调用
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"HH : mm : ss.SSS";
    
    if (_header == refreshView) {
        
        pages = 1;
        [self getAccoundtsDetail:YES];
        
    } else {
        
        [self getAccoundtsDetail:NO];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    [_footer endRefreshing];
    [_header endRefreshing];
    return MyArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseIdentifier = @"reuseIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
//    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        NSDictionary *dic = MyArray[indexPath.row];
        UIFont *font = [UIFont systemFontOfSize:14.0];
        switch (mySegement.selectedSegmentIndex) {
            case 0:
            {
                UILabel *labelOne = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, firstLabel.width - 20, 20)];
                labelOne.numberOfLines = 0;
                labelOne.text = [NSString stringWithFormat:@"%@",dic[@"adddate"]];
                labelOne.font = font;
                [labelOne sizeToFit];
                
                UILabel *labelTwo = [[UILabel alloc]initWithFrame:CGRectMake(firstLabel.right + 5, 10, secondLabel.width - 10, 20)];
                labelTwo.numberOfLines = 0;
                labelTwo.font =font;
                labelTwo.text = [NSString stringWithFormat:@"%@",dic[@"description"]];
                [labelTwo sizeToFit];
                
                UILabel *labelThree = [[UILabel alloc]initWithFrame:CGRectMake(secondLabel.right + 5, 10, thirdLabel.width - 10, 20)];
                labelThree.numberOfLines = 2;
                labelThree.font = font;
                NSString *type = [NSString stringWithFormat:@"%@",dic[@"type"]];
                if ([type isEqualToString:@"1"]) {
                    NSString *str = [NSString stringWithFormat:@"%@",dic[@"amount"]];
                    NSString *str1 = [NSString stringWithFormat:@"￥%.2f",[str floatValue]];
                    labelThree.text = [NSString stringWithFormat:@"＋\n%@",str1];
                    [labelThree setTextColor:[UIColor greenColor]];
                }else{
                    NSString *str = [NSString stringWithFormat:@"%@",dic[@"amount"]];
                    NSString *str1 = [NSString stringWithFormat:@"￥%.2f",[str floatValue]];
                    labelThree.text = [NSString stringWithFormat:@"-\n%@",str1];
                    [labelThree setTextColor:[UIColor redColor]];
                }
                [labelThree sizeToFit];
                [cell.contentView addSubviews:@[labelOne,labelThree,labelTwo]];
                
                
                                CGSize constraint = CGSizeMake(labelTwo.width, 4000.0f);
                CGSize constraint1 = CGSizeMake(labelOne.width, 4000.0f);
                
                NSDictionary *attributes = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
                
                NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:labelOne.text attributes:attributes];
                CGRect rect = [ attributedText
                               boundingRectWithSize:constraint1
                               options:NSStringDrawingUsesLineFragmentOrigin
                               context:nil
                               ];
                CGSize size = rect.size;
                
                CGFloat height = MAX(size.height + 20.0f, 44.0f);
                
                NSAttributedString *attributedText1 = [[NSAttributedString alloc] initWithString:labelTwo.text attributes:attributes];
                CGRect rect1 = [ attributedText1
                               boundingRectWithSize:constraint
                               options:NSStringDrawingUsesLineFragmentOrigin
                               context:nil
                               ];
                CGSize size1 = rect1.size;
                
                CGFloat height1 = MAX(size1.height + 20.0f, 44.0f);
            
                                //加竖线
                if (height1>height) {
                    height = height1;
                }
                [cell setFrame:CGRectMake(0, 0, MY_WIDTH, height)];

                UIImageView *firstImg = [[UIImageView alloc]initWithFrame:CGRectMake(firstLabel.right - 1, 10, 1, height - 20)];
                firstImg.image = [UIImage imageNamed:@"shuxian"];
                [cell addSubview:firstImg];
                
                UIImageView *secondImg = [[UIImageView alloc]initWithFrame:CGRectMake(secondLabel.right - 1, 10, 1, height - 20)];
                secondImg.image = [UIImage imageNamed:@"shuxian"];
                [cell addSubview:secondImg];

            }
                break;
            case 1:
            {
                UILabel *labelOne = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, firstLabel.width - 20, 20)];
                labelOne.numberOfLines = 0;
                labelOne.textAlignment = NSTextAlignmentCenter;
                labelOne.font = font;
                labelOne.text = [NSString stringWithFormat:@"%@",dic[@"adddate"]];
                [labelOne sizeToFit];
                
                UILabel *labelTwo = [[UILabel alloc]initWithFrame:CGRectMake(firstLabel.right + 5, 10, secondLabel.width - 10, 20)];
                labelTwo.numberOfLines = 0;
                labelTwo.font = font;
                labelTwo.textAlignment = NSTextAlignmentCenter;
                NSString *str = [NSString stringWithFormat:@"%@",dic[@"accounts"]];
                NSString *str1 = [NSString stringWithFormat:@"￥%.2f",[str floatValue]];
                labelTwo.text = [NSString stringWithFormat:@"%@",str1];
                [labelTwo sizeToFit];
                
                UILabel *labelThree = [[UILabel alloc]initWithFrame:CGRectMake(secondLabel.right + 5, 10, thirdLabel.width - 10, 20)];
                labelThree.numberOfLines = 2;
                labelThree.font = font;
                NSString *type = [NSString stringWithFormat:@"%@",dic[@"status"]];
                if ([type isEqualToString:@"0"]) {
                    labelThree.text = [NSString stringWithFormat:@"未处理"];
                    [labelThree setTextColor:[UIColor greenColor]];
                }else if([type isEqualToString:@"1"]){
                    labelThree.text = [NSString stringWithFormat:@"已提现"];
                    [labelThree setTextColor:[UIColor redColor]];
                }else if([type isEqualToString:@"2"]){
                    labelThree.text = @"已退回";
                    labelThree.textColor = [UIColor grayColor];
                }
                else{
                    labelThree.text = @"处理中";
                    labelThree.textColor = [UIColor blueColor];
                }

                [labelThree sizeToFit];
                [cell.contentView addSubviews:@[labelOne,labelThree,labelTwo]];
                
                
                CGSize constraint = CGSizeMake(labelTwo.width, 4000.0f);
                CGSize constraint1 = CGSizeMake(labelOne.width, 4000.0f);
                
                NSDictionary *attributes = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
                
                NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:labelOne.text attributes:attributes];
                CGRect rect = [ attributedText
                               boundingRectWithSize:constraint1
                               options:NSStringDrawingUsesLineFragmentOrigin
                               context:nil
                               ];
                CGSize size = rect.size;
                
                CGFloat height = MAX(size.height + 20.0f, 44.0f);
                
                NSAttributedString *attributedText1 = [[NSAttributedString alloc] initWithString:labelTwo.text attributes:attributes];
                CGRect rect1 = [ attributedText1
                                boundingRectWithSize:constraint
                                options:NSStringDrawingUsesLineFragmentOrigin
                                context:nil
                                ];
                CGSize size1 = rect1.size;
                
                CGFloat height1 = MAX(size1.height + 20.0f, 44.0f);
                
                //加竖线
                if (height1>height) {
                    height = height1;
                }
                [cell setFrame:CGRectMake(0, 0, MY_WIDTH, height)];
                
                UIImageView *firstImg = [[UIImageView alloc]initWithFrame:CGRectMake(firstLabel.right - 1, 10, 1, height - 20)];
                firstImg.image = [UIImage imageNamed:@"shuxian"];
                [cell addSubview:firstImg];
                
                UIImageView *secondImg = [[UIImageView alloc]initWithFrame:CGRectMake(secondLabel.right - 1, 10, 1, height - 20)];
                secondImg.image = [UIImage imageNamed:@"shuxian"];
                [cell addSubview:secondImg];

            }
                
            default:
                break;
        }
//    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    mySegement = [[UISegmentedControl alloc]initWithItems:@[@"租币明细",@"提现纪录"]];
    [mySegement setSelectedSegmentIndex:0];
    [mySegement setFrame:CGRectMake((MY_WIDTH - 160)/2, 7, 160, 30)];
    [mySegement addTarget:self action:@selector(segementValueChange:) forControlEvents:UIControlEventValueChanged];
    [self.navigationController.navigationBar addSubview:mySegement];
    hud =
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"加载中...";
    pages = 1;
    [self getAccoundtsDetail:YES];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [mySegement removeFromSuperview];
}

-(IBAction)segementValueChange:(id)sender{
    if (mySegement.selectedSegmentIndex == 0) {
        [firstLabel setFrame: CGRectMake(0,numberLabel.bottom , MY_WIDTH/4, 20)];
        firstLabel.text = @"时间";
        [firstLabel removeAllSubviews];
        
        [secondLabel setFrame: CGRectMake(firstLabel.right, firstLabel.top, MY_WIDTH/2, 20)];
        secondLabel.text = @"描述";
        [secondLabel removeAllSubviews];
        
        [thirdLabel setFrame: CGRectMake(secondLabel.right, firstLabel.top, MY_WIDTH/4, 20)];
        thirdLabel.text = @"租币";
        
        UIImageView *firstImg = [[UIImageView alloc]initWithFrame:CGRectMake(firstLabel.width - 1, 0, 1, firstLabel.height)];
        firstImg.image = [UIImage imageNamed:@"shuxian"];
        [firstLabel addSubview:firstImg];
        
        UIImageView *secondImg = [[UIImageView alloc]initWithFrame:CGRectMake(secondLabel.width - 1, 0, 1, secondLabel.height)];
        secondImg.image = [UIImage imageNamed:@"shuxian"];
        [secondLabel addSubview:secondImg];
    }else{
        [firstLabel setFrame: CGRectMake(0,numberLabel.bottom , MY_WIDTH/2, 20)];
        firstLabel.text = @"申请时间";
        [firstLabel removeAllSubviews];
        
        [secondLabel setFrame: CGRectMake(firstLabel.right, firstLabel.top, MY_WIDTH/4, 20)];
        secondLabel.text = @"提现金额";
        [secondLabel removeAllSubviews];
        
        [thirdLabel setFrame: CGRectMake(secondLabel.right, firstLabel.top, MY_WIDTH/4, 20)];
        thirdLabel.text = @"处理状态";
        
        UIImageView *firstImg = [[UIImageView alloc]initWithFrame:CGRectMake(firstLabel.width - 1, 0, 1, firstLabel.height)];
        firstImg.image = [UIImage imageNamed:@"shuxian"];
        [firstLabel addSubview:firstImg];
        
        UIImageView *secondImg = [[UIImageView alloc]initWithFrame:CGRectMake(secondLabel.width - 1, 0, 1, secondLabel.height)];
        secondImg.image = [UIImage imageNamed:@"shuxian"];
        [secondLabel addSubview:secondImg];

    }
    hud =
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"加载中...";
    pages = 1;
    [self getAccoundtsDetail:YES];
}
 //获取租币详情
-(void)getAccoundtsDetail:(BOOL)IsUpdate {
//    if (request) {
//        [request cancel];
//    }]
    
     __weak ASIFormDataRequest *request;
    if (mySegement.selectedSegmentIndex == 0) {
         request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:URL_MY_ACCOUNTS_DETAIL]];
    }
    else{
        request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:URL_MY_GETCASH_DETAIL]];
    }
        request.requestMethod = @"POST";
        
        
        NSString *page = [NSString stringWithFormat:@"%ld",(long)pages];
        [request addPostValue:page forKey:@"page"];
        [request addPostValue:MY_UID forKey:@"uid"];
        [request addPostValue:MY_ZEND forKey:@"zend"];
        
        [request setCompletionBlock:^{
            NSLog(@"%@",request.responseString);
            NSError *error;
            NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingAllowFragments error:&error];
            if (!error) {
                switch ([resultDict[@"status"] integerValue]) {
                    case 0:{
                        [hud hide:YES];
                        //获取数据后更新发布房间数量
                        numberLabel.text = [NSString stringWithFormat:@"共有 %@ 条",resultDict[@"count"]];

                        NSArray *ListArray = resultDict[@"list"];
                        if (IsUpdate) {
                            [MyArray removeAllObjects];
                            [MyArray addObjectsFromArray:ListArray];
                            [MyTableView reloadData];
//                            CGPoint position = CGPointMake(0 , 0);
//                            [MyTableView setContentOffset:position animated:YES];
                        }
                        else{
                           
                            [MyArray addObjectsFromArray:ListArray];
                            [MyTableView reloadData];
                        }
                                                pages++;
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
            hud.labelText = @"加载失败";
            
        }];
        
        //异步加载
        [request startAsynchronous];

}


-(void)dealloc{
    NSLog(@"MJTableViewController--dealloc---");
    [_header free];
    [_footer free];
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
