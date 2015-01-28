//
//  NSDate+calendar.h
//  rili
//
//  Created by 赵中良 on 14-5-21.
//  Copyright (c) 2014年 com.iuiue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (calendar)

- (NSInteger)numberOfDaysInCurrentMonth;

- (NSDate *)firstDayOfCurrentMonth;

- (NSInteger)weeklyOrdinality;

- (NSInteger)numberOfWeeksInCurrentMonth;

- (NSDate *)firstDayOfNextMonth;

- (NSDate *)firstDayOfThisMonth;

- (NSInteger)monthlyOrdinality;

- (NSInteger)daylyOrdinality;

- (NSInteger)yearlyOrdinality;

@end
