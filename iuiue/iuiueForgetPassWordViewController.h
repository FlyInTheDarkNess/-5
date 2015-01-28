//
//  iuiueForgetPassWordViewController.h
//  iuiue
//
//  Created by 赵中良 on 14-5-20.
//  Copyright (c) 2014年 iuiue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iuiueAllService.h"
#import "Toast+UIView.h"
@interface iuiueForgetPassWordViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *mobileNumber;
@property (weak, nonatomic) IBOutlet UITextField *captcha;
@property (weak, nonatomic) IBOutlet UITextField *firstPassWord;
@property (weak, nonatomic) IBOutlet UITextField *secondPassWord;
@property (weak, nonatomic) IBOutlet UIButton *getCaptchaButton;
@property (weak, nonatomic) IBOutlet UIButton *changeButton;
- (IBAction)getCaptcha:(id)sender;
- (IBAction)change:(id)sender;



@end
