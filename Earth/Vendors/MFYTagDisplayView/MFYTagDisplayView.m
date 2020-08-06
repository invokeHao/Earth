//
//  MFYTagDisplayView.m
//  Earth
//
//  Created by colr on 2020/2/16.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import "MFYTagDisplayView.h"
#import "MFYTagCell.h"

@interface MFYTagDisplayView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@end

@implementation MFYTagDisplayView

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.delegate = self;
        self.dataSource = self;
        [self registerClass:[MFYTagCell class] forCellWithReuseIdentifier:[MFYTagCell reuseID]];
    }
    return self;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.tags.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MFYTagCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[MFYTagCell reuseID]
                                                                 forIndexPath:indexPath];
    NSString *tagStr = self.tags[indexPath.row];
    [cell setTitleStr:tagStr];
    cell.themeColor = self.tagColor;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *tagStr = self.tags[indexPath.row];
    CGSize textSize = [tagStr sizeWithAttributes:@{NSFontAttributeName:WHFont(15)}];
    CGFloat tagWidth = textSize.width + 10;
    CGFloat tagHeight = 22;
    CGSize size = CGSizeMake(tagWidth, tagHeight);
    if ([tagStr isEqualToString:MFYTagAddSingal]) {
        size = CGSizeMake(49, 22);
    }
    return size;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *tagStr = self.tags[indexPath.row];
    if ([tagStr isEqualToString:MFYTagAddSingal]) {
        if (self.addTagBlock) {
            self.addTagBlock();
        }
    }else {
        if (self.deleteTagBlock) {
            self.deleteTagBlock(tagStr);
        }
    }
}


- (UIColor *)tagColor {
    if (!_tagColor) {
        _tagColor = [UIColor whiteColor];
    }
    return _tagColor;
}

- (void)setTags:(NSArray* )tags {
    _tags = tags;
    [self reloadData];
    [self layoutIfNeeded];
    dispatch_async(dispatch_get_main_queue(),^{
        if (self.shouldUpdateHeight) {
            self.shouldUpdateHeight(self.collectionViewLayout.collectionViewContentSize.height);
        }
    });
}


@end
