//
//  MFYChatToolBar.h
//  Earth
//
//  Created by colr on 2020/2/28.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MFYMessageTextView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol SendMessageDelegate <NSObject>

@optional
/**
 *  发送文本
 *
 *  @param text 文本
 */
/**
 *  输入框刚好开始编辑
 *
 *  @param messageInputTextView 输入框对象
 */
- (void)inputTextViewDidBeginEditing:(MFYMessageTextView *)messageInputTextView;

- (void)inputTextViewDidEndEditing:(MFYMessageTextView *)messageInputTextView;

- (void)inputTextViewDidChange:(MFYMessageTextView *)messageInputTextView;
/**
 *  输入框将要开始编辑
 *
 *  @param messageInputTextView 输入框对象
 */
- (void)inputTextViewWillBeginEditing:(MFYMessageTextView *)messageInputTextView;

- (void)sendText :(NSString *)text;

- (void)noPressmoreBtnClick :(UIButton *)btn;

- (void)pressMoreBtnClick :(UIButton *)btn;

- (void)startRecordVoice;

- (void)playVoice :(NSString *)voicePath time:(NSString * )time;

- (void)pressVoiceBtnToHideKeyBoard;

- (void)switchToTextInputMode;

@end


@interface MFYChatToolBar : UIView<UITextViewDelegate>

/**
*  语音button
*/
@property (strong, nonatomic) UIButton *voiceButton;

/**
*  表情button
*/

@property (strong, nonatomic) UIButton *faceButton;

/**
 *  图片button
 */

@property (strong, nonatomic) UIButton *imageButton;

/**
 *  文本输入view
 */

@property (strong, nonatomic) MFYMessageTextView * MessagetextView;

/**
 *  Height of textView
 */
@property (strong, nonatomic)  NSLayoutConstraint *textViewHeight;


/**
 *  录音button 的高度
 */
//@property (strong, nonatomic) UIButton *startRecordButton;
/**
 *  是否正在录音
 */
@property (nonatomic) BOOL isRecording;
@property (assign, nonatomic) id<SendMessageDelegate> delegate;
//@property (strong, nonatomic) JCHATRecordAnimationView *recordAnimationView;

@property (nonatomic) BOOL isPlaying;


/**
 *  切换为文本输入模式，并且当前处于输入状态
 */
- (void)switchToTextInputMode;

/**
 *  转换toolbar 为文本输入样式
 */
- (void)switchToolbarToTextMode;
/**
 *  动态改变高度
 *
 *  @param changeInHeight 目标变化的高度
 */
- (void)adjustTextViewHeightBy:(CGFloat)changeInHeight;

/**
 *  获取输入框内容字体行高
 *
 *  @return 返回行高
 */
+ (CGFloat)textViewLineHeight;

/**
 *  获取最大行数
 *
 *  @return 返回最大行数
 */
+ (CGFloat)maxLines;

/**
 *  获取根据最大行数和每行高度计算出来的最大显示高度
 *
 *  @return 返回最大显示高度
 */
+ (CGFloat)maxHeight;
@end




@interface MFYChatToolBarContainer : UIView
@property (strong, nonatomic) MFYChatToolBar *toolbar;

@end
NS_ASSUME_NONNULL_END
