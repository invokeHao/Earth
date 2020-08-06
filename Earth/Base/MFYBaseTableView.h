//
//  MFYBaseTableView.h
//  Earth
//
//  Created by colr on 2020/1/21.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^EmptyDataSetTappedBlock)(void);

@interface MFYBaseTableView : UITableView

@property (nonatomic, strong) MJRefreshComponentRefreshingBlock headerRefreshingBlock;
@property (nonatomic, copy) MJRefreshComponentRefreshingBlock footerRefreshingBlock;
@property (nonatomic, copy) EmptyDataSetTappedBlock emptyDataSetTappedBlock;

@end

NS_ASSUME_NONNULL_END
