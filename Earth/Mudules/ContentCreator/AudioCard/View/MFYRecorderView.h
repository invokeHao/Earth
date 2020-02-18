//
//  MFYRecorderView.h
//  Earth
//
//  Created by colr on 2020/2/17.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, MFYRecorderViewType) {
    MFYRecorderReadyType,
    MFYRecordingType,
    MFYRecorderFinishType,   //录音完成
    MFYRecorderPlayingType,  //正在播放录音
};

typedef void(^publishBlock)(BOOL isSuccess);

NS_ASSUME_NONNULL_BEGIN

@interface MFYRecorderView : UIView

@property (nonatomic, assign)MFYRecorderViewType recordType;

@property (nonatomic, strong)publishBlock publishB;

- (void)updateCirclePercent:(CGFloat)percent;

@end

NS_ASSUME_NONNULL_END
