//
//  MFYChatMoreView.h
//  Earth
//
//  Created by colr on 2020/3/4.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MFYRecorderView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol MoreViewRecoderDelegate <NSObject>

@optional

- (void)finishRecoderAudioPath:(NSString *)audioPath
                audioDuration:(NSString *)audioDuration;

@end


@interface MFYChatMoreView : UIView

/**
 *  录音view
 */
@property (strong, nonatomic) MFYRecorderView *recorderView;

@property (assign, nonatomic) id<MoreViewRecoderDelegate>delegate;


@end

NS_ASSUME_NONNULL_END
