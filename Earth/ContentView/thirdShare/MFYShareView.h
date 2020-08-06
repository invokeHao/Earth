//
//  MFYShareView.h
//  Earth
//
//  Created by colr on 2020/3/17.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MFYArticle.h"

NS_ASSUME_NONNULL_BEGIN

@interface MFYShareView : UIView

+ (void)showInViewWithArticle:(MFYArticle *)article;

@end

NS_ASSUME_NONNULL_END
