//
//  MFYBaseCollectionViewCell.h
//  Earth
//
//  Created by colr on 2020/2/16.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MFYBaseCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) id element;

- (void)renderWithModel:(id)element args:(NSDictionary *)args;

+ (CGSize)cellSizeWithModel:(id)element args:(NSDictionary *)args;

+ (NSString *)reuseID;

+ (NSString *)identifer;
@end

NS_ASSUME_NONNULL_END
