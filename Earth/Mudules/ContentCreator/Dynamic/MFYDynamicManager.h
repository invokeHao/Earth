//
//  MFYDynamicManager.h
//  Earth
//
//  Created by colr on 2020/2/10.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MFYQiNiuModel.h"
#import "MFYAssetModel.h"
#import "MFYQiNiuResponse.h"
#import "MFYPublishModel.h"
#import "MFYArticle.h"

typedef void (^MFYSuccessAction)(MFYQiNiuModel* model);
typedef void (^MFYErrorAction)(NSError *error); //常用与返回单个判断字段， 如果不成功，会在基类里处理成error， 故不用判断isSucess.或用下面的方法

NS_ASSUME_NONNULL_BEGIN

@interface MFYDynamicManager : NSObject

@property (nonatomic, strong) NSString *qiniuTocken;

+ (instancetype)sharedManager;


#pragma mark- 上传素材到七牛
+ (void)UploadTheAssetModel:(MFYAssetModel*)model completion:(void(^)(MFYQiNiuResponse* resp, NSError * error))completion;

#pragma mark- 上传帖子
+ (void)publishTheArticle:(MFYPublishModel*)model completion:(void(^)(MFYArticle* article, NSError * error))completion;

@end

NS_ASSUME_NONNULL_END
