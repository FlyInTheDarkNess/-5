//
//  iuiueSoundSetViewController.m
//  木鸟房东助手
//
//  Created by 赵中良 on 14/12/24.
//  Copyright (c) 2014年 iuiue. All rights reserved.
//

#import "iuiueSoundSetViewController.h"

@interface iuiueSoundSetViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation iuiueSoundSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UITableView *tableview= [[UITableView alloc]initWithFrame:CGRectMake(0, 0, MY_WIDTH, MY_HEIGHT -64) style:UITableViewStyleGrouped];
    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.tableFooterView = [[UIView alloc]init];
    
    [self.view addSubview:tableview];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *userindentify = @"useridentify";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:userindentify];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:userindentify];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UISwitch *swich = [[UISwitch alloc]initWithFrame:CGRectMake(0, 0, 60, 30)];
        swich.tag = indexPath.row;
        cell.accessoryView = swich;
        if (indexPath.row==0) {
            BOOL sound = [[NSUserDefaults standardUserDefaults] boolForKey:@"sound"];
            
            [swich setOn:sound];
        }
        else if(indexPath.row == 1){
            BOOL zhendong = [[NSUserDefaults standardUserDefaults] boolForKey:@"zhendong"];
            [swich setOn:zhendong];
        }
        [swich addTarget:self action:@selector(setOnOrOff:) forControlEvents:UIControlEventTouchUpInside];
        cell.accessoryView = swich;
    
    }
    switch (indexPath.row) {
        case 0:
        {
            cell.textLabel.text = @"声音";
        }
            break;
        case 1:{
            cell.textLabel.text = @"震动";
        }
            
        default:
            break;
           
    }
    


    return cell;
}

-(IBAction)setOnOrOff:(id)sender{
    UISwitch *btn = (UISwitch *)sender;
    if (btn.tag==0) {

        [[NSUserDefaults standardUserDefaults] setBool:btn.on forKey:@"sound"];
    }else if(btn.tag == 1){
        [[NSUserDefaults standardUserDefaults] setBool:btn.on forKey:@"zhendong"];
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
