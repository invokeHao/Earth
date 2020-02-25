//
//  MFYTimeLineView.m
//  Earth
//
//  Created by colr on 2020/2/24.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import "MFYTimeLineView.h"
#import "MFYDateItemView.h"
#import "MFYArticle.h"

const CGFloat itemWidth = 54;

@interface MFYTimeLineView ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong)UIView * lineView;

@end

@implementation MFYTimeLineView

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.delegate = self;
        self.dataSource = self;
        self.backgroundColor = [UIColor clearColor];
        [self registerClass:[MFYDateItemView class] forCellWithReuseIdentifier:[MFYDateItemView reuseID]];
    }
    return self;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.articleArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MFYDateItemView *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[MFYDateItemView reuseID]
                                                                 forIndexPath:indexPath];
    MFYArticle * article = self.articleArr[indexPath.item];
    [cell setCreateDate:article.createDate];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size = CGSizeMake(itemWidth, itemWidth);
    return size;
}

//- (void)setTags:(NSArray* )tags {
//    _tags = tags;
//    [self reloadData];
//    [self layoutIfNeeded];
//    dispatch_async(dispatch_get_main_queue(),^{
//        if (self.shouldUpdateHeight) {
//            self.shouldUpdateHeight(self.collectionViewLayout.collectionViewContentSize.width);
//        }
//    });
//}

- (void)setArticleArr:(NSArray<MFYArticle *> *)articleArr {
    if (articleArr.count > 0) {
        _articleArr = articleArr;
        [self reloadData];
    }
}



@end
