//
//  MFYAudioPublishView.h
//  Earth
//
//  Created by colr on 2020/2/17.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MFYAudioPublishView : UIView

#pragma mark- 发语音贴
- (void)showInView;

#pragma mark- 表白
+ (void)professToSB:(MFYArticle *)article;

@end

NS_ASSUME_NONNULL_END
