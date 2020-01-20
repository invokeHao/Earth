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

@property (nonatomic, strong) MFYArticle * model;

@end

NS_ASSUME_NONNULL_END
