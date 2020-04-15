//
//  MFYRecorderView.m
//  Earth
//
//  Created by colr on 2020/2/17.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import "MFYRecorderView.h"
#import "MFYVoiceRecorder.h"
#import <JPVideoPlayer/UIView+WebVideoCache.h>
#import <AVFoundation/AVFoundation.h>
#import "MFYDynamicManager.h"
#import "MFYPublishModel.h"

#define circleRadio 45
CGFloat const MAX_TIME = 60.0;
CGFloat const INTER_TIME = 0.1;

@interface MFYRecorderView ()<AVAudioPlayerDelegate>

@property (nonatomic, strong) CAShapeLayer *circleLayer;
@property (nonatomic, strong) CAShapeLayer * circleBgLayer;
@property (nonatomic, strong) UILabel *centerLabel;
@property (nonatomic, strong) UIImageView * centerImage;
@property (nonatomic, strong)UILabel * tipsLabel;
@property (nonatomic, strong)UIButton * redoBtn; //撤销按钮
@property (nonatomic, strong)UIButton * finishBtn;//完成按钮
@property (nonatomic, strong)MFYVoiceRecorder * voiceRecorder;
@property (nonatomic, strong)UILabel * guideLabel;
@property (nonatomic, strong)UIView * centerView;
@property (nonatomic, strong) NSTimer *recordTimer;
@property (nonatomic, strong) NSTimer *playTimer;
@property (nonatomic, assign) NSTimeInterval recordTime;
@property (nonatomic, assign) NSTimeInterval playTime;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic, strong) NSString * audioPath;
@property (nonatomic, strong) UIColor * circleBgCorlor;

@property (nonatomic, assign) BOOL isPlaying;

@end

@implementation MFYRecorderView

- (instancetype)initWithFrame:(CGRect)frame displayType:(MFYRecoderDisplayType)displayType {
    self = [super initWithFrame:frame];
    if (self) {
        _recordType = MFYRecorderReadyType;
        _displayType = displayType;
        [self setupViews];
        [self bindEvents];
    }
    return self;
}

- (void)setupViews {
    self.circleBgCorlor = self.displayType == MFYRecoderDisplayTypeChat ? [UIColor whiteColor] : [UIColor blackColor];
    
    [self addSubview:self.centerView];
    [self.centerView addSubview:self.centerImage];
    [self.centerView.layer addSublayer:self.circleBgLayer];
    [self.centerView.layer addSublayer:self.circleLayer];
    
    [self addSubview:self.tipsLabel];
    [self addSubview:self.redoBtn];
    [self addSubview:self.finishBtn];
    [self addSubview:self.guideLabel];

    [self configTheViewWithType:MFYRecorderReadyType];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.centerX.mas_equalTo(self);
        make.height.mas_equalTo(15);
    }];
    
    [self.centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tipsLabel.mas_bottom).offset(15);
        make.centerX.mas_equalTo(self.tipsLabel);
        make.size.mas_equalTo(CGSizeMake(90, 90));
    }];

    [self.centerImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.centerView);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    [self.redoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(W_SCALE(43));
        make.centerY.mas_equalTo(self.centerView);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    [self.finishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(W_SCALE((-43)));
        make.centerY.mas_equalTo(self.centerView);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    [self.guideLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.centerView.mas_bottom).offset(15);
        make.centerX.mas_equalTo(self.tipsLabel);
        make.height.mas_equalTo(15);
    }];

    
    self.centerView.layer.cornerRadius = circleRadio;
    
    if (@available(iOS 11.0, *)) {
        self.centerView.layer.maskedCorners =  kCALayerMinXMinYCorner | kCALayerMinXMaxYCorner | kCALayerMaxXMinYCorner | kCALayerMaxXMaxYCorner ;
    } else {
        self.centerView.layer.masksToBounds = YES;
    }
}

