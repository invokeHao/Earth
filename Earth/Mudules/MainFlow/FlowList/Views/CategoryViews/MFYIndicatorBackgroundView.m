//
//  MFYIndicatorBackgroundView.m
//  Earth
//
//  Created by colr on 2019/12/26.
//  Copyright © 2019 fuYin. All rights reserved.
//

#import "MFYIndicatorBackgroundView.h"

@implementation MFYIndicatorBackgroundView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.scrollAnimationDuration = 0.5;
        [self setupView];
    }
    return self;
}

- (void)setupView {
    self.indicatorColor = wh_colorWithHexString(@"#FF3F70");
    self.indicatorWidth = 54;
    self.indicatorHeight = 30;
}

- (void)jx_selectedCell:(JXCategoryIndicatorParamsModel *)model {
    CGFloat width = [self indicatorWidthValue:model.selectedCellFrame];
    CGFloat height = [self indicatorHeightValue:model.selectedCellFrame];
    CGFloat x = model.selectedCellFrame.origin.x + (model.selectedCellFrame.size.width - width)/2;
    CGFloat y = (model.selectedCellFrame.size.height - height)/2;
    CGRect toFrame = CGRectMake(x, y, width, height);

    if (self.isScrollEnabled) {
        [UIView animateWithDuration:self.scrollAnimationDuration delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.frame = toFrame;
        } completion:nil];
    }else {
        self.frame = toFrame;
    }
}

@end
