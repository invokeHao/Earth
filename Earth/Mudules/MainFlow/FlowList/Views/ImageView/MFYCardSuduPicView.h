//
//  MFYCardSuduPicView.h
//  Earth
//
//  Created by colr on 2020/1/6.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MFYArticle.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, MFYPicItemType) {
    MFYPicItemBigType = 0,
    MFYPicItemSmallTopType,
    MFYPicItemSmallBottomType
};

@interface MFYPicItemView : UIView

@property (nonatomic,strong) UIImageView * mosaciView;

@property (nonatomic,strong) YYAnimatedImageView * picImageV;

@property (nonatomic, copy) void (^selectedBlock)(NSInteger index);

@property (nonatomic, strong) UIActivityIndicatorView *loadingIndicatorView;

@property (nonatomic, strong)MFYItem * itemModel;

@property (nonatomic, assign)MFYPicItemType itemType;

@property (strong, nonatomic)NSURL * playUrl;


- (instancetype)initWithItemType:(MFYPicItemType)itemType;

- (MFYItem * )itemModel;

- (void)startPlayTheVideo;

- (void)pauseTheVideo;

- (void)stopTheVideo;

- (void)resetVideo;

@end


@interface MFYCardSuduPicView : UIView

@property (strong, nonatomic)NSMutableArray * imageVArr;

@property (strong, nonatomic)MFYArticle * article;

@property (strong, nonatomic)MFYPicItemView * bigItem;

@property (strong, nonatomic)MFYPicItemView * smallTopItem;

@property (strong, nonatomic)MFYPicItemView * smallBottomItem;

- (void)stopPlay;

- (void)startPlay;

@end




NS_ASSUME_NONNULL_END
