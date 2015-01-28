//
//  iuiueRoomSelectViewController.h
//  木鸟房东端
//
//  Created by 赵中良 on 14-7-9.
//  Copyright (c) 2014年 iuiue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface iuiueRoomSelectViewController : UIViewController

@property(nonatomic,weak)id<TransmitProtocol>delegate;

@property(nonatomic,strong)NSMutableArray *MyArray;

@end
