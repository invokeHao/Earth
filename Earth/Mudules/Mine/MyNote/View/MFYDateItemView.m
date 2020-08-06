//
//  MFYDateItemView.m
//  Earth
//
//  Created by colr on 2020/2/24.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import "MFYDateItemView.h"
#import "WHTimeUtil.h"

#define circleRadio 27

@interface MFYDateItemView ()

@property (nonatomic, strong)UILabel * topLabel;

@property (nonatomic, strong)UILabel * bottomLabel;

@property (nonatomic, strong)CAShapeLayer *circleLayer;

@property (nonatomic, strong)CAShapeLayer *circleBgLayer;

@end

@implementation MFYDateItemView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    [self.contentView.layer addSublayer:self.circleBgLayer];
    [self.contentView.layer addSublayer:self.circleLayer];
    [self.contentView addSubview:self.topLabel];
    [self.contentView addSubview:self.bottomLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(15);
    }];
    
    [self.bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-10);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(14);
    }];
}

- (void)setCreateDate:(NSString *)createDate {
    if (createDate) {
        self.topLabel.text = [WHTimeUtil getHourDateByTimeStamp:[createDate integerValue]];
        self.bottomLabel.text = [WHTimeUtil getMonthAndDayByTimeStamp:[createDate integerValue]];
    }
}


- (void)itemDidSelected {
    self.circleBgLayer.fillColor = wh_colorWithHexString(@"#FF3F70").CGColor;
    self.topLabel.textColor = wh_colorWithHexString(@"FFFFFF");
    self.bottomLabel.textColor = wh_colorWithHexString(@"FFFFFF");
    self.circleLayer.hidden = YES;
}

- (void)itemCancelSelected {
    self.circleBgLayer.fillColor = wh_colorWithHexString(@"#FFFFFF").CGColor;
    self.topLabel.textColor = wh_colorWithHexString(@"939399");
    self.bottomLabel.textColor = wh_colorWithHexString(@"ABACB3");
    self.circleLayer.hidden = NO;
}

- (CAShapeLayer *)circleLayer {
    if (!_circleLayer) {
        _circleLayer = [CAShapeLayer layer];
        _circleLayer.lineWidth = 1.0;
        NSArray * lengths = @[@(3), @(1)];
        _circleLayer.lineDashPattern = lengths;
        _circleLayer.strokeColor = [UIColor wh_colorWithHexString:@"#DCDCE6"].CGColor;
        _circleLayer.fillColor = [UIColor clearColor].CGColor;
        
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(circleRadio, circleRadio)
                                                            radius:circleRadio - 1
                                                        startAngle:-M_PI_2
                                                          endAngle:1.5 * M_PI
                                                         clockwise:YES];

        _circleLayer.path = path.CGPath;
        _circleLayer.strokeStart = 0.0;
        _circleLayer.strokeEnd = 1.0;
    }
    return _circleLayer;
}

- (CAShapeLayer *)circleBgLayer {
    if (!_circleBgLayer) {
        _circleBgLayer = [CAShapeLayer layer];
        _circleBgLayer.lineWidth = 1;
        _circleBgLayer.strokeColor = [UIColor clearColor].CGColor;
        _circleBgLayer.fillColor = wh_colorWithHexString(@"#FFFFFF").CGColor;
        
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(circleRadio, circleRadio)
                                                            radius:circleRadio
                                                        startAngle:-M_PI_2
                                                          endAngle:1.5 * M_PI
                                                         clockwise:YES];
        _circleBgLayer.path = path.CGPath;
        _circleBgLayer.strokeStart = 0.0;
        _circleBgLayer.strokeEnd = 1.0;
    }
    return _circleBgLayer;
}


- (UILabel *)topLabel {
    if (!_topLabel) {
        _topLabel = UILabel.label.WH_font(WHFont(14)).WH_textColor(wh_colorWithHexString(@"#939399"));
        _topLabel.WH_textAlignment(NSTextAlignmentCenter);
    }
    return _topLabel;
}

-(UILabel *)bottomLabel {
    if (!_bottomLabel) {
        _bottomLabel = UILabel.label.WH_font(WHFont(13)).WH_textColor(wh_colorWithHexString(@"#ABACB3"));
        _bottomLabel.WH_textAlignment(NSTextAlignmentCenter);
    }
    return _bottomLabel;
}

@end
