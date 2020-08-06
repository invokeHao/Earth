//
//  MFYChatMoreView.m
//  Earth
//
//  Created by colr on 2020/3/4.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import "MFYChatMoreView.h"

@implementation MFYChatMoreView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
        [self bindEvents];
    }
    return self;
}

- (void)setupViews {
    self.backgroundColor = wh_colorWithHexString(@"#F7F8FC");
    [self addSubview:self.recorderView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.recorderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(40);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(150);
    }];
}

- (void)bindEvents {
    @weakify(self)
    [self.recorderView setSendChatB:^(NSString * _Nullable audioPath, NSString * _Nullable audioDuration) {
        @strongify(self)
        if (self.delegate && [self.delegate respondsToSelector:@selector(finishRecoderAudioPath: audioDuration:)]) {
            [self.delegate finishRecoderAudioPath:audioPath audioDuration:audioDuration];
        }
    }];
}

- (MFYRecorderView *)recorderView {
    if (!_recorderView) {
        _recorderView = [[MFYRecorderView alloc]initWithFrame:CGRectZero displayType:MFYRecoderDisplayTypeChat];
    }
    return _recorderView;
}




@end
