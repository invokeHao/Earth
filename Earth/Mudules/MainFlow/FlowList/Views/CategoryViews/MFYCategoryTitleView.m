//
//  MFYCategoryTitleView.m
//  Earth
//
//  Created by colr on 2019/12/26.
//  Copyright © 2019 fuYin. All rights reserved.
//

#import "MFYCategoryTitleView.h"
#import "MFYCategoryBackgoundTitleCellModel.h"
#import "MFYCategoryBackgroundTitleCell.h"

@implementation MFYCategoryTitleView

- (void)initializeData {
    [super initializeData];

    self.cellWidthIncrement = 22;
    self.normalBackgroundColor = [UIColor whiteColor];
    self.normalBorderColor = wh_colorWithHexString(@"#FD94AF");
    self.selectedBackgroundColor = [UIColor clearColor];
    self.selectedBorderColor = [UIColor clearColor];
    self.borderLineWidth = 0.5;
    self.backgroundCornerRadius = 13;
    self.titleColor = wh_colorWithHexString(@"#FD94AF");
    self.titleSelectedColor = wh_colorWithHexString(@"ffffff");
    self.backgroundWidth = JXCategoryViewAutomaticDimension;
    self.backgroundHeight = 26;
}

//返回自定义的cell class
- (Class)preferredCellClass {
    return [MFYCategoryBackgroundTitleCell class];
}

- (void)refreshDataSource {
    NSMutableArray *tempArray = [NSMutableArray array];
    for (int i = 0; i < self.titles.count; i++) {
        MFYCategoryBackgoundTitleCellModel *cellModel = [[MFYCategoryBackgoundTitleCellModel alloc] init];
        [tempArray addObject:cellModel];
    }
    self.dataSource = tempArray;
}

- (void)refreshCellModel:(MFYCategoryBackgoundTitleCellModel *)cellModel index:(NSInteger)index {
    [super refreshCellModel:cellModel index:index];

    MFYCategoryBackgoundTitleCellModel *myModel = (MFYCategoryBackgoundTitleCellModel *)cellModel;
    myModel.normalBackgroundColor = self.normalBackgroundColor;
    myModel.normalBorderColor = self.normalBorderColor;
    myModel.selectedBackgroundColor = self.selectedBackgroundColor;
    myModel.selectedBorderColor = self.selectedBorderColor;
    myModel.borderLineWidth = self.borderLineWidth;
    myModel.backgroundCornerRadius = self.backgroundCornerRadius;
    myModel.backgroundWidth = self.backgroundWidth;
    myModel.backgroundHeight = self.backgroundHeight;
}


@end
