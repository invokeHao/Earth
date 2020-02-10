//
//  MFYBaseTableViewCell.h
//  Earth
//
//  Created by colr on 2020/1/21.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MFYBaseTableView.h"

NS_ASSUME_NONNULL_BEGIN

@interface MFYBaseTableViewCell : UITableViewCell

@property (strong, nonatomic) id element;

- (void)setupViews;

+ (CGFloat)cellHeightWithModel:(id)element args:(NSDictionary *)args;

+ (NSString *)reuseID;

+ (MFYBaseTableViewCell *)mfy_cellWithTableView:(MFYBaseTableView *)tableView;


@end

NS_ASSUME_NONNULL_END
