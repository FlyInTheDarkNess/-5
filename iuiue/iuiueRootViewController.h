//
//  iuiueRootViewController.h
//  iuiue
//
//  Created by mizilang on 14-5-8.
//  Copyright (c) 2014年 iuiue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface iuiueRootViewController : UIViewController

@property(nonatomic,strong)id delegate;
@property(nonatomic ,strong)NSString *message;
- (IBAction)clickBtn:(id)sender;

@end
