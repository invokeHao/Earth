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

@property (nonatomic, assign)NSInteger currentIndex;

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

- (NSInteger)numberOfSections {
    return 1;
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

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    MFYDateItemView * cell = (MFYDateItemView *) [collectionView cellForItemAtIndexPath:indexPath];
    [cell itemCancelSelected];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self configTheCellStatus:indexPath.item];
    //需要与上方互动
    if (self.itemBlock) {
        self.itemBlock(indexPath.item);
    }
}


#pragma mark- public
- (void)setArticleArr:(NSArray<MFYArticle *> *)articleArr {
    if (articleArr.count > 0) {
        if (_articleArr.count < 1) {
            _currentIndex = 0;
        }
        _articleArr = articleArr;

        [self reloadData];
        [self layoutIfNeeded];
        dispatch_async(dispatch_get_main_queue(),^{
            NSIndexPath * currentPath = [NSIndexPath indexPathForItem:self.currentIndex inSection:0];
            MFYDateItemView * currentCell = (MFYDateItemView *) [self cellForItemAtIndexPath:currentPath];
            [currentCell itemDidSelected];
        });
    }
}

- (void)mfy_didScrollToItem:(NSInteger)index {
    NSIndexPath * path = [NSIndexPath indexPathForItem:index inSection:0];
    [self scrollToItemAtIndexPath:path atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    [self configTheCellStatus:index];
}

- (void)configTheCellStatus:(NSInteger )index {
    if (self.currentIndex == index) {
        return;
    }
    NSIndexPath * path = [NSIndexPath indexPathForItem:index inSection:0];
    MFYDateItemView * cell = (MFYDateItemView *) [self cellForItemAtIndexPath:path];
    [cell itemDidSelected];
    NSIndexPath * currentPath = [NSIndexPath indexPathForItem:self.currentIndex inSection:0];
    MFYDateItemView * currentCell = (MFYDateItemView *) [self cellForItemAtIndexPath:currentPath];
    [currentCell itemCancelSelected];
    self.currentIndex = index;
}

@end
