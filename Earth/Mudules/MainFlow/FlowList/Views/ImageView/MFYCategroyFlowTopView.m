//
//  MFYCategroyFlowTopView.m
//  Earth
//
//  Created by colr on 2020/3/21.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import "MFYCategroyFlowTopView.h"

@interface MFYCategroyFlowTopView()

@property (nonatomic, strong)UILabel * topLabel;

@property (nonatomic, strong)UILabel * tipsLabel;

@end

@implementation MFYCategroyFlowTopView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    self.backgroundColor = UIColor.clearColor;
    [self addSubview:self.topLabel];
    [self addSubview:self.tipsLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(16);
    }];
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.topLabel.mas_bottom).offset(9);
        make.left.right.mas_equalTo(self.topLabel);
        make.height.mas_equalTo(14);
    }];
}

- (void)setFlowTag:(MFYCoreflowTag *)flowTag {
    if (flowTag) {
        _flowTag = flowTag;
        self.topLabel.text = FORMAT(@"%ld人喜欢【%@】",flowTag.count,flowTag.value);
        self.tipsLabel.WH_text(FORMAT(@"发布动态，寻找喜欢%@的朋友",flowTag.value));
    }
}

- (UILabel *)topLabel {
    if (!_topLabel) {
        _topLabel = UILabel.label.WH_textColor(wh_colorWithHexString(@"#FD5F87"));
        _topLabel.WH_textAlignment(NSTextAlignmentCenter);
        _tipsLabel.font = [UIFont boldSystemFontOfSize:15];
    }
    return _topLabel;
}

- (UILabel *)tipsLabel {
    if (!_tipsLabel) {
        _tipsLabel = UILabel.label.WH_textColor(wh_colorWithHexString(@"#FD94AF"));
        _tipsLabel.WH_textAlignment(NSTextAlignmentCenter).WH_font(WHFont(13));
        
    }
    return _tipsLabel;
}

@end
