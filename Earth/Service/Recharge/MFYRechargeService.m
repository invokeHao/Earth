//
//  MFYRechargeService.m
//  Earth
//
//  Created by colr on 2020/3/16.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import "MFYRechargeService.h"

@implementation MFYRechargeService

+ (void)rereadRecharge:(NSString *)productId PayType:(MFYPayType)payType Completion:(nonnull void (^)(MFYWXOrderModel * , NSError * ))completion {
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithCapacity:0];
    dic[@"sourcetype"] = @(payType);
    dic[@"productid"] = productId;
    [[MFYHTTPManager sharedManager] POST:@"/api/self/image/reread/recharge" parameters:dic success:^(NSURLSessionDataTask * _Nonnull task, MFYResponseObject * _Nonnull responseObject) {
        if (responseObject.code ==  1) {
            MFYWXOrderModel * model = [[MFYWXOrderModel alloc]initWithDictionary:responseObject.result];
            completion(model,nil);
        }else{
            completion(nil,[NSError errorWithCode:responseObject.code desc:responseObject.errorDesc]);
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        completion(nil,error);
    }];
}

+ (void)professRechargePayType:(MFYPayType)payType Completion:(void (^)(MFYWXOrderModel * , NSError * ))completion {
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithCapacity:0];
    dic[@"sourcetype"] = @(payType);
    [[MFYHTTPManager sharedManager] POST:@"/api/self/chat/recharge" parameters:dic success:^(NSURLSessionDataTask * _Nonnull task, MFYResponseObject * _Nonnull responseObject) {
        if (responseObject.code ==  1) {
            MFYWXOrderModel * model = [[MFYWXOrderModel alloc]initWithDictionary:responseObject.result];
            completion(model,nil);
        }else{
            completion(nil,[NSError errorWithCode:responseObject.code desc:responseObject.errorDesc]);
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        completion(nil,error);
    }];

}

+ (void)purchaseCard:(NSString *)articleId PayType:(MFYPayType)payType Completion:(void (^)(MFYWXOrderModel * , NSError * ))completion {
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithCapacity:0];
    dic[@"sourcetype"] = @(payType);
    dic[@"articleid"] = articleId;
    [[MFYHTTPManager sharedManager] POST:@"/api/article/purchase" parameters:dic success:^(NSURLSessionDataTask * _Nonnull task, MFYResponseObject * _Nonnull responseObject) {
        if (responseObject.code ==  1) {
            MFYWXOrderModel * model = [[MFYWXOrderModel alloc]initWithDictionary:responseObject.result];
            completion(model,nil);
        }else{
            completion(nil,[NSError errorWithCode:responseObject.code desc:responseObject.errorDesc]);
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        completion(nil,error);
    }];

}

+ (void)getTheRechargeOrderStatus:(NSString *)orderId Completion:(void (^)(MFYWXOrderModel * , NSError * ))completion {
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithCapacity:0];
    dic[@"orderid"] = orderId;

    [[MFYHTTPManager sharedManager] GET:@"/api/self/recharge/get" parameters:dic success:^(NSURLSessionDataTask * _Nonnull task, MFYResponseObject * _Nonnull cmsResponse) {
        MFYResponseObject * resp = cmsResponse;
        if (resp.code == 1) {
            MFYWXOrderModel * model = [[MFYWXOrderModel alloc]initWithDictionary:resp.result];
            completion(model.copy,nil);
        }else {
            completion(nil,[NSError errorWithCode:resp.code desc:resp.errorDesc]);
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}

+ (void)getTheProfessStatusCompletion:(void (^)(CGFloat, NSError *))completion {
    
    [[MFYHTTPManager sharedManager] POST:@"/api/profile/interact/chat/check" parameters:@{} success:^(NSURLSessionDataTask * _Nonnull task, MFYResponseObject * _Nonnull cmsResponse) {
        MFYResponseObject * resp = cmsResponse;
        if (resp.code == 1) {
            //返回0表示不需要充值尚有余额，大于0表示该次表白需要的价格。
            CGFloat price = [resp.result floatValue];
            completion(price,nil);
        }else {
            completion(-1,[NSError errorWithCode:resp.code desc:resp.errorDesc]);
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        completion(-1, error);
    }];
}


@end
