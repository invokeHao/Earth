//
//  MFYPublicManager.h
//  Earth
//
//  Created by colr on 2020/2/10.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MFYAssetModel.h"
#import "MFYPhotoCropVC.h"

typedef NS_ENUM(NSInteger, MFYPublicType) {
    mfyPublicTypeNull = 0,
    MFYPublicTypeImage,
    MFYPublicTypeVideo
};


typedef void(^successBlock)(MFYAssetModel* _Nullable model);

NS_ASSUME_NONNULL_BEGIN

@interface MFYPublicManager : NSObject

@property (nonatomic, strong) UIViewController *fromViewController;
@property (nonatomic, assign) MFYPublicType publishType;
@property (nonatomic, strong) successBlock successB;

- (void)publishPhotoFromVC:(UIViewController *)viewController publishType:(MFYPublicType)publishType completion:(successBlock)completion;


@end

NS_ASSUME_NONNULL_END
