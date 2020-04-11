//
//  MFYRechargeManager.h
//  Earth
//
//  Created by colr on 2020/3/16.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MFYRechargeService.h"

NS_ASSUME_NONNULL_BEGIN

@interface MFYRechargeManager : NSObject<WXApiDelegate>

@property (nonatomic, strong)MFYWXOrderModel * model;

@property (nonatomic, strong)void(^payResBlock)(BOOL success);

+ (instancetype)sharedManager;

+ (void)rereadWithWXPay:(NSString *)productId completion:(void(^)(BOOL issuccess))completion;

+ (void)purchaseTheCard:(NSString *)articleId completion:(void(^)(BOOL issuccess))completion;

+ (void)professWXRechargeCompletion:(void (^)(BOOL issuccess))completion;

- (BOOL)WXHandleUrl:(NSURL *)url;

- (BOOL)WXhandleOpenUniversalLink:(NSUserActivity*)userActivity;

@end

NS_ASSUME_NONNULL_END
