//
//  MFYCategoryBackgoundTitleCellModel.h
//  Earth
//
//  Created by colr on 2019/12/27.
//  Copyright © 2019 fuYin. All rights reserved.
//

#import "JXCategoryTitleCellModel.h"


typedef NS_ENUM(NSInteger, MFYTittleCellType) {
    MFYTittleCellRoundType = 0,
    MFYTittleCellNavLeftType,
    MFYTittleCellNavRIghtType
};

NS_ASSUME_NONNULL_BEGIN

@interface MFYCategoryBackgoundTitleCellModel : JXCategoryTitleCellModel

@property (nonatomic, strong) UIColor *normalBackgroundColor;
@property (nonatomic, strong) UIColor *normalBorderColor;
@property (nonatomic, strong) UIColor *selectedBackgroundColor;
@property (nonatomic, strong) UIColor *selectedBorderColor;
@property (nonatomic, assign) CGFloat borderLineWidth;
@property (nonatomic, assign) CGFloat backgroundCornerRadius;
@property (nonatomic, assign) CGFloat backgroundWidth;
@property (nonatomic, assign) CGFloat backgroundHeight;

@property (nonatomic, assign) MFYTittleCellType MfyCellType;

@end

NS_ASSUME_NONNULL_END
