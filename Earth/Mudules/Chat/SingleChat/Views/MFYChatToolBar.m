//
//  MFYChatToolBar.m
//  Earth
//
//  Created by colr on 2020/2/28.
//  Copyright © 2020 fuYin. All rights reserved.
//


#import "MFYChatToolBar.h"
#import "JCHATStringUtils.h"
#import <AVFoundation/AVFoundation.h>

static NSInteger const st_toolBarTextSize = 17.0f;

@implementation MFYChatToolBar

- (instancetype)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
      [self setupViews];
      [self bindEvents];
  }
  return self;
}

#pragma mark---加载子view
- (void)setupViews {
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.voiceButton];
    [self addSubview:self.MessagetextView];
    [self addSubview:self.faceButton];
    [self addSubview:self.imageButton];
}

- (void)bindEvents {
    
}

//- (IBAction)addBtnClick:(id)sender {
//  if (self.delegate && [self.delegate respondsToSelector:@selector(noPressmoreBtnClick:)]) {
//    if (self.addButton.selected) {
//      self.addButton.selected = NO;
//      [self.delegate noPressmoreBtnClick:sender];
//    } else if (self.delegate && [self.delegate respondsToSelector:@selector(pressMoreBtnClick:)]){
//      [self.delegate pressMoreBtnClick:sender];
//      self.addButton.selected=YES;
//    }
//  }
//}
//
//- (IBAction)voiceBtnClick:(id)sender {
//  [self switchInputMode];
//}

- (void)switchInputMode {
  if (self.voiceButton.selected == NO) {
  _textViewHeight.constant = 36;
    [self switchToVoiceInputMode];
  } else {
    [self switchToTextInputMode];
  }
}

- (void)switchToVoiceInputMode {
  self.voiceButton.selected = YES;
  [self.MessagetextView setHidden:YES];
  if (self.delegate && [self.delegate respondsToSelector:@selector(pressVoiceBtnToHideKeyBoard)]) {
    [self.delegate pressVoiceBtnToHideKeyBoard];
  }
}

- (void)switchToTextInputMode {
  [self switchToolbarToTextMode];
  if (self.delegate && [self.delegate respondsToSelector:@selector(switchToTextInputMode)]) {
    [self.delegate switchToTextInputMode];
  }
}

- (void)switchToolbarToTextMode {
  self.voiceButton.selected=NO;
  self.voiceButton.contentMode = UIViewContentModeCenter;
  [self.MessagetextView setHidden:NO];
}

- (void)layoutSubviews {
  [super layoutSubviews];

}

- (void)drawRect:(CGRect)rect {
    self.voiceButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin;
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    [self addGestureRecognizer:gesture];
    CGFloat toolBarHeight = HOME_INDICATOR_HEIGHT + 45;
    [self setFrame:CGRectMake(0, VERTICAL_SCREEN_HEIGHT - toolBarHeight, VERTICAL_SCREEN_WIDTH, toolBarHeight)];
    
    [self.voiceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(14);
        make.left.mas_equalTo(11);
        make.size.mas_equalTo(CGSizeMake(29, 29));
    }];
}

#pragma mark - Message input view

- (void)adjustTextViewHeightBy:(CGFloat)changeInHeight {
  // 动态改变自身的高度和输入框的高度
  
  NSUInteger numLines = MAX([self.MessagetextView numberOfLinesOfText],
                            [self.MessagetextView.text numberOfLines]);
  
  if ([_MessagetextView.text isEqualToString: @""]) {
    return;
  }
  
  CGSize textSize = [JCHATStringUtils stringSizeWithWidthString:_MessagetextView.text withWidthLimit:_MessagetextView.frame.size.width withFont:WHFont(17)];
  CGFloat textViewHeight = textSize.height + 30;
  _textViewHeight.constant = textViewHeight>36?textViewHeight:36;
  self.MessagetextView.contentInset = UIEdgeInsetsMake((numLines >= 6 ? 4.0f : 0.0f),
                                                0.0f,
                                                (numLines >= 6 ? 4.0f : 0.0f),
                                                0.0f);
  // from iOS 7, the content size will be accurate only if the scrolling is enabled.
  self.MessagetextView.scrollEnabled = YES;
  if (numLines >= 6) {
    CGPoint bottomOffset = CGPointMake(0.0f, self.MessagetextView.contentSize.height - self.MessagetextView.bounds.size.height);
    [self.MessagetextView setContentOffset:bottomOffset animated:YES];
    [self.MessagetextView scrollRangeToVisible:NSMakeRange(self.MessagetextView.text.length - 2, 1)];
  }
}

