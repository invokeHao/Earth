//
//  MFYDynamicManager.m
//  Earth
//
//  Created by colr on 2020/2/10.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import "MFYDynamicManager.h"
#import "MFYQiniuSystemService.h"
#import "MFYPublishService.h"


@implementation MFYDynamicManager

+ (instancetype)sharedManager {
    static MFYDynamicManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[MFYDynamicManager alloc] init];
    });
    return instance;
}

+ (void)getQiniuUploadTockenSuccess:(MFYSuccessAction)success failure:(MFYErrorAction)failure {
    
    [MFYQiniuSystemService getQiniuUploadTockenSuccess:^(MFYQiNiuModel*  _Nonnull model) {
        if (model) {
            [MFYDynamicManager sharedManager].qiniuTocken = model.uploadToken;
            success(model);
        }
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

+ (void)UploadTheAssetModel:(MFYAssetModel*)model completion:(nonnull void (^)(MFYQiNiuResponse *, NSError * ))completion {
    [MFYDynamicManager getQiniuUploadTockenSuccess:^(MFYQiNiuModel *qinniuModel) {
        [MFYQiniuSystemService uploadAssetModel:model progress:^(NSString *key, float percent) {
            WHLog(@"%f",percent);
        } success:^(NSDictionary * _Nonnull resp) {
            MFYQiNiuResponse * respModel = [[MFYQiNiuResponse alloc]initWithDictionary:resp];
            completion(respModel, nil);
        } failure:^{
            NSError * error = [NSError errorWithCode: -11 desc:@"上传失败"];
            completion(nil, error);
        }];
    } failure:^(NSError *error) {
        completion(nil, error);
    }];
}

+ (void)UploadToQiniuAudio:(NSString *)audioPath completion:(void (^)(MFYQiNiuResponse * , NSError * ))completion {
    [MFYDynamicManager getQiniuUploadTockenSuccess:^(MFYQiNiuModel *qinniuModel) {
        [MFYQiniuSystemService uploadAudio:audioPath progress:^(NSString *key, float percent) {
            WHLog(@"%f",percent);
        } success:^(NSDictionary * _Nonnull resp) {
            MFYQiNiuResponse * respModel = [[MFYQiNiuResponse alloc]initWithDictionary:resp];
            completion(respModel, nil);
        } failure:^{
            NSError * error = [NSError errorWithCode: -11 desc:@"上传失败"];
            completion(nil, error);
        }];
    } failure:^(NSError *error) {
        completion(nil, error);
    }];

}

+ (void)publishTheArticle:(MFYPublishModel *)model completion:(void (^)(MFYArticle * , NSError * ))completion {
    [MFYPublishService publishTheArticleParam:[model toDictionary] completion:^(MFYArticle * _Nonnull article, NSError * _Nonnull error) {
        completion(article,error);
    }];
}

+ (void)publishTheAudioArticle:(NSString *)audioPath completion:(void (^)(MFYArticle * , NSError * ))completion {
    [MFYDynamicManager getQiniuUploadTockenSuccess:^(MFYQiNiuModel *qinniuModel) {
        [MFYQiniuSystemService uploadAudio:audioPath progress:^(NSString *key, float percent) {
            WHLog(@"%f",percent);
        } success:^(NSDictionary * _Nonnull resp) {
            MFYQiNiuResponse * respModel = [[MFYQiNiuResponse alloc]initWithDictionary:resp];
            MFYPublishItemModel * itemModel = [[MFYPublishItemModel alloc]init];
            itemModel.fileId = respModel.storeId;
            itemModel.fileType = 2;
            MFYPublishModel * publishModel = [[MFYPublishModel alloc]init];
            publishModel.audioItem = itemModel;
            //上传声控贴
            [MFYPublishService publishTheAudioArticleParam:[publishModel toDictionary] completion:^(MFYArticle * _Nonnull article, NSError * _Nonnull error) {
                completion(article, error);
            }];
        } failure:^{
            NSError * error = [NSError errorWithCode: -11 desc:@"上传失败"];
            completion(nil, error);
        }];
    } failure:^(NSError *error) {
        completion(nil, error);
    }];

}



@end
