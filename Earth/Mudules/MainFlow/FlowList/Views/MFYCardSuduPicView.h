//
//  MFYCardSuduPicView.h
//  Earth
//
//  Created by colr on 2020/1/6.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MFYCardSuduPicView : UIView

@property (strong, nonatomic)NSMutableArray * imageVArr;

@end


@interface MFYPicItemView : UIView

@property (nonatomic,strong) YYAnimatedImageView * picImageV;

@property (nonatomic, copy) void (^selectedBlock)(NSInteger index);

@property (nonatomic, strong) UIActivityIndicatorView *loadingIndicatorView;



@end


NS_ASSUME_NONNULL_END
