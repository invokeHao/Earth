//
//  WHTimeUtil.h
//  Earth
//
//  Created by colr on 2020/2/16.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WHTimeUtil : NSObject

+ (NSString *)articleCardDateStringByTimeStamp:(NSTimeInterval)timeStamp;


//获取月和日
+ (NSString *)getMonthAndDayByTimeStamp:(NSTimeInterval)timeStamp;

//获取小时和分钟
+ (NSString *)getHourDateByTimeStamp:(NSTimeInterval)timeStamp;

@end

NS_ASSUME_NONNULL_END
