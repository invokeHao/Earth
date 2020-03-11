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

typedef NS_ENUM(NSUInteger, MFYRecoderDisplayType) {
    MFYRecoderDisplayTypeAudioFlow,
    MFYRecoderDisplayTypeChat,
};

typedef void(^publishBlock)(BOOL isSuccess);

typedef void(^sendChatBlock)(NSString * _Nullable audioPath, NSString * _Nullable audioDuration);

NS_ASSUME_NONNULL_BEGIN

@interface MFYRecorderView : UIView

@property (nonatomic, assign)MFYRecorderViewType recordType;
@property (nonatomic, assign)MFYRecoderDisplayType displayType;

@property (nonatomic, strong)publishBlock publishB;

@property (nonatomic, strong)sendChatBlock sendChatB;

- (void)updateCirclePercent:(CGFloat)percent;

- (instancetype)initWithFrame:(CGRect)frame displayType:(MFYRecoderDisplayType)displayType;

@end

NS_ASSUME_NONNULL_END
