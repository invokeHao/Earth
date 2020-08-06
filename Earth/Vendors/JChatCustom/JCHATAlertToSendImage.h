//
//  JCHATAlertToSendImage.h
//  Earth
//
//  Created by colr on 2020/2/28.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JCHATAlertToSendImage : NSObject

@property(strong, nonatomic)UIView *alertView;
@property(strong, nonatomic)UIImage *preImage;
+ (JCHATAlertToSendImage *)shareInstance;

- (void)showInViewWith:(UIImage *) image;
- (void)removeAlertView;


@end

NS_ASSUME_NONNULL_END
