//
//  MFYPublishItemModel.h
//  Earth
//
//  Created by colr on 2020/2/10.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MFYAssetModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MFYPublishItemModel : NSObject

@property (strong, nonatomic)NSString * fileDesc;

@property (strong, nonatomic)NSString * fileId; //上传7云成功后的storeid

@property (assign, nonatomic)NSInteger fileType;

@property (assign, nonatomic)NSInteger priceAmount;

@property (strong, nonatomic)MFYAssetModel * assetModel;

- (NSDictionary *)ModelToDictionarty;

@end

NS_ASSUME_NONNULL_END
