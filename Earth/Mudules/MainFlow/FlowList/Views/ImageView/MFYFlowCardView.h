//
//  MFYFlowCardView.h
//  Earth
//
//  Created by colr on 2019/12/27.
//  Copyright © 2019 fuYin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MFYCardSuduPicView.h"
#import "MFYArticle.h"

NS_ASSUME_NONNULL_BEGIN

@interface MFYFlowCardView : UIView

@property (nonatomic, strong) MFYCardSuduPicView * suduView;

@property (nonatomic, strong) UILabel * titleLabel;

@property (nonatomic, strong) UIImageView * likeIcon;

@property (nonatomic, strong) UIImageView * dislikeIcon;

@property (nonatomic, strong) MFYArticle * model;

- (void)mfy_stopPlay;

- (void)mfy_startPlay;

@end

NS_ASSUME_NONNULL_END
