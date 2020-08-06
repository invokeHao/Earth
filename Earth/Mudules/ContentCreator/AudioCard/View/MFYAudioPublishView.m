//
//  MFYAudioPublishView.m
//  Earth
//
//  Created by colr on 2020/2/17.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import "MFYAudioPublishView.h"
#import "MFYRecorderView.h"
#import "JCHATSendMsgManager.h"
#import "MFYChatService.h"

@interface MFYAudioPublishView()

@property (nonatomic, strong)UIView * disPlayView;
@property (nonatomic, strong)UILabel * titleLabel;
@property (nonatomic, strong)MFYRecorderView * recordView;
@property (nonatomic, strong)MFYArticle * article;

@property (nonatomic, assign) CGRect oldFrame;


@end

@implementation MFYAudioPublishView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
        [self bindEvents];
    }
    return self;
}

- (void)setupViews {
    _oldFrame = CGRectMake(0,VERTICAL_SCREEN_HEIGHT,VERTICAL_SCREEN_WIDTH,280 + HOME_INDICATOR_HEIGHT);
    [self addSubview:self.disPlayView];
    [self.disPlayView addSubview:self.titleLabel];
    [self.disPlayView addSubview:self.recordView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.centerX.mas_equalTo(self.disPlayView);
        make.height.mas_equalTo(18);
    }];
    
    [self.recordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(60);
        make.left.right.bottom.mas_equalTo(0);
    }];
    
}

- (void)bindEvents {
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] init];
    @weakify(self)
    [[tap rac_gestureSignal] subscribeNext:^(UITapGestureRecognizer * tap) {
        @strongify(self)
        CGFloat tapY = [tap locationInView:self].y;
        if (tapY < self.disPlayView.origin.y ) {
            [self dismiss];
        }
    }];
    [self addGestureRecognizer:tap];
    
    [self.recordView setPublishB:^(BOOL isSuccess) {
        if (isSuccess) {
            @strongify(self)
            [self dismiss];
            [[NSNotificationCenter defaultCenter] postNotificationName:MFYNotificationPublishAudioSuccess object:nil];
        }
    }];

}

- (void)showInView{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
     [UIView animateWithDuration:0.2 animations:^{
         self.backgroundColor = wh_colorWithHexAndAlpha(@"000000", 0.5);
         self.disPlayView.frame = CGRectMake(0,
                                        self.oldFrame.origin.y - self.oldFrame.size.height,
                                        self.oldFrame.size.width,
                                        self.oldFrame.size.height);
         
     }];
    
    [self.recordView updateCirclePercent:0];
}

+ (void)professToSB:(MFYArticle *)article{
    MFYAudioPublishView * publishView = [[MFYAudioPublishView alloc]initWithFrame:CGRectMake(0, 0, VERTICAL_SCREEN_WIDTH, VERTICAL_SCREEN_HEIGHT)];;
    publishView.article = article;
    @weakify(publishView)
    publishView.recordView.sendChatB = ^(NSString *audioPath, NSString *audioDuration) {
        [WHHud showActivityView];
        [JMSGConversation createSingleConversationWithUsername:article.profile.imId completionHandler:^(id resultObject, NSError *error) {
            if (!error) {
                JMSGConversation * conversation = resultObject;
                [JCHATSendMsgManager sendMessageWithVoice:audioPath voiceDuration:audioDuration withConversation:conversation];
                [MFYChatService postProfessSB:article.profile.userId Completion:^(BOOL isSuccess, NSError * _Nonnull error) {
                    [WHHud hideActivityView];
                    @strongify(publishView)
                    if (isSuccess) {
                        [WHHud showString:@"表白成功"];
                        [JMSGConversation deleteSingleConversationWithUsername:article.profile.imId];
                    }else{
                        [WHHud showString:error.descriptionFromServer];
                    }
                    [publishView dismiss];
                }];
            }else {
                [WHHud hideActivityView];
                [WHHud showString:@"表白失败"];
            }
        }];
    };
    [publishView showInView];
}

- (void)dismiss {
    [UIView animateWithDuration:0.2 animations:^{
        self.backgroundColor = [UIColor clearColor];
        self.disPlayView.frame = self.oldFrame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


- (UIView *)disPlayView {
    if (!_disPlayView) {
        _disPlayView = [[UIView alloc]initWithFrame:_oldFrame];
        _disPlayView.backgroundColor = wh_colorWithHexAndAlpha(@"000000", 0.8);
        _disPlayView.tag = 1001;
    }
    return _disPlayView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = UILabel.label;
        _titleLabel.WH_font(WHFont(17)).WH_textColor(wh_colorWithHexString(@"666666")).WH_textAlignment(NSTextAlignmentCenter);
        _titleLabel.WH_text(@"用你的声音交朋友");
    }
    return _titleLabel;
}

- (MFYRecorderView *)recordView {
    if (!_recordView) {
        _recordView = [[MFYRecorderView alloc] initWithFrame:CGRectZero displayType:MFYRecoderDisplayTypeAudioFlow];
    }
    return _recordView;
}

@end