#pragma mark --判断能否录音
- (BOOL)canRecord
{
  __block BOOL bCanRecord = YES;
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
      [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
        if (granted) {
          bCanRecord = YES;
        }
        else {
          bCanRecord = NO;
          dispatch_async(dispatch_get_main_queue(), ^{
              [[WHAlertTool shareInstance] showALterViewWithOneButton:@"关闭" andMessage:@"请在“设置-隐私-麦克风”选项中，允许jpushIM访问你的手机麦克风。"];
          });
        }
      }];
    }
    return bCanRecord;
}

- (void)tapClick:(UIGestureRecognizer *)gesture
{
  [self.MessagetextView resignFirstResponder];
}

#pragma mark -
#pragma mark RecordingDelegate
- (void)recordingFinishedWithFileName:(NSString *)filePath time:(NSTimeInterval)interval
{
  WHLogSuccess(@"录音完成，文件路径:%@",filePath);
  if (interval < 0.50) {
    [JCHATFileManager deleteFile:filePath];
    return;
  }
  dispatch_async(dispatch_get_main_queue(), ^{
    NSRange range = [filePath rangeOfString:@"spx"];
    if (range.length > 0) {
      if (self.delegate && [self.delegate respondsToSelector:@selector(playVoice:time:)]) {
        [self.delegate playVoice:filePath time:[NSString stringWithFormat:@"%.f",ceilf(interval)]];
      }
    }
  });
}

- (void)recordingTimeout
{
  self.isRecording = NO;
}

- (void)recordingStopped //录音机停止采集声音
{
  self.isRecording = NO;
  
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
  if ([text isEqualToString:@"\n"]) {
    if (self.delegate && [self.delegate respondsToSelector:@selector(sendText:)]) {
      [self.delegate sendText:textView.text];
    }
    textView.text=@"";
    return NO;
  }
  return YES;
}

#pragma mark - Text view delegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
  if ([self.delegate respondsToSelector:@selector(inputTextViewWillBeginEditing:)]) {
    [self.delegate inputTextViewWillBeginEditing:self.MessagetextView];
  }
  return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
  [textView becomeFirstResponder];
  if ([self.delegate respondsToSelector:@selector(inputTextViewDidBeginEditing:)]) {
    [self.delegate inputTextViewDidBeginEditing:self.MessagetextView];
  }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
  if ([self.delegate respondsToSelector:@selector(inputTextViewDidEndEditing:)]) {
    [self.delegate inputTextViewDidEndEditing:self.MessagetextView];
  }
}

- (void)textViewDidChange:(UITextView *)textView {
  if ([self.delegate respondsToSelector:@selector(inputTextViewDidChange:)]) {
    [self.delegate inputTextViewDidChange:self.MessagetextView];
  }
}

+ (CGFloat)textViewLineHeight {
  return st_toolBarTextSize * [UIScreen mainScreen].scale; // for fontSize 16.0f
}

+ (CGFloat)maxLines {
  return ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) ? 3.0f : 8.0f;
}

+ (CGFloat)maxHeight {
  return ([MFYChatToolBar maxLines] + 1.0f) * [MFYChatToolBar textViewLineHeight];
}

- (void)dealloc{
  [[NSNotificationCenter defaultCenter] removeObserver:self
                                                  name:UIKeyboardWillShowNotification
                                                object:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self
                                                  name:UIKeyboardWillHideNotification
                                                object:nil];
  _MessagetextView = nil;
}

- (UIButton *)voiceButton {
    if (!_voiceButton) {
        _voiceButton = UIButton.button.WH_setImage_forState(WHImageNamed(@"chatBar_voice"),UIControlStateNormal);
    }
    return _voiceButton;
}

- (UIButton *)faceButton {
    if (!_faceButton) {
        _faceButton = UIButton.button.WH_setImage_forState(WHImageNamed(@"chatBar_face"),UIControlStateNormal);
    }
    return _faceButton;
}

- (UIButton *)imageButton {
    if (!_imageButton) {
        _imageButton = UIButton.button.WH_setImage_forState(WHImageNamed(@"chatBar_img"),UIControlStateNormal);
    }
    return _imageButton;
}

- (MFYMessageTextView *)MessagetextView {
    if (!_MessagetextView) {
        _MessagetextView = [[MFYMessageTextView alloc]init];
        _MessagetextView.delegate = self;
        _MessagetextView.returnKeyType = UIReturnKeySend;

    }
    return _MessagetextView;
}

@end


@implementation MFYChatToolBarContainer


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}


- (void)setupViews {
  [self addSubview:self.toolbar];
}

- (MFYChatToolBar *)toolbar {
    if (!_toolbar) {
        _toolbar = [[MFYChatToolBar alloc]initWithFrame:CGRectMake(0, 0, VERTICAL_SCREEN_WIDTH, 45 + HOME_INDICATOR_HEIGHT)];
    }
    return _toolbar;
}

@end

