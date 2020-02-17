//
//  MFYAudioPlayCell.m
//  Earth
//
//  Created by colr on 2020/2/16.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import "MFYAudioPlayCell.h"
#import "MFYTagDisplayView.h"
#import "MFYTagDisplayLayout.h"
#import "WHTimeUtil.h"

@interface MFYAudioPlayCell ()

@property (strong, nonatomic)YYAnimatedImageView * headIcon;

@property (strong, nonatomic)UILabel * nameLabel;

@property (strong, nonatomic)YYAnimatedImageView * audioBack;

@property (strong, nonatomic)UILabel * timeLabel;

@property (strong, nonatomic)MFYTagDisplayView * tagView;

@property (strong, nonatomic)UIButton * playBtn;

@property (strong, nonatomic)UIButton * likeBtn;

@property (strong, nonatomic)UILabel * likeLabel;

@property (strong, nonatomic)UIButton * replyBtn;//回复

@property (strong, nonatomic)UILabel * replayLabel;

@property (strong, nonatomic)UIButton * reportBtn;

@property (strong, nonatomic)UIButton * shareBtn;

@end

@implementation MFYAudioPlayCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    [self.contentView addSubview:self.audioBack];
    [self.contentView addSubview:self.headIcon];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.tagView];
    
    [self.audioBack addSubview:self.timeLabel];
    [self.audioBack addSubview:self.playBtn];
    [self.audioBack addSubview:self.likeBtn];
    [self.audioBack addSubview:self.likeLabel];
    [self.audioBack addSubview:self.replyBtn];
    [self.audioBack addSubview:self.replayLabel];
    [self.audioBack addSubview:self.reportBtn];
    [self.audioBack addSubview:self.shareBtn];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.headIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView);
        make.top.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.headIcon);
        make.top.mas_equalTo(self.headIcon.mas_bottom).offset(10);
        make.height.mas_equalTo(17);
    }];
    
    [self.audioBack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(30);
        make.left.right.bottom.mas_equalTo(0);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(16);
        make.left.mas_equalTo(13);
        make.height.mas_equalTo(15);
    }];
    
    [self.tagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(12);
        make.left.mas_equalTo(22);
        make.right.mas_equalTo(-22);
        make.height.mas_equalTo(22);
    }];
    
    [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.audioBack);
        make.size.mas_equalTo(CGSizeMake(W_SCALE(97), W_SCALE(97)));
    }];
    [self.likeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(W_SCALE(48));
        make.bottom.mas_equalTo(H_SCALE(-70));
        make.size.mas_equalTo(CGSizeMake(31, 29));
    }];
    
    [self.likeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.likeBtn);
        make.top.mas_equalTo(self.likeBtn.mas_bottom).offset(12);
        make.height.mas_equalTo(15);
    }];
    
    [self.replyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(W_SCALE(-48));
        make.bottom.mas_equalTo(self.likeBtn);
        make.size.mas_equalTo(CGSizeMake(33, 29));
    }];
    
    [self.replayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.replyBtn);
        make.top.mas_equalTo(self.likeLabel);
        make.height.mas_equalTo(15);
    }];
    
    [self.reportBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(11);
        make.bottom.mas_equalTo(-9);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    [self.shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-11);
        make.bottom.mas_equalTo(self.reportBtn);
        make.size.mas_equalTo(CGSizeMake(19, 20));
    }];
    
    [self layoutIfNeeded];
}

- (void)setModel:(MFYArticle *)model {
    if (model != nil) {
        MFYProfile * profile = model.profile;
        [self.headIcon yy_setImageWithURL:[NSURL URLWithString:profile.headIconUrl] placeholder:WHImageNamed(@"default_user")];
        [self.nameLabel setText:profile.nickname];
        [self.tagView setTags: profile.tags];
        [self.timeLabel setText:[WHTimeUtil articleCardDateStringByTimeStamp:[model.createDate integerValue]]];
    }
}

