//
//  MFYProfessView.h
//  Earth
//
//  Created by colr on 2020/4/10.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MFYArticle.h"

NS_ASSUME_NONNULL_BEGIN

@interface MFYProfessView : UIView

@property (nonatomic, strong)MFYArticle * article;

@property (nonatomic, assign)CGFloat price;

+ (void)showTheProfessView:(MFYArticle *)article Price:(CGFloat)price Completion:(void (^)(BOOL success))completion;

@end

NS_ASSUME_NONNULL_END
