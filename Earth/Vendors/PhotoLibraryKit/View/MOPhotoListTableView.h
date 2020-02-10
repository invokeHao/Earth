//
//  MOPhotoListTableView.h
//  PhotoLibraryKit
//
//  Created by colr on 2018/6/7.
//  Copyright © 2018年 colr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import "MOAlbumModel.h"

@class MOPhotoListTableView;

@protocol PhotoListTableViewDelegate <NSObject>

- (void)photoListTableView:(MOPhotoListTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface MOPhotoListTableView : UITableView

@property (nonatomic, weak) id<PhotoListTableViewDelegate> photoListDalagate;
@property (nonatomic, copy, readonly) NSArray<MOAlbumModel *> *dataList;

- (void)loadData:(NSArray<MOAlbumModel *> *)dataList;

@end
