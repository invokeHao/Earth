//
//  MFYTagCellCollectionViewCell.m
//  Earth
//
//  Created by colr on 2020/2/16.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import "MFYTagCell.h"

@implementation MFYTagCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    self.contentView.layer.cornerRadius = self.height/2;
    self.contentView.clipsToBounds = YES;
    self.contentView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.contentView.layer.borderWidth = 1;
    [self.contentView addSubview:self.tagLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
        
    [self.tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.contentView);
        make.height.mas_equalTo(16);
    }];
}

- (void)setThemeColor:(UIColor *)themeColor {
    if (themeColor) {
        _themeColor = themeColor;
        self.contentView.layer.borderColor = themeColor.CGColor;
        self.tagLabel.textColor = themeColor;
    }
}

- (UILabel *)tagLabel {
    if (!_tagLabel) {
        _tagLabel = UILabel.label.WH_font(WHFont(15.0)).WH_textColor([UIColor whiteColor]);
    }
    return _tagLabel;
}



@end
