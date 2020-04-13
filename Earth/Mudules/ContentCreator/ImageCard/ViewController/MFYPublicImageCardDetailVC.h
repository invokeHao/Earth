//
//  MFYPublicImageCardDetailVC.h
//  Earth
//
//  Created by colr on 2020/1/21.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import "MFYBaseViewController.h"
#import "MFYPublishItemModel.h"

typedef void(^publishBlock)(MFYPublishItemModel * _Nullable itemModel);

NS_ASSUME_NONNULL_BEGIN

@interface MFYPublicImageCardDetailVC : MFYBaseViewController

@property (assign, nonatomic)BOOL isBig;

@property (nonatomic, strong)MFYPublishItemModel * itemModel;

@property (strong, nonatomic)publishBlock publishB;

@end

NS_ASSUME_NONNULL_END
