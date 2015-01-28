//
//  iuiueAllService.m
//  iuiue
//
//  Created by 赵中良 on 14-5-15.
//  Copyright (c) 2014年 iuiue. All rights reserved.
//

#import "iuiueAllService.h"
#import "Reachability.h"
#import "iuiueCHKeychain.h"
@implementation iuiueAllService

@synthesize diction,error;

/*
 
 mobile = 15511125229;
 status = 0;
 uid = 2126;
 username = "\U827e\U5947\U5ba2\U6808";
 zend = 407e53af2ed8f884455c817ad98662ab;
 
 
 {"status":0,"uid":2126,"mobile":"15511125229","username":"艾奇客栈","zend":"407e53af2ed8f884455c817ad98662ab"}
 
*/




//登陆接口获取
-(BOOL)loginDictionaryInit:(NSDictionary *)loginDictionary
{
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://appapi.muniao.com/server/app_user/api.do?op=login"]];
    request.delegate = self;
    for (id _id in loginDictionary.allKeys) {
        NSString *str = [loginDictionary valueForKey:_id];
        [request addPostValue:str forKey:_id];
    }
    
    [request startSynchronous];
    
    return YES;
}


//app统计接口
-(BOOL)applogDictionaryInit:(NSDictionary *)applogDictionary
{
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://appapi.muniao.com/server/app_user/api.do?op=applog"]];
    request.delegate = self;
    for (id _id in applogDictionary.allKeys) {
        NSString *str = [applogDictionary valueForKey:_id];
        [request addPostValue:str forKey:_id];
    }
    
    [request startSynchronous];
    

    return YES;
}

//意见反馈接口
-(BOOL)feedBackDictionaryInit:(NSDictionary *)feedBackDictionary
{
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://appapi.muniao.com/server/iuiue/infoapp/feedbackios_json.asp"]];
    request.delegate = self;
    for (id _id in feedBackDictionary.allKeys) {
        NSString *str = [feedBackDictionary valueForKey:_id];
        [request addPostValue:str forKey:_id];
    }
    
    [request startSynchronous];
    return YES;
}

//检测版本更新接口
-(BOOL)updateDictionaryInit:(NSDictionary *)updateDictionary
{
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://appapi.muniao.com/server/app_user/api.do?op=checkupdateios"]];
    request.delegate = self;
    for (id _id in updateDictionary) {
        NSString *str = [updateDictionary valueForKey:_id];
        [request addPostValue:str forKey:_id];
    }
    
    [request startSynchronous];
    return YES;
}

//短信验证码接口
-(BOOL)captchaDictionaryInit:(NSDictionary *)captchaDictionary
{
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://appapi.muniao.com/server/app_user/api.do?op=vaildatecode"]];
    request.delegate = self;

    for (id _id in captchaDictionary.allKeys) {
        NSString *str = [captchaDictionary valueForKey:_id];
        [request addPostValue:str forKey:_id];
    }
    
    [request startSynchronous];
    return YES;
}

//找回密码接口
-(BOOL)passwordFindDictionaryInit:(NSDictionary *)forgetPWDDictionary
{
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://appapi.muniao.com/server/app_user/api.do?op=forgetpwd"]];
    request.delegate = self;

    for (id _id in forgetPWDDictionary.allKeys) {
        NSString *str = [forgetPWDDictionary valueForKey:_id];
        [request addPostValue:str forKey:_id];
    }
    
    [request startSynchronous];
    return YES;
}

