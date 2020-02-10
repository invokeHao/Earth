//
//  MOPhotoListTableView.m
//  PhotoLibraryKit
//
//  Created by colr on 2018/6/7.
//  Copyright © 2018年 colr. All rights reserved.
//

#import "MOPhotoListTableView.h"
#import "MOPhotoListCell.h"

@interface MOPhotoListTableView () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation MOPhotoListTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self setupUI];
    }
    return self;
}

-(void)setupUI {
    self.rowHeight = 70;
    self.backgroundColor = [UIColor wh_colorWithHexString:@"0x1B1A28"];
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableFooterView = [UIView new];
    self.delegate = self;
    self.dataSource = self;
    [self registerClass:[MOPhotoListCell class] forCellReuseIdentifier:NSStringFromClass([MOPhotoListCell class])];
}

- (void)loadData:(NSArray<MOAlbumModel *> *)dataList {
    self.dataList = dataList;
}

#pragma mark - getting and settting

- (void)setDataList:(NSArray *)dataList {
    _dataList = dataList;
    [self reloadData];
}


#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MOAlbumModel *collection = self.dataList[indexPath.row];
    MOPhotoListCell *cell = [tableView
                           dequeueReusableCellWithIdentifier:NSStringFromClass([MOPhotoListCell class]) forIndexPath:indexPath];
    [cell loadData:collection];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.photoListDalagate && [self.photoListDalagate respondsToSelector:@selector(photoListTableView:didSelectRowAtIndexPath:)]) {
        [self.photoListDalagate photoListTableView:self didSelectRowAtIndexPath:indexPath];
    }
}



@end






