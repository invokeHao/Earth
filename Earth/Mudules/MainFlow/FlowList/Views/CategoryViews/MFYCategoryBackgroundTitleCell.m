//
//  MFYCategoryBackgroundTitleCell.m
//  Earth
//
//  Created by colr on 2019/12/27.
//  Copyright © 2019 fuYin. All rights reserved.
//

#import "MFYCategoryBackgroundTitleCell.h"
#import "MFYCategoryBackgoundTitleCellModel.h"

@interface MFYCategoryBackgroundTitleCell()

@property (nonatomic, strong) CALayer *bgLayer;

@end

@implementation MFYCategoryBackgroundTitleCell

- (void)initializeViews {
    [super initializeViews];

    self.bgLayer = [CALayer layer];
    [self.contentView.layer insertSublayer:self.bgLayer atIndex:0];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    MFYCategoryBackgoundTitleCellModel *myCellModel = (MFYCategoryBackgoundTitleCellModel *)self.cellModel;
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    CGFloat bgWidth = self.contentView.bounds.size.width;
    if (myCellModel.backgroundWidth != JXCategoryViewAutomaticDimension) {
        bgWidth = myCellModel.backgroundWidth;
    }
    CGFloat bgHeight = self.contentView.bounds.size.height;
    if (myCellModel.backgroundHeight != JXCategoryViewAutomaticDimension) {
        bgHeight = myCellModel.backgroundHeight;
    }
    self.bgLayer.bounds = CGRectMake(0, 0, bgWidth, bgHeight);
    self.bgLayer.position = self.contentView.center;
    [CATransaction commit];
}

- (void)reloadData:(JXCategoryBaseCellModel *)cellModel {
    [super reloadData:cellModel];

    MFYCategoryBackgoundTitleCellModel *myCellModel = (MFYCategoryBackgoundTitleCellModel *)cellModel;
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.bgLayer.borderWidth = myCellModel.borderLineWidth;
    if (myCellModel.isSelected) {
        self.bgLayer.backgroundColor = myCellModel.selectedBackgroundColor.CGColor;
        self.bgLayer.borderColor = myCellModel.selectedBorderColor.CGColor;
    }else {
        self.bgLayer.backgroundColor = myCellModel.normalBackgroundColor.CGColor;
        self.bgLayer.borderColor = myCellModel.normalBorderColor.CGColor;
    }
    switch (myCellModel.MfyCellType) {
        case MFYTittleCellRoundType:
            self.bgLayer.cornerRadius = myCellModel.backgroundCornerRadius;
            break;
        case MFYTittleCellNavLeftType:
            if (@available(iOS 11.0, *)) {
                self.bgLayer.cornerRadius = myCellModel.backgroundCornerRadius;
                self.bgLayer.maskedCorners = kCALayerMinXMinYCorner | kCALayerMinXMaxYCorner;
            } else {
                
            }
            break;
        case MFYTittleCellNavRIghtType:
            if (@available(iOS 11.0, *)) {
                self.bgLayer.cornerRadius = myCellModel.backgroundCornerRadius;
                self.bgLayer.maskedCorners = kCALayerMaxXMinYCorner | kCALayerMaxXMaxYCorner;
            } else {
                
            }
            break;
        default:
            break;
    }
    [CATransaction commit];
}


@end
