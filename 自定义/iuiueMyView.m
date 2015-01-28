//
//  iuiueMyView.m
//  木鸟房东端
//
//  Created by 赵中良 on 14-7-23.
//  Copyright (c) 2014年 iuiue. All rights reserved.
//

#import "iuiueMyView.h"

@implementation iuiueMyView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        _isOn = NO;
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        table = [[UITableView alloc]initWithFrame:CGRectMake(MY_SCREEN.size.width - 80, 64, 80, 132)];
        table.bounces = YES;
        table.delegate = self;
        table.dataSource = self;
        [self addSubview:table];
    }
    return self;
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self hideView];
}

-(void)hideView{
    [self removeFromSuperview];
    _isOn = YES;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"全部评价";
            cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:11];
            cell.textLabel.adjustsLetterSpacingToFitWidth = YES;
            break;
        case 1:
            cell.textLabel.text = @"未评价";
            cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:11];
            cell.textLabel.adjustsLetterSpacingToFitWidth = YES;
            break;
        case 2:
            cell.textLabel.text = @"已评价";
            cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:11];
            cell.textLabel.adjustsLetterSpacingToFitWidth = YES;
            break;
            
        default:
            break;
    }
        return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.delegate clickButtonIndex:indexPath.row];
    switch (indexPath.row) {
        case 0:
            NSLog(@"%d",indexPath.row);
            
            break;
        case 1:
            NSLog(@"%d",indexPath.row);
            break;
        case 2:
            NSLog(@"%d",indexPath.row);
            break;
            
        default:
            break;
    }
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
