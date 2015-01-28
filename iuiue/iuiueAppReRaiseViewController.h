//
//  iuiueAppReRaiseViewController.h
//  木鸟房东端
//
//  Created by 赵中良 on 14-7-23.
//  Copyright (c) 2014年 iuiue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface iuiueAppReRaiseViewController : UIViewController

@property (nonatomic,strong)NSDictionary *MyDic;

@property (nonatomic,weak)id<TransmitProtocol>delegate;

@end