- (void)bindEvents {
    @weakify(self)
    UITapGestureRecognizer * doubleTap = [[UITapGestureRecognizer alloc] init];
    doubleTap.numberOfTapsRequired = 2;
    [[doubleTap rac_gestureSignal] subscribeNext:^(id x) {
       @strongify(self)
        [self doubleTapTheCenterImage];
    }];
    [self.centerView addGestureRecognizer:doubleTap];
    
    UITapGestureRecognizer * singleTap = [[UITapGestureRecognizer alloc] init];
    [[singleTap rac_gestureSignal] subscribeNext:^(UITapGestureRecognizer * tap) {
        @strongify(self)
        [self tapTheCenterImage];
    }];
    [singleTap requireGestureRecognizerToFail:doubleTap];
    [self.centerView addGestureRecognizer:singleTap];
    
    
    UILongPressGestureRecognizer * longPress = [[UILongPressGestureRecognizer alloc]init];
    
    [[longPress rac_gestureSignal] subscribeNext:^(UILongPressGestureRecognizer * longPress) {
        @strongify(self)
        [self longPressTheCenterImage:longPress];
    }];
    [self.centerView addGestureRecognizer:longPress];
    
    [[self.redoBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
       @strongify(self)
        [self resetTheAudio];
    }];
    
    [[self.finishBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
       @strongify(self)
        if (self.sendChatB) {
            self.sendChatB(self.audioPath, FORMAT(@"%.0f",self.recordTime));
        }else {
            [self publishTheAudio];
        }
    }];
}
#pragma mark- 发布音频

- (void)publishTheAudio {
    if (self.audioPath.length < 1) {
        [WHHud showString:@"录音内容为空"];
        return;
    }
    [MFYDynamicManager publishTheAudioArticle:self.audioPath completion:^(MFYArticle * _Nonnull article, NSError * _Nonnull error) {
        if (self.publishB) {
            self.publishB(YES);
        }
        [self resetTheAudio];
    }];
}

#pragma mark- 录音相关

- (void)startRecorder {
    [self configTheViewWithType:MFYRecordingType];
    [self.recordTimer invalidate];
    self.recordTime = 0;
    self.recordTimer = [NSTimer scheduledTimerWithTimeInterval:INTER_TIME
                                                        target:self
                                                      selector:@selector(recordingAction)
                                                      userInfo:nil
                                                       repeats:YES];
    [self.voiceRecorder startRecord];
}

- (void)endRecorder {
    [self.recordTimer invalidate];
    [self.voiceRecorder stopRecord];
    if (self.recordTime < 1.0) {
        [WHHud showString:@"说话的时间太短了"];
        [self configTheViewWithType:MFYRecorderReadyType];
    }else {
        [self configTheViewWithType:MFYRecorderFinishType];
        self.audioPath = [self.voiceRecorder audioCAFtoMP3];
    }
}

- (void)playTheAudio {
    if (self.recordType == MFYRecorderFinishType && self.recordTime > 0) {
        NSData * voiceData = [NSData dataWithContentsOfFile:self.audioPath];
        self.audioPlayer = [[AVAudioPlayer alloc]initWithData:voiceData error:nil];
        self.audioPlayer.delegate = self;
        [self.audioPlayer prepareToPlay];
        [self.audioPlayer play];
        
        self.isPlaying = YES;
        [self.playTimer invalidate];
        self.playTime = self.recordTime;
        self.playTimer = [NSTimer scheduledTimerWithTimeInterval:INTER_TIME
                                                            target:self
                                                          selector:@selector(playingAction)
                                                          userInfo:nil
                                                           repeats:YES];
    }
    [self configTheViewWithType:MFYRecorderPlayingType];
}

- (void)stopTheAudio {
    self.isPlaying = NO;
    [self invalidateTimer];
    [self.audioPlayer stop];
    [self configTheViewWithType:MFYRecorderFinishType];
}

#pragma mark- Timer相关

