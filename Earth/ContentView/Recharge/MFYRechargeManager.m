//
//  MFYRechargeManager.m
//  Earth
//
//  Created by colr on 2020/3/16.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import "MFYRechargeManager.h"

@implementation MFYRechargeManager

+ (instancetype)sharedManager {
    static MFYRechargeManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[MFYRechargeManager alloc] init];
    });
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self configTheWX];
    }
    return self;
}

+ (void)rereadWithWXPay:(NSString *)productId completion:(void (^)(BOOL))completion {
    MFYRechargeManager * manager = [MFYRechargeManager sharedManager];
    [MFYRechargeService rereadRecharge:productId PayType:MFYPayTypeWXPay Completion:^(MFYWXOrderModel * _Nonnull orderModel, NSError * _Nonnull error) {
        if (!error) {
            manager.model = orderModel;
            manager.payResBlock = completion;
            [manager payTheOrder:orderModel];
        }
    }];
}

+ (void)purchaseTheCard:(NSString *)articleId completion:(void (^)(BOOL))completion {
    MFYRechargeManager * manager = [MFYRechargeManager sharedManager];
    [MFYRechargeService purchaseCard:articleId PayType:MFYPayTypeWXPay Completion:^(MFYWXOrderModel * _Nonnull orderModel, NSError * _Nonnull error) {
        if (!error) {
            manager.model = orderModel;
            manager.payResBlock = completion;
            [manager payTheOrder:orderModel];
        }else{
            WHLog(@"%@",[error descriptionFromServer]);
        }
    }];
}

+ (void)professWXRechargeCompletion:(void (^)(BOOL))completion {
    MFYRechargeManager * manager = [MFYRechargeManager sharedManager];
    [MFYRechargeService professRechargePayType:MFYPayTypeWXPay Completion:^(MFYWXOrderModel * _Nonnull model, NSError * _Nonnull error) {
        if (!error) {
            manager.model = model;
            manager.payResBlock = completion;
            [manager payTheOrder:model];
        }else {
            WHLog(@"%@",[error descriptionFromServer]);
        }
    }];
}

- (void)payTheOrder:(MFYWXOrderModel *)model {
    PayReq *request = [[PayReq alloc] init];
    request.partnerId = model.wxPayPartnerId;
    request.prepayId= model.wxPayPrepayId;
    request.package = model.wxPayPackage;
    request.nonceStr= model.wxPayNonceStr;
    request.timeStamp= [model.wxPayTimestamp intValue];
    request.sign= model.wxPaySign;
    [WXApi sendReq:request completion:^(BOOL success) {
        if (success) {
            WHLog(@"调起成功");
        }
    }];
}

- (void)onResp:(BaseResp *)resp {
    if ([resp isKindOfClass:[PayResp class]]){
         PayResp*response=(PayResp*)resp;
         switch(response.errCode){
             case WXSuccess:{
                //服务器端查询支付通知或查询API返回的结果再提示成功
                 WHLog(@"%@",self.model.orderId);
                 @weakify(self)
                 [MFYRechargeService getTheRechargeOrderStatus:self.model.orderId Completion:^(MFYWXOrderModel * _Nonnull orderModel, NSError * _Nonnull error) {
                     @strongify(self)
                     if (orderModel) {
                         if (self.payResBlock) {
                             self.payResBlock(YES);
                         }
                     }
                 }];}
               break;
             default:
                 self.payResBlock(NO);
                 WHLogError(@"支付失败，retcode=%d",resp.errCode);
               break;
         }
    }
}

- (void)configTheWX {
    [WXApi registerApp:MFYWeChatAppKey universalLink:MFYUniversalLink];
}

- (BOOL)WXHandleUrl:(NSURL *)url {
    BOOL result = NO;
    result = [WXApi handleOpenURL:url delegate:self];
    return result;
}

- (BOOL)WXhandleOpenUniversalLink:(NSUserActivity*)userActivity {
    BOOL result = NO;
    result = [WXApi handleOpenUniversalLink:userActivity delegate:self];
    return result;
}

@end