//房东租币接口
-(BOOL)landlordRentDictionaryInit:(NSDictionary *)rentDictionary
{
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://appapi.muniao.com/server/app_user/api.do?op=accounts"]];
    request.delegate = self;
    NSMutableDictionary *usernamepasswordKVPairs = (NSMutableDictionary *)[iuiueCHKeychain load:@"com.company.muniao.usernamepassword"];
    NSString *uid =[usernamepasswordKVPairs objectForKey:@"com.company.muniao.username"];
    NSString *zend = [usernamepasswordKVPairs objectForKey:@"com.company.muniao.password"];
    NSDictionary *dica =[NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",zend ,@"zend",nil];
    for (id _id in dica.allKeys) {
        NSString *str = [dica valueForKey:_id];
        [request addPostValue:str forKey:_id];
    }
    [request startSynchronous];
    return YES;
}

//申请提现接口
-(BOOL)applyforCashDictionaryInit:(NSDictionary *)cashDictionary
{
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://appapi.muniao.com/server/app_user/api.do?op=cash"]];
    request.delegate = self;
 
    for (id _id in cashDictionary.allKeys) {
        NSString *str = [cashDictionary valueForKey:_id];
        [request addPostValue:str forKey:_id];
    }
    NSMutableDictionary *usernamepasswordKVPairs = (NSMutableDictionary *)[iuiueCHKeychain load:@"com.company.muniao.usernamepassword"];
    NSString *uid =[usernamepasswordKVPairs objectForKey:@"com.company.muniao.username"];
    NSString *zend = [usernamepasswordKVPairs objectForKey:@"com.company.muniao.password"];
    NSDictionary *dica =[NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",zend ,@"zend",nil];
    for (id _id in dica.allKeys) {
        NSString *str = [dica valueForKey:_id];
        [request addPostValue:str forKey:_id];
    }
    
    [request startSynchronous];
    return YES;
}

//订单列表
-(BOOL)orderlistDictionaryInit:(NSDictionary *)orderDictionary
{
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://appapi.muniao.com/server/app_user/api.do?op=orderlist"]];
    request.delegate = self;

    for (id _id in orderDictionary.allKeys) {
        NSString *str = [orderDictionary valueForKey:_id];
        [request addPostValue:str forKey:_id];
    }
    NSMutableDictionary *usernamepasswordKVPairs = (NSMutableDictionary *)[iuiueCHKeychain load:@"com.company.muniao.usernamepassword"];
    NSString *uid =[usernamepasswordKVPairs objectForKey:@"com.company.muniao.username"];
    NSString *zend = [usernamepasswordKVPairs objectForKey:@"com.company.muniao.password"];
    NSDictionary *dica =[NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",zend ,@"zend",nil];
    for (id _id in dica.allKeys) {
        NSString *str = [dica valueForKey:_id];
        [request addPostValue:str forKey:_id];
    }
    
    [request startSynchronous];
    return YES;
}

//订单收取定金
-(BOOL)getDepositDictionaryInit:(NSDictionary *)depositDictionary
{
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://appapi.muniao.com/server/app_user/api.do?op=hire"]];
    request.delegate = self;
    for (id _id in depositDictionary.allKeys) {
        NSString *str = [depositDictionary valueForKey:_id];
        [request addPostValue:str forKey:_id];
    }
    NSMutableDictionary *usernamepasswordKVPairs = (NSMutableDictionary *)[iuiueCHKeychain load:@"com.company.muniao.usernamepassword"];
    NSString *uid =[usernamepasswordKVPairs objectForKey:@"com.company.muniao.username"];
    NSString *zend = [usernamepasswordKVPairs objectForKey:@"com.company.muniao.password"];
    NSDictionary *dica =[NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",zend,@"zend",nil];
    for (id _id in dica.allKeys) {
        NSString *str = [dica valueForKey:_id];
        [request addPostValue:str forKey:_id];
    }
    
    [request startSynchronous];
    return YES;
}

//确认订单
-(BOOL)ConfirmingOrderDictionaryInit:(NSDictionary *)canPayDictionary
{
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://appapi.muniao.com/server/app_user/api.do?op=ordercanpay"]];
    request.delegate = self;
    for (id _id in canPayDictionary.allKeys) {
        NSString *str = [canPayDictionary valueForKey:_id];
        [request addPostValue:str forKey:_id];
    }
    NSMutableDictionary *usernamepasswordKVPairs = (NSMutableDictionary *)[iuiueCHKeychain load:@"com.company.muniao.usernamepassword"];
    NSString *uid =[usernamepasswordKVPairs objectForKey:@"com.company.muniao.username"];
    NSString *zend = [usernamepasswordKVPairs objectForKey:@"com.company.muniao.password"];
    NSDictionary *dica =[NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",zend,@"zend",nil];
    for (id _id in dica.allKeys) {
        NSString *str = [dica valueForKey:_id];
        [request addPostValue:str forKey:_id];
    }
    
    [request startSynchronous];
    return YES;
}

//设置收款方式
-(BOOL)wayForGetCashDictinaryInit:(NSDictionary *)saveChargeDictionary
{
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://appapi.muniao.com/server/app_user/api.do?op=savecharge"]];
    request.delegate = self;
    for (id _id in saveChargeDictionary.allKeys) {
        NSString *str = [saveChargeDictionary valueForKey:_id];
        [request addPostValue:str forKey:_id];
    }
    NSMutableDictionary *usernamepasswordKVPairs = (NSMutableDictionary *)[iuiueCHKeychain load:@"com.company.muniao.usernamepassword"];
    NSString *uid =[usernamepasswordKVPairs objectForKey:@"com.company.muniao.username"];
    NSString *zend = [usernamepasswordKVPairs objectForKey:@"com.company.muniao.password"];
    NSDictionary *dica =[NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",zend,@"zend",nil];
    for (id _id in dica.allKeys) {
        NSString *str = [dica valueForKey:_id];
        [request addPostValue:str forKey:_id];
    }
    
    [request startSynchronous];
    return YES;
}

//房间列表
-(BOOL)myRoomsDictionaryInit:(NSDictionary *)myRoomsDictionary
{
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://appapi.muniao.com/server/app_user/api.do?op=myrooms"]];
    request.delegate = self;
    NSMutableDictionary *usernamepasswordKVPairs = (NSMutableDictionary *)[iuiueCHKeychain load:@"com.company.muniao.usernamepassword"];
    NSString *uid =[usernamepasswordKVPairs objectForKey:@"com.company.muniao.username"];
    NSString *zend = [usernamepasswordKVPairs objectForKey:@"com.company.muniao.password"];
    NSDictionary *dica =[NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",zend,@"zend",nil];
    for (id _id in dica.allKeys) {
        NSString *str = [dica valueForKey:_id];
        [request addPostValue:str forKey:_id];
    }
    for (id _id in myRoomsDictionary.allKeys) {
        NSString *str = [myRoomsDictionary valueForKey:_id];
        [request addPostValue:str forKey:_id];
    }
    
    [request startSynchronous];
    return YES;
}

//四个月排期
-(BOOL)calendarsDictionaryInit:(NSDictionary *)calendarsDictionary
{
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://appapi.muniao.com/server/app_user/api.do?op=calendars"]];
    request.delegate = self;
    for (id _id in calendarsDictionary.allKeys) {
        NSString *str = [calendarsDictionary valueForKey:_id];
        [request addPostValue:str forKey:_id];
    }
    NSMutableDictionary *usernamepasswordKVPairs = (NSMutableDictionary *)[iuiueCHKeychain load:@"com.company.muniao.usernamepassword"];
    NSString *uid =[usernamepasswordKVPairs objectForKey:@"com.company.muniao.username"];
    NSString *zend = [usernamepasswordKVPairs objectForKey:@"com.company.muniao.password"];
    NSDictionary *dica =[NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",zend ,@"zend",nil];
    for (id _id in dica.allKeys) {
        NSString *str = [dica valueForKey:_id];
        [request addPostValue:str forKey:_id];
    }
    
    [request startSynchronous];
    return YES;
}

//排期修改接口
-(BOOL)editcalendarsDictionaryInit:(NSDictionary *)editcalendarsDictionary
{
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://appapi.muniao.com/server/app_user/api.do?op=editcalendars"]];
    request.delegate = self;
    for (id _id in editcalendarsDictionary.allKeys) {
        NSString *str = [editcalendarsDictionary valueForKey:_id];
        [request addPostValue:str forKey:_id];
    }
    NSMutableDictionary *usernamepasswordKVPairs = (NSMutableDictionary *)[iuiueCHKeychain load:@"com.company.muniao.usernamepassword"];
    NSString *uid =[usernamepasswordKVPairs objectForKey:@"com.company.muniao.username"];
    NSString *zend = [usernamepasswordKVPairs objectForKey:@"com.company.muniao.password"];
    NSDictionary *dica =[NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",zend,@"zend",nil];
    for (id _id in dica.allKeys) {
        NSString *str = [dica valueForKey:_id];
        [request addPostValue:str forKey:_id];
    }
    
    [request startSynchronous];
    return YES;
}

//评价列表接口
-(BOOL)appraiseDictionaryInit:(NSDictionary *)appraiseDictionary
{
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://appapi.muniao.com/server/app_user/api.do?op=appraise"]];
    request.delegate = self;
    for (id _id in appraiseDictionary.allKeys)
    {
        NSString *str = [appraiseDictionary valueForKey:_id];
        [request addPostValue:str forKey:_id];
    }
    NSMutableDictionary *usernamepasswordKVPairs = (NSMutableDictionary *)[iuiueCHKeychain load:@"com.company.muniao.usernamepassword"];
    NSString *uid =[usernamepasswordKVPairs objectForKey:@"com.company.muniao.username"];
    NSString *zend = [usernamepasswordKVPairs objectForKey:@"com.company.muniao.password"];
    NSDictionary *dica =[NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",zend,@"zend",nil];
    for (id _id in dica.allKeys) {
        NSString *str = [dica valueForKey:_id];
        [request addPostValue:str forKey:_id];
    }
    
    [request startSynchronous];
    return YES;
}

//评价回评接口
-(BOOL)reappraiseDictionaryInit:(NSDictionary *)reappraiseDictionary
{
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://appapi.muniao.com/server/app_user/api.do?op=reappraise"]];
    request.delegate = self;

    for (id _id in reappraiseDictionary.allKeys) {
        NSString *str = [reappraiseDictionary valueForKey:_id];
        [request addPostValue:str forKey:_id];
    }
    NSMutableDictionary *usernamepasswordKVPairs = (NSMutableDictionary *)[iuiueCHKeychain load:@"com.company.muniao.usernamepassword"];
    NSString *uid =[usernamepasswordKVPairs objectForKey:@"com.company.muniao.username"];
    NSString *zend = [usernamepasswordKVPairs objectForKey:@"com.company.muniao.password"];
    NSDictionary *dica =[NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",zend ,@"zend",nil];
    for (id _id in dica.allKeys) {
        NSString *str = [dica valueForKey:_id];
        [request addPostValue:str forKey:_id];
    }
    
    [request startSynchronous];
    return YES;
}

//订单数量接口
-(BOOL)ordercountDictionaryInit:(NSDictionary *)ordercountDictionary
{
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://appapi.muniao.com/server/app_user/api.do?op=neworder"]];
    request.delegate = self;
    NSMutableDictionary *usernamepasswordKVPairs = (NSMutableDictionary *)[iuiueCHKeychain load:@"com.company.muniao.usernamepassword"];
    NSString *uid =[usernamepasswordKVPairs objectForKey:@"com.company.muniao.username"];
    NSString *zend = [usernamepasswordKVPairs objectForKey:@"com.company.muniao.password"];
    NSDictionary *dica =[NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",zend ,@"zend",nil];
    for (id _id in dica.allKeys) {
        NSString *str = [dica valueForKey:_id];
        [request addPostValue:str forKey:_id];
    }
    
    [request startSynchronous];
    
    return YES;
    
}


//我的收益接口
-(BOOL)orderStatisticsDictionaryInit:(NSDictionary *)orderStatisticsDictionary
{
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://appapi.muniao.com/server/app_user/api.do?op=orderstatistics"]];
    request.delegate = self;
    
    for (id _id in orderStatisticsDictionary.allKeys) {
        NSString *str = [orderStatisticsDictionary valueForKey:_id];
        [request addPostValue:str forKey:_id];
    }
    NSMutableDictionary *usernamepasswordKVPairs = (NSMutableDictionary *)[iuiueCHKeychain load:@"com.company.muniao.usernamepassword"];
    NSString *uid =[usernamepasswordKVPairs objectForKey:@"com.company.muniao.username"];
    NSString *zend = [usernamepasswordKVPairs objectForKey:@"com.company.muniao.password"];
    NSDictionary *dica =[NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",zend ,@"zend",nil];
    for (id _id in dica.allKeys) {
        NSString *str = [dica valueForKey:_id];
        [request addPostValue:str forKey:_id];
    }
    
    [request startSynchronous];
    return YES;
}



//-(void)request:(ASIHTTPRequest *)request didReceiveData:(NSData *)data{
//    NSLog(@"2");
//
//}
//
//-(void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders{
//    NSLog(@"3");
//
//}
//
//-(void)request:(ASIHTTPRequest *)request willRedirectToURL:(NSURL *)newURL{
//    NSLog(@"4");
//
//}
//
-(void)requestFailed:(ASIHTTPRequest *)request{
    error = [NSString stringWithFormat:@"网络连接失败..."];
    NSLog(@"%@",request.error);
    //发送失败
}
//
//-(void)requestRedirected:(ASIHTTPRequest *)request{
//    NSLog(@"6");
//
//}
//
//-(void)requestStarted:(ASIHTTPRequest *)request{
//    NSLog(@"1");
//}


-(void)requestFinished:(ASIHTTPRequest *)request{
    diction = [NSDictionary dictionary];
    
    
    NSLog(@"request.responseString：%@",request.responseString);
    NSError *err;
    diction = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingAllowFragments error:&err];
    NSLog(@"%@",err);
    NSLog(@"%@",[diction valueForKey:@"message"]);
//    NSLog(@"数据model层输出：%@",diction);
}

-(BOOL) isConnectionAvailable{
    
    BOOL isExistenceNetwork = YES;
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.apple.com"];
    switch ([reach currentReachabilityStatus]) {
        case NotReachable:
            isExistenceNetwork = NO;
            //NSLog(@"notReachable");
            break;
        case ReachableViaWiFi:
            isExistenceNetwork = YES;
            //NSLog(@"WIFI");
            break;
        case ReachableViaWWAN:
            isExistenceNetwork = YES;
            //NSLog(@"3G");
            break;
    }
    if (!isExistenceNetwork) {
//        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];//<span style="font-family: Arial, Helvetica, sans-serif;">MBProgressHUD为第三方库，不需要可以省略或使用AlertView</span>
//        hud.removeFromSuperViewOnHide =YES;
//        hud.mode = MBProgressHUDModeText;
//        hud.labelText = NSLocalizedString(INFO_NetNoReachable, nil);
//        hud.minSize = CGSizeMake(132.f, 108.0f);
//        [hud hide:YES afterDelay:3];
        return NO;
    }
    
    return isExistenceNetwork;
}


@end
