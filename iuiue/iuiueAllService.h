//
//  iuiueAllService.h
//  iuiue
//
//  Created by 赵中良 on 14-5-15.
//  Copyright (c) 2014年 iuiue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"

@interface iuiueAllService : NSObject<ASIHTTPRequestDelegate>

@property(nonatomic,strong)NSDictionary *diction;
@property(nonatomic,strong)NSString *error;

//登陆接口获取
-(BOOL)loginDictionaryInit:(NSDictionary *)loginDictionary;//成功

//app统计接口
-(BOOL)applogDictionaryInit:(NSDictionary *)applogDictionary;

//意见反馈接口
-(BOOL)feedBackDictionaryInit:(NSDictionary *)feedBackDictionary;//成功

//检测版本更新接口
-(BOOL)updateDictionaryInit:(NSDictionary *)updateDictionary;//成功

//短信验证码接口
-(BOOL)captchaDictionaryInit:(NSDictionary *)captchaDictionary;//成功，短信间隔为一分钟

//找回密码接口
-(BOOL)passwordFindDictionaryInit:(NSDictionary *)forgetPWDDictionary;//待定，周一解决

//房东租币接口
-(BOOL)landlordRentDictionaryInit:(NSDictionary *)rentDictionary;//成功

//申请提现接口
-(BOOL)applyforCashDictionaryInit:(NSDictionary *)cashDictionary;

//订单列表
-(BOOL)orderlistDictionaryInit:(NSDictionary *)orderDictionary;//成功

//订单收取定金
-(BOOL)getDepositDictionaryInit:(NSDictionary *)depositDictionary;

//确认订单
-(BOOL)ConfirmingOrderDictionaryInit:(NSDictionary *)canPayDictionary;

//设置收款方式
-(BOOL)wayForGetCashDictinaryInit:(NSDictionary *)saveChargeDictionary;

//房间列表
-(BOOL)myRoomsDictionaryInit:(NSDictionary *)myRoomsDictionary;

//四个月排期
-(BOOL)calendarsDictionaryInit:(NSDictionary *)calendarsDictionary;

//排期修改接口
-(BOOL)editcalendarsDictionaryInit:(NSDictionary *)editcalendarsDictionary;

//评价列表接口
-(BOOL)appraiseDictionaryInit:(NSDictionary *)appraiseDictionary;

//评价回评接口
-(BOOL)reappraiseDictionaryInit:(NSDictionary *)reappraiseDictionary;

//订单数量接口
-(BOOL)ordercountDictionaryInit:(NSDictionary *)ordercountDictionary;

//我的收益接口
-(BOOL)orderStatisticsDictionaryInit:(NSDictionary *)orderStatisticsDictionary;

//判断当前网络状况
-(BOOL) isConnectionAvailable;

@end
