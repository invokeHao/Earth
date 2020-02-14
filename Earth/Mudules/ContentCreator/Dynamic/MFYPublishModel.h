//
//  MFYPublishModel.h
//  Earth
//
//  Created by colr on 2020/2/10.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MFYPublishItemModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MFYPublishModel : NSObject

@property (strong, nonatomic)NSString * desc;

@property (strong, nonatomic)NSString * topicId;

@property (strong, nonatomic)NSString * title;

@property (copy, nonatomic)NSArray * extraMedias;


@property (strong, nonatomic)MFYPublishItemModel * bigitem;

@property (strong, nonatomic)MFYPublishItemModel * smallTopItem;

@property (strong, nonatomic)MFYPublishItemModel * smallBottomItem;

- (BOOL)unVerify;

- (NSDictionary *)toDictionary;

@end

NS_ASSUME_NONNULL_END
