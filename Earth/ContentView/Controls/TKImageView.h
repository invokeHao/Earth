//
//  TKImageView.h
//  Earth
//
//  Created by colr on 2020/2/20.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, TKCropAreaCornerStyle) {
    TKCropAreaCornerStyleRightAngle,
    TKCropAreaCornerStyleCircle
};

NS_ASSUME_NONNULL_BEGIN

@interface TKImageView : UIView

@property (strong, nonatomic) UIImage *toCropImage;
@property (assign, nonatomic) BOOL needScaleCrop;
@property (assign, nonatomic) BOOL showMidLines;
@property (assign, nonatomic) BOOL showCrossLines;
@property (assign, nonatomic) CGFloat cropAspectRatio;
@property (strong, nonatomic) UIColor *cropAreaBorderLineColor;
@property (assign, nonatomic) CGFloat cropAreaBorderLineWidth;
@property (strong, nonatomic) UIColor *cropAreaCornerLineColor;
@property (assign, nonatomic) CGFloat cropAreaCornerLineWidth;
@property (assign, nonatomic) CGFloat cropAreaCornerWidth;
@property (assign, nonatomic) CGFloat cropAreaCornerHeight;
@property (assign, nonatomic) CGFloat minSpace;
@property (assign, nonatomic) CGFloat cropAreaCrossLineWidth;
@property (strong, nonatomic) UIColor *cropAreaCrossLineColor;
@property (assign, nonatomic) CGFloat cropAreaMidLineWidth;
@property (assign, nonatomic) CGFloat cropAreaMidLineHeight;
@property (strong, nonatomic) UIColor *cropAreaMidLineColor;
@property (strong, nonatomic) UIColor *maskColor;
@property (assign, nonatomic) BOOL cornerBorderInImage;
@property (assign, nonatomic) CGFloat initialScaleFactor;
- (UIImage *)currentCroppedImage;


@end

NS_ASSUME_NONNULL_END
