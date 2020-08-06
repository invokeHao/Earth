//
//  MOPhotoListCell.h
//  PhotoLibraryKit
//
//  Created by colr on 2018/6/7.
//  Copyright © 2018年 colr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MOAlbumModel.h"

@interface MOPhotoListCell : UITableViewCell

- (void)loadData:(MOAlbumModel *)albumModel;

@end
