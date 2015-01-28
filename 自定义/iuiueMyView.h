//
//  iuiueMyView.h
//  木鸟房东端
//
//  Created by 赵中良 on 14-7-23.
//  Copyright (c) 2014年 iuiue. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol iuiueMyViewDelegate <NSObject>

-(void)clickButtonIndex:(NSInteger)index;

@end

@interface iuiueMyView : UIView<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *table;
}

@property(nonatomic,weak)id <iuiueMyViewDelegate>delegate;

@property(nonatomic,assign)NSInteger Number;

@property(nonatomic,assign)BOOL isOn;



-(void)hideView;

@end
