//
//  MFYBaseCollectionView.m
//  Earth
//
//  Created by colr on 2020/3/19.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import "MFYBaseCollectionView.h"

@implementation MFYBaseCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
    }
    return self;
}

- (void)setFooterRefreshingBlock:(MJRefreshComponentRefreshingBlock)footerRefreshingBlock {
    _footerRefreshingBlock = footerRefreshingBlock;
    MJRefreshAutoStateFooter *footer = [MJRefreshAutoStateFooter footerWithRefreshingBlock:footerRefreshingBlock];
    //根据业务需求，全部去掉
    footer.stateLabel.hidden = YES;
    self.mj_footer = footer;
}

- (void)setFooterRefreshingWithoutTitleBlock:(MJRefreshComponentRefreshingBlock)FooterRefreshingWithoutTitleBlock{
    _FooterRefreshingWithoutTitleBlock = FooterRefreshingWithoutTitleBlock;
    MJRefreshAutoNormalFooter * footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:FooterRefreshingWithoutTitleBlock];
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
