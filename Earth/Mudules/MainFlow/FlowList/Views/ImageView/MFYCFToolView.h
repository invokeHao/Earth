//
//  MFYCFToolView.h
//  Earth
//
//  Created by colr on 2019/12/24.
//  Copyright © 2019 fuYin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MFYCFToolView : UIView

@property (nonatomic, strong)UIButton * likeBtn;

@property (nonatomic, strong)UIButton * beforeBtn;

@property (nonatomic, strong)UIButton * dislikeBtn;

@property (nonatomic, strong)UIButton * messageBtn;

@property (nonatomic, strong)UIButton * publicBtn;

@property (nonatomic, strong)void(^tapLikeBlock)(BOOL like);

@property (nonatomic, strong)void(^tapMessageBlock)(BOOL tap);

@end

NS_ASSUME_NONNULL_END
