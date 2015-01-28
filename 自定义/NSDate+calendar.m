//
//  NSDate+calendar.m
//  rili
//
//  Created by 赵中良 on 14-5-21.
//  Copyright (c) 2014年 com.iuiue. All rights reserved.
//

#import "NSDate+calendar.h"

@implementation NSDate (calendar)

- (NSInteger)numberOfDaysInCurrentMonth
{
    // 频繁调用 [NSCalendar currentCalendar] 可能存在性能问题
    return [[NSCalendar currentCalendar] rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:self].length;
}
- (NSDate *)firstDayOfCurrentMonth
{
    NSDate *startDate = nil;
    BOOL ok = [[NSCalendar currentCalendar] rangeOfUnit:NSMonthCalendarUnit startDate:&startDate interval:NULL forDate:self];
    NSAssert1(ok, @"Failed to calculate the first day of the month based on %@", self);
    return startDate;
}

- (NSInteger)weeklyOrdinality
{
    return [[NSCalendar currentCalendar] ordinalityOfUnit:NSDayCalendarUnit inUnit:NSWeekCalendarUnit forDate:self];
}
- (NSInteger)numberOfWeeksInCurrentMonth
{
    NSInteger weekday = [[self firstDayOfCurrentMonth] weeklyOrdinality];
    
    NSInteger days = [self numberOfDaysInCurrentMonth];
    NSInteger weeks = 0;
    
    if (weekday > 1) {
        weeks += 1, days -= (7 - weekday + 1);
    }
    
    weeks += days / 7 ;
    weeks += (days % 7 > 0) ? 1 : 0;
    
    return weeks;
}

-(NSDate *)firstDayOfNextMonth{
    NSDateComponents *comps = nil;
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *date = [self firstDayOfThisMonth];
    comps = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:date];
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    
    [adcomps setYear:0];
    
    [adcomps setMonth:+1];
    
    [adcomps setDay:0];
    
    NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:date options:0];
    return newdate;
}

-(NSDate *)firstDayOfThisMonth{
    NSDate *date = [NSDate dateWithTimeInterval:24 * 60 *60 sinceDate:[self firstDayOfCurrentMonth]];
    return date;
}

-(NSInteger)monthlyOrdinality{
    return [[NSCalendar currentCalendar] ordinalityOfUnit:NSMonthCalendarUnit inUnit:NSYearCalendarUnit forDate:self];
}

-(NSInteger)daylyOrdinality{
    return [[NSCalendar currentCalendar] ordinalityOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:self];
}

-(NSInteger)yearlyOrdinality{
    return [[NSCalendar currentCalendar] ordinalityOfUnit:NSYearCalendarUnit inUnit:NSEraCalendarUnit forDate:self];
}


@end
