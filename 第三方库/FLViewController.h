//
//  FLViewController.h
//  15-QQ聊天布局
//
//  Created by Liu Feng on 13-12-3.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FLViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong,nonatomic) NSString *UserId;
@property (weak, nonatomic) IBOutlet UITextField *messageField;
@property (weak, nonatomic) IBOutlet UIButton *speakBtn;
- (IBAction)voiceBtnClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (nonatomic,assign) BOOL IsPass;

@end
