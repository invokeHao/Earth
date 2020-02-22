//
//  MFYAllowSearchView.m
//  Earth
//
//  Created by colr on 2020/2/21.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import "MFYAllowSearchView.h"
#import "MFYSettingService.h"

@interface MFYAllowSearchView()

@property (nonatomic, strong)UILabel * titleLabel;

@property (nonatomic, strong)UISwitch * searchSwith;

@end

@implementation MFYAllowSearchView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
        [self bindEvents];
    }
    return self;
}

- (void)setupViews{
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 8;
    [self addSubview:self.titleLabel];
    [self addSubview:self.searchSwith];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(12);
        make.height.mas_equalTo(18);
    }];
    
    [self.searchSwith mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.right.mas_equalTo(-12);
        make.size.mas_equalTo(CGSizeMake(40, 22));
    }];
}

- (void)bindEvents {
    [[self.searchSwith rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(UISwitch * swith) {
        [self modifyTheAllowSearch:swith.on];
    }];
}

- (void)setSearchOn:(BOOL)on {
    self.searchSwith.on = on;
}

#pragma mark- 网络交互
- (void)modifyTheAllowSearch:(BOOL)allSearch {
    @weakify(self)
    [MFYSettingService postModifyAllowSearch:allSearch Completion:^(BOOL isSuccess, NSError * _Nonnull error) {
        [WHHud showString:@"修改成功"];
        if (self.modifyBlock) {
            self.modifyBlock(allSearch);
        }
    }];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = UILabel.label.WH_font(WHFont(17)).WH_textColor(wh_colorWithHexString(@"#313133"));
        _titleLabel.WH_text(@"允许通过手机号查找我");
    }
    return _titleLabel;
}

- (UISwitch *)searchSwith {
    if (!_searchSwith) {
        _searchSwith = [[UISwitch alloc]init];
    }
    return _searchSwith;
}

@end
