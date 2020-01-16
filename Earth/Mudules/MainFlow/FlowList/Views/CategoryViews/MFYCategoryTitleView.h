//
//  MFYCategoryTitleView.h
//  Earth
//
//  Created by colr on 2019/12/26.
//  Copyright © 2019 fuYin. All rights reserved.
//

#import "JXCategoryTitleView.h"

NS_ASSUME_NONNULL_BEGIN

@interface MFYCategoryTitleView : JXCategoryTitleView

@property (nonatomic, strong) UIColor *normalBackgroundColor;
@property (nonatomic, strong) UIColor *normalBorderColor;
@property (nonatomic, strong) UIColor *selectedBackgroundColor;
@property (nonatomic, strong) UIColor *selectedBorderColor;
@property (nonatomic, assign) CGFloat borderLineWidth;
@property (nonatomic, assign) CGFloat backgroundCornerRadius;
@property (nonatomic, assign) CGFloat backgroundWidth;
@property (nonatomic, assign) CGFloat backgroundHeight;

@end

NS_ASSUME_NONNULL_END