- (void)recordingAction {
    self.recordTime += 0.1;
    [self updateCirclePercent:self.recordTime / MAX_TIME];
    if (self.recordTime > MAX_TIME) {
        [self updateCirclePercent:1.0];
        self.recordTime = 60.0;
        [self endRecorder];
    }
    self.tipsLabel.text = FORMAT(@"%.1f″",self.recordTime);
}

- (void)playingAction {
    if (!self.isPlaying) {return;}
    self.playTime -= 0.1;
    self.tipsLabel.text = FORMAT(@"%.1f″",self.playTime);
    if (self.playTime < 0) {
        self.playTime = 0;
        self.tipsLabel.text = FORMAT(@"%.1f″",self.playTime);
        [self stopTheAudio];
    }
}

- (void)invalidateTimer {
    [_recordTimer invalidate];
    [_playTimer invalidate];
    _recordTimer = nil;
    _playTimer = nil;
}


#pragma mark - Publics

- (void)updateCirclePercent:(CGFloat)percent {
    self.circleLayer.strokeEnd = percent;
}

#pragma mark - 点击事件

- (void)tapTheCenterImage {
    switch (self.recordType) {
        case MFYRecorderReadyType:
            [WHHud showString:@"请长按或双击开始录制"];
            return;
            break;
        case MFYRecordingType:
            [self endRecorder];
            break;
        case MFYRecorderPlayingType:
            //停止播放
            [self stopTheAudio];
            break;
        case MFYRecorderFinishType:
            //播放录音
            [self playTheAudio];
            break;
        default:
            break;
    }
}

- (void)doubleTapTheCenterImage {
    if (self.recordType == MFYRecorderReadyType) {
        [self startRecorder];
        self.guideLabel.hidden = NO;
    }else{
        [WHHud showString:@"请单击"];
    }
}

- (void)longPressTheCenterImage:(UILongPressGestureRecognizer *)longPress {
    if (longPress.state == UIGestureRecognizerStateBegan && self.recordType == MFYRecorderReadyType) {
          [self startRecorder];
          self.guideLabel.hidden = YES;
      }if (longPress.state == UIGestureRecognizerStateEnded && self.recordType == MFYRecordingType) {
          [self endRecorder];
      }
}

- (void)resetTheAudio {
    [self configTheViewWithType:MFYRecorderReadyType];
    [self invalidateTimer];
    self.audioPath = nil;
}

#pragma mark- 配置不同状态的UI显示
- (void)configTheViewWithType:(MFYRecorderViewType)type {
    self.recordType = type;
    
    self.guideLabel.hidden = type != MFYRecordingType ;
    self.circleBgLayer.hidden = type != MFYRecorderReadyType;
    self.centerView.backgroundColor = type == MFYRecorderReadyType ? wh_colorWithHexString(@"#FF3F70"): wh_colorWithHexString(@"#4D4D4D");
    self.circleLayer.hidden = type != MFYRecordingType;

    switch (type) {
        case MFYRecorderReadyType:
            [self configTheReadyView];
            break;
        case MFYRecordingType:
            [self configTheRecoingView];
            break;
        case MFYRecorderPlayingType:
            [self configThePlayingView];
            break;
        case MFYRecorderFinishType:
            [self configTheFinishView];
            break;

            
        default:
            break;
    }
}

- (void)configTheReadyView {
    self.centerImage.image = nil;
    self.redoBtn.hidden = self.finishBtn.hidden = YES;
    self.tipsLabel.text = @"按住说话 双击录制";
}

- (void)configTheRecoingView {
    self.centerImage.image =  WHImageNamed(@"audio_pb_circle");
    self.redoBtn.hidden = self.finishBtn.hidden = YES;
    self.tipsLabel.text = FORMAT(@"%.1f″",self.recordTime);
}

- (void)configThePlayingView {
    self.centerImage.image = WHImageNamed(@"audio_pb_play");
    self.redoBtn.hidden = self.finishBtn.hidden = NO;
}

