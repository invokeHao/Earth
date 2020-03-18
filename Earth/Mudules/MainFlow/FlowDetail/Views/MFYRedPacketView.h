//
//  MFYRedPacketView.h
//  Earth
//
//  Created by colr on 2020/2/13.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MFYItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface MFYRedPacketView : UIView

@property (nonatomic, strong)MFYItem * item;

+ (void)showInViwe:(UIView *)view itemModel:(MFYItem *)item completion:(void(^)(BOOL isPayed))completion;

@end

NS_ASSUME_NONNULL_END
