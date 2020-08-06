//
//  MFYMineHpVM.h
//  Earth
//
//  Created by colr on 2020/2/19.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MFYProfile.h"

NS_ASSUME_NONNULL_BEGIN

@interface MFYMineHpVM : NSObject

@property (nonatomic, strong, readonly) MFYProfile *profile;


-(void)refreshData;


@end

NS_ASSUME_NONNULL_END
