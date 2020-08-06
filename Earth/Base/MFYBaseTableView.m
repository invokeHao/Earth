//
//  MFYBaseTableView.m
//  Earth
//
//  Created by colr on 2020/1/21.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import "MFYBaseTableView.h"

@implementation MFYBaseTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame:frame style:style]) {
        self.estimatedRowHeight = 0;
        self.estimatedSectionHeaderHeight = 0;
        self.estimatedSectionFooterHeight = 0;
    }
    return self;
}

- (void)setFooterRefreshingBlock:(MJRefreshComponentRefreshingBlock)footerRefreshingBlock {
    _footerRefreshingBlock = footerRefreshingBlock;
    MJRefreshAutoStateFooter *footer = [MJRefreshAutoStateFooter footerWithRefreshingBlock:footerRefreshingBlock];
    footer.stateLabel.textColor = wh_colorWithHexString(@"333333");
    footer.stateLabel.hidden = YES;
    self.mj_footer = footer;
}

- (void)setHeaderRefreshingBlock:(MJRefreshComponentRefreshingBlock)headerRefreshingBlock {
    _headerRefreshingBlock = headerRefreshingBlock;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:headerRefreshingBlock];
    header.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    header.stateLabel.hidden = YES;
    header.lastUpdatedTimeLabel.hidden = YES;
    self.mj_header= header;
}


@end
