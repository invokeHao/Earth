//
//  MFYTimerButton.h
//  Earth
//
//  Created by colr on 2020/1/16.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MFYTimerButton : UIButton

@property (nonatomic, readonly) NSInteger countDownNumber;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *disableTitle;
@property (nonatomic, strong) UIColor *normalColor;
@property (nonatomic, strong) UIColor *disableColor;
@property (nonatomic, strong) UIColor *normalBGColor;
@property (nonatomic, strong) UIColor *disableBGColor;

- (instancetype)initWithCountDownTime:(NSUInteger)countDown;

/**
 * Before call your callBack, NVMTimerButton will set its title to "已发送(xx)" and be disabled
 * if timer is not expired, if it is expired, its title will be reset to "重新发送" and be reabled.
 **/
- (void)setTimerCallBackBlock:(void (^)(void))timerCallBack;

- (void)startTimer;

- (void)stopTimer;

- (BOOL)isInTiming;


@end

NS_ASSUME_NONNULL_END