- (YYAnimatedImageView *)audioBack {
    if (!_audioBack) {
        _audioBack = [[YYAnimatedImageView alloc]init];
        [_audioBack setImage:WHImageNamed(@"audio_back")];
    }
    return _audioBack;
}

- (YYAnimatedImageView *)headIcon {
    if (!_headIcon) {
        _headIcon = [[YYAnimatedImageView alloc]init];
        _headIcon.backgroundColor = wh_colorWithHexString(@"E5E5E5");
        _headIcon.layer.cornerRadius = 30;
        _headIcon.clipsToBounds = YES;
    }
    return _headIcon;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = UILabel.label;
        _nameLabel.WH_textAlignment(NSTextAlignmentCenter).WH_font(WHFont(16)).WH_textColor([UIColor whiteColor]);
    }
    return _nameLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = UILabel.label;
        _timeLabel.WH_font(WHFont(13)).WH_textColor([UIColor whiteColor]);
    }
    return _timeLabel;
}

- (MFYTagDisplayView *)tagView {
    if (!_tagView) {
        MFYTagDisplayLayout *layout = [[MFYTagDisplayLayout alloc] initWthType:AlignWithLeft];
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 12);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _tagView = [[MFYTagDisplayView alloc] initWithFrame:CGRectZero
                                        collectionViewLayout:layout];
        _tagView.backgroundColor = [UIColor clearColor];
        _tagView.bounces = NO;
        @weakify(self);
        [_tagView setShouldUpdateHeight:^(CGFloat width){
            @strongify(self);
            if (width > VERTICAL_SCREEN_WIDTH - 44) {
                width = VERTICAL_SCREEN_WIDTH - 44;
            }
            [self.tagView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(width);
            }];
        }];
    }
    return _tagView;}

- (UIButton *)playBtn {
    if (!_playBtn) {
        _playBtn = UIButton.button;
        _playBtn.WH_setImage_forState(WHImageNamed(@"audio_play"),UIControlStateNormal);
    }
    return _playBtn;
}

- (UIButton *)likeBtn {
    if (!_likeBtn) {
        _likeBtn = UIButton.button;
        _likeBtn.WH_setImage_forState(WHImageNamed(@"audio_dislike"),UIControlStateNormal);
//        _likeBtn.WH_setImage_forState(WHImageNamed(@"audio_like"),UIControlStateNormal);
    }
    return _likeBtn;
}

- (UILabel *)likeLabel {
    if (!_likeLabel) {
        _likeLabel = UILabel.label;
        _likeLabel.WH_font(WHFont(14)).WH_textColor([UIColor whiteColor]).WH_textAlignment(NSTextAlignmentCenter).WH_text(@"喜欢");
    }
    return _likeLabel;
}


- (UIButton *)replyBtn {
    if (!_replyBtn) {
        _replyBtn = UIButton.button;
        _replyBtn.WH_setImage_forState(WHImageNamed(@"audio_reply"),UIControlStateNormal);
    }
    return _replyBtn;
}

- (UILabel *)replayLabel {
    if (!_replayLabel) {
        _replayLabel = UILabel.label;
        _replayLabel.WH_font(WHFont(14)).WH_textColor([UIColor whiteColor]).WH_textAlignment(NSTextAlignmentCenter).WH_text(@"回复");
    }
    return _replayLabel;
}

- (UIButton *)reportBtn {
    if (!_reportBtn) {
        _reportBtn = UIButton.button;
        _reportBtn.WH_setImage_forState(WHImageNamed(@"audio_report"),UIControlStateNormal);
    }
    return _reportBtn;
}

- (UIButton *)shareBtn {
    if (!_shareBtn) {
        _shareBtn = UIButton.button;
        _shareBtn.WH_setImage_forState(WHImageNamed(@"audio_share"),UIControlStateNormal);
    }
    return _shareBtn;
}


@end
