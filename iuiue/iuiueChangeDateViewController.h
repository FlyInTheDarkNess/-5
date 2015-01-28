//
//  iuiueChangeDateViewController.h
//  iuiue
//
//  Created by 赵中良 on 14-5-22.
//  Copyright (c) 2014年 iuiue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface iuiueChangeDateViewController : UIViewController



@property(nonatomic,weak) id delegate;

@property(nonatomic,strong)NSString *startDate;
@property(nonatomic,strong)NSString *endDate;
@property(nonatomic,strong)NSString *roomName;
@property(nonatomic,strong)NSString *roomId;
@property(nonatomic,strong)NSString *location;
@end
