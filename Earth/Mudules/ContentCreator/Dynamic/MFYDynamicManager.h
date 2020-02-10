//
//  MFYDynamicManager.h
//  Earth
//
//  Created by colr on 2020/2/10.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^MFYSuccessAction)(id model);
typedef void (^MFYErrorAction)(NSError *error); //常用与返回单个判断字段， 如果不成功，会在基类里处理成error， 故不用判断isSucess.或用下面的方法

NS_ASSUME_NONNULL_BEGIN

@interface MFYDynamicManager : NSObject

@property (nonatomic, strong) NSString *qiniuTocken;

+ (instancetype)sharedManager;

+ (void)getQiniuUploadTockenSuccess:(MFYSuccessAction)success failure:(MFYErrorAction)failure;

@end

NS_ASSUME_NONNULL_END