- (void)configTheFinishView {
    self.centerImage.image = WHImageNamed(@"audio_pb_stop");
    self.redoBtn.hidden = self.finishBtn.hidden = NO;
    self.tipsLabel.text = FORMAT(@"%.1f″",self.recordTime);
}

#pragma mark- audioPlayDelegate

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    if (flag) {
//        [self stopTheAudio];
    }
}



#pragma mark - Accessors

- (MFYVoiceRecorder *)voiceRecorder {
    if (!_voiceRecorder) {
        _voiceRecorder = [[MFYVoiceRecorder alloc]init];
    }
    return _voiceRecorder;
}


- (CAShapeLayer *)circleLayer {
    if (!_circleLayer) {
        _circleLayer = [CAShapeLayer layer];
        _circleLayer.lineWidth = 3.0;
        _circleLayer.strokeColor = [UIColor wh_colorWithHexString:@"#FF3F70"].CGColor;
        _circleLayer.fillColor = [UIColor clearColor].CGColor;
        
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(circleRadio, circleRadio)
                                                            radius:circleRadio - 3
                                                        startAngle:-M_PI_2
                                                          endAngle:1.5 * M_PI
                                                         clockwise:YES];
        _circleLayer.path = path.CGPath;
        _circleLayer.strokeStart = 0.0;
        _circleLayer.strokeEnd = 0.0;
    }
    return _circleLayer;
}

- (CAShapeLayer *)circleBgLayer {
    if (!_circleBgLayer) {
        _circleBgLayer = [CAShapeLayer layer];
        _circleBgLayer.lineWidth = 5.0;
        _circleBgLayer.strokeColor = _circleBgCorlor.CGColor;
        _circleBgLayer.fillColor = [UIColor clearColor].CGColor;
        
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(circleRadio, circleRadio)
                                                            radius:circleRadio - 8
                                                        startAngle:-M_PI_2
                                                          endAngle:1.5 * M_PI
                                                         clockwise:YES];
        _circleBgLayer.path = path.CGPath;
        _circleBgLayer.strokeStart = 0.0;
        _circleBgLayer.strokeEnd = 1.0;
    }
    return _circleBgLayer;
}

- (UIView *)centerView {
    if (!_centerView) {
        _centerView = [[UIView alloc]init];
    }
    return _centerView;
}

- (UIImageView *)centerImage {
    if (!_centerImage) {
        _centerImage = UIImageView.imageView;
        _centerImage.image = WHImageNamed(@"audio_pb_circle");
        _centerImage.contentMode = UIViewContentModeCenter;
    }
    return _centerImage;
}

- (UILabel *)guideLabel {
    if (!_guideLabel) {
        _guideLabel = UILabel.label;
        _guideLabel.WH_textColor(wh_colorWithHexString(@"#CCCCCC")).WH_textAlignment(NSTextAlignmentCenter).WH_font(WHFont(14));
        _guideLabel.WH_text(@"单击录制完成");
    }
    return _guideLabel;
}

- (UILabel *)tipsLabel {
    if (!_tipsLabel) {
        _tipsLabel = UILabel.label;
        _tipsLabel.WH_font(WHFont(14)).WH_textColor(wh_colorWithHexString(@"#CCCCCC")).WH_textAlignment(NSTextAlignmentCenter);
        _tipsLabel.WH_text(@"按住说话 双击录制");
    }
    return _tipsLabel;
}

- (UIButton *)redoBtn {
    if (!_redoBtn) {
        _redoBtn = UIButton.button;
        [_redoBtn setImage:WHImageNamed(@"audio_pb_redo") forState:UIControlStateNormal];
    }
    return _redoBtn;
}

- (UIButton *)finishBtn {
    if (!_finishBtn) {
        _finishBtn = UIButton.button;
        [_finishBtn setImage:WHImageNamed(@"audio_pb_finish") forState:UIControlStateNormal];
    }
    return _finishBtn;
}


@end
