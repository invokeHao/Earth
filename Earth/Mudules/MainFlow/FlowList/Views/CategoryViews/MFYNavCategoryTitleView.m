//
//  MFYNavCategoryTitleView.m
//  Earth
//
//  Created by colr on 2020/2/16.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import "MFYNavCategoryTitleView.h"
#import "MFYCategoryBackgroundTitleCell.h"
#import "MFYCategoryBackgoundTitleCellModel.h"

@implementation MFYNavCategoryTitleView

- (void)initializeData {
    [super initializeData];
    
    self.normalBackgroundColor = wh_colorWithHexString(@"#DD445B");
    self.normalBorderColor = [UIColor clearColor];
    self.selectedBackgroundColor = wh_colorWithHexString(@"#FC7487");
    self.selectedBorderColor = [UIColor clearColor];
    self.borderLineWidth = 0;
    self.backgroundCornerRadius = 14;
    self.titleColor = wh_colorWithHexString(@"#FD94AF");
    self.titleSelectedColor = wh_colorWithHexString(@"ffffff");
    self.backgroundWidth = 75;
    self.backgroundHeight = 28;
    self.titleFont = WHFont(17);
    self.cellWidthIncrement = 0;
    self.cellSpacing = 0;
}

//返回自定义的cell class
- (Class)preferredCellClass {
    return [MFYCategoryBackgroundTitleCell class];
}

- (void)refreshDataSource {
    NSMutableArray *tempArray = [NSMutableArray array];
    for (int i = 0; i < self.titles.count; i++) {
        MFYCategoryBackgoundTitleCellModel *cellModel = [[MFYCategoryBackgoundTitleCellModel alloc] init];
        if (i == 0) {
            cellModel.MfyCellType = MFYTittleCellNavLeftType;
        }else {
            cellModel.MfyCellType = MFYTittleCellNavRIghtType;
        }
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
