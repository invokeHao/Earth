//
//  JCHATShowTimeCell.h
//  Earth
//
//  Created by colr on 2020/3/2.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JCHATChatModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JCHATShowTimeCell : UITableViewCell

@property (strong, nonatomic) UILabel *messageTimeLabel;
@property (strong, nonatomic)  JCHATChatModel *model;

- (void)setCellData :(JCHATChatModel *)model;

@end

NS_ASSUME_NONNULL_END
