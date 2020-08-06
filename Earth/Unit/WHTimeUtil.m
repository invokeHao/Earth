//
//  WHTimeUtil.m
//  Earth
//
//  Created by colr on 2020/2/16.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import "WHTimeUtil.h"

NSTimeInterval const OneMinute = 60;
NSTimeInterval const OneHour = 1800;
NSTimeInterval const OneDay = 86400;
NSTimeInterval const OneWeek = 604800;

@implementation WHTimeUtil

+ (NSString *)articleCardDateStringByTimeStamp:(NSTimeInterval)timeStamp {
    NSTimeInterval inputStamp = timeStamp / 1000;
    NSTimeInterval currentStamp = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval distanceStamp = currentStamp - inputStamp;
    NSString *displayString = @"";
    if (distanceStamp > 0 && distanceStamp < OneMinute) {
        NSInteger second = distanceStamp;
        displayString = [NSString stringWithFormat:@"%zd秒前",second];
    } else if (distanceStamp >= OneMinute && distanceStamp < OneHour) {
        NSInteger minute = distanceStamp / 60;
        minute = MAX(1, minute);
        displayString = [NSString stringWithFormat:@"%zd分钟前", minute];
    } else if (distanceStamp >= OneHour && distanceStamp < OneDay) {
        NSInteger hour = (distanceStamp / 3600);
        hour = MAX(1, hour);
        displayString = [NSString stringWithFormat:@"%zd小时前", hour];
    } else if (distanceStamp >= OneDay) {
        displayString = [self commentDateToString:[NSDate dateWithTimeIntervalSince1970:inputStamp]
                                 componets:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay];
    }
    return displayString;
}

+ (NSString *)commentDateToString:(NSDate *)date componets:(NSCalendarUnit)unitFlags {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:unitFlags fromDate:date];
    NSString *dateString = @"";
    BOOL isCurrentYear = YES;
    if (components.year < [self currentYear]) {
        dateString = [[dateString stringByAppendingString:[@(components.year) stringValue]] stringByAppendingString:@"-"];
        isCurrentYear = NO;
    }
    if (components.month > 0) {
        dateString = [[dateString stringByAppendingString:[@(components.month) stringValue]] stringByAppendingString:@"-"];
    }
    if (components.day > 0) {
        dateString = [[dateString stringByAppendingString:[@(components.day) stringValue]] stringByAppendingString:@" "];
    }
    if (isCurrentYear) {
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"HH:mm"];
        NSString * detailStr = [format stringFromDate:date];
        dateString = [dateString stringByAppendingString:detailStr];
    }
    return dateString;
}


+ (NSString *)getHourDateByTimeStamp:(NSTimeInterval)timeStamp {
    NSTimeInterval inputStamp = timeStamp / 1000;
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:inputStamp];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"HH:mm"];
    NSString * hourStr = [format stringFromDate:date];
    return hourStr;
}

+ (NSString *)getMonthAndDayByTimeStamp:(NSTimeInterval)timeStamp {
    NSTimeInterval inputStamp = timeStamp / 1000;
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:inputStamp];
    NSDateComponents *components = [[NSCalendar currentCalendar] components: NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
    NSString *dateString = @"";
    if (components.month > 0) {
        dateString = [[dateString stringByAppendingString:[@(components.month) stringValue]] stringByAppendingString:@"-"];
    }
    if (components.day > 0) {
        dateString = [dateString stringByAppendingString:[@(components.day) stringValue]];
    }
    return dateString;
}

+ (NSInteger)currentYear {
    NSDate *date =[NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    NSInteger currentYear = [[formatter stringFromDate:date] integerValue];
    return currentYear;
}



@end
