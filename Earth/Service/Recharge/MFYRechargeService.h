//
//  MFYRechargeService.h
//  Earth
//
//  Created by colr on 2020/3/16.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MFYWXOrderModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, MFYPayType) {
    MFYPayTypeAliPay = 1,
    MFYPayTypeWXPay ,
};

@interface MFYRechargeService : NSObject

#pragma mark- 购买重看次数
+ (void)rereadRecharge:(NSString *)productId
               PayType:(MFYPayType)payType
            Completion:(void(^)(MFYWXOrderModel *orderModel, NSError * error))completion;

#pragma mark- 购买收费卡片
+ (void)purchaseCard:(NSString *)articleId
             PayType:(MFYPayType)payType
          Completion:(void(^)(MFYWXOrderModel *orderModel, NSError * error))completion;

#pragma mark- 查询充值状态
+ (void)getTheRechargeOrderStatus:(NSString *)orderId Completion:(void(^)(MFYWXOrderModel *orderModel, NSError * error))completion;

@end

NS_ASSUME_NONNULL_END
