//
//  MFYBaseTableViewCell.m
//  Earth
//
//  Created by colr on 2020/1/21.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import "MFYBaseTableViewCell.h"

@implementation MFYBaseTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupViews];
    }
    return self;
}


- (void)setupViews {
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
}

+ (MFYBaseTableViewCell *)mfy_cellWithTableView:(MFYBaseTableView *)tableView {
    NSAssert(NO, @"重写me");
    MFYBaseTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:[MFYBaseTableViewCell reuseID]];
    if (!cell) {
        cell = [[MFYBaseTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[MFYBaseTableViewCell reuseID]];
    }
    return cell;
}


+ (CGFloat)cellHeightWithModel:(id)element args:(NSDictionary *)args {
    NSAssert(NO, @"重写me");
    return 44;
}

+ (NSString *)reuseID {
    return NSStringFromClass([self class]);
}

@end
