//
//  MFYMyLikeDisplayView.m
//  Earth
//
//  Created by colr on 2020/2/24.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import "MFYMyLikeDisplayView.h"
#import "MFYAudioFlowLayout.h"
#import "MFYAudioPlayCell.h"
#import "MFYImageCardCell.h"
#import "MFYArticleService.h"


#define cellWidth W_SCALE(325)
#define cellHeight H_SCALE(368)
#define itemSpacing W_SCALE(0)


@interface MFYMyLikeDisplayView ()<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate>


@property (nonatomic,strong) NSArray *dataList;

@property (nonatomic,assign) NSInteger currentIndex;

@property (nonatomic, strong) UICollectionView * mainCollection;

@end

@implementation MFYMyLikeDisplayView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

-(void)setupViews{
    _currentIndex = 0;
    [self addSubview:self.mainCollection];
}

#pragma mark- public

-(void)reloadDataWithArray:(NSArray<MFYArticle *> *)arr{
    if (arr.count > 0) {
        self.dataList = arr;
        [self.mainCollection reloadData];
        [self.mainCollection layoutIfNeeded];
        @weakify(self)
        wh_dispatch_main_async(^{
            @strongify(self)
            [self playTheMedia];
        });
    }else {
        return;
    }
}

- (void)playTheMedia {
    NSIndexPath * indexPath = [NSIndexPath indexPathForItem:self.currentIndex inSection:0];
    MFYBaseCollectionViewCell * cell = (MFYBaseCollectionViewCell *) [self.mainCollection cellForItemAtIndexPath:indexPath];
    [cell mfy_startPlay];
}

- (void)stopTheMedia {
    NSIndexPath * indexPath = [NSIndexPath indexPathForItem:self.currentIndex inSection:0];
    MFYBaseCollectionViewCell * cell = (MFYBaseCollectionViewCell *) [self.mainCollection cellForItemAtIndexPath:indexPath];
    [cell mfy_stopPlay];
}

- (void)mfy_scrollToItem:(NSInteger)item {
    NSIndexPath * path = [NSIndexPath indexPathForItem:item inSection:0];
    [self.mainCollection scrollToItemAtIndexPath:path atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}


#pragma mark- CollectionView dataSource && delegate

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataList.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MFYArticle * article = self.dataList[indexPath.item];

    if (article.MFYmediaType == MFYArticleTypeAudio) {
        [collectionView registerClass:[MFYAudioPlayCell class] forCellWithReuseIdentifier:[MFYAudioPlayCell reuseID]];
        MFYAudioPlayCell *audioCell = [collectionView dequeueReusableCellWithReuseIdentifier:[MFYAudioPlayCell reuseID] forIndexPath:indexPath];
        [audioCell setModel:article];
        @weakify(self)
        [audioCell setLongPressBlock:^{
            @strongify(self)
            //弹出是否删除
            [[WHAlertTool shareInstance] showAlterViewWithMessage:@"是否删除此动态" andDoneBlock:^(UIAlertAction * _Nonnull action) {
                @strongify(self);
                [self deleteItemByArticleid:article.articleId atIndexPath:indexPath];
            }];

        }];
        return audioCell;
    }else {
        [collectionView registerClass:[MFYImageCardCell class] forCellWithReuseIdentifier:[MFYImageCardCell reuseID]];
        MFYImageCardCell * imageCell = [collectionView dequeueReusableCellWithReuseIdentifier:[MFYImageCardCell reuseID] forIndexPath:indexPath];
        [imageCell setArticle:article];
        @weakify(self)
        [imageCell setLongPressBlock:^{
            @strongify(self)
            //弹出是否删除
            [[WHAlertTool shareInstance] showAlterViewWithMessage:@"是否删除此动态" andDoneBlock:^(UIAlertAction * _Nonnull action) {
                @strongify(self);
                [self deleteItemByArticleid:article.articleId atIndexPath:indexPath];
            }];
        }];
        return imageCell;
    }
}



-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//    _pageControl.currentPage = indexPath.row;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    int index = (scrollView.contentOffset.x+self.bounds.size.width/2)/cellWidth;
    
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    int index = (scrollView.contentOffset.x+self.bounds.size.width/2)/cellWidth;
    WHLog(@"WillBeginDragging==%d",index);
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    //滑动结束时显示
    int index = (scrollView.contentOffset.x+self.bounds.size.width/2)/(cellWidth+itemSpacing);
    if (index != _currentIndex) {
        //上一个cell
        NSIndexPath * lastIndex = [NSIndexPath indexPathForItem:_currentIndex inSection:0];
        MFYBaseCollectionViewCell * lastCell = (MFYBaseCollectionViewCell *) [self.mainCollection cellForItemAtIndexPath:lastIndex];
        [lastCell mfy_stopPlay];
        //下一个cell
        NSIndexPath * nextIndex = [NSIndexPath indexPathForItem:index inSection:0];
        MFYBaseCollectionViewCell * nextCell = (MFYBaseCollectionViewCell *) [self.mainCollection cellForItemAtIndexPath:nextIndex];
        [nextCell mfy_startPlay];

        _currentIndex = index;
    }
    if (self.scrollBlock) {
        self.scrollBlock(index);
    }
//    WHLog(@"EndDecelerating==%d",index);
}

#pragma mark- 删除帖子
- (void)deleteItemByArticleid:(NSString*)articleId atIndexPath:(NSIndexPath *)indexpath {
    @weakify(self)
    [MFYArticleService deleteArticle:articleId Completion:^(BOOL isSuccess, NSError * _Nonnull error) {
        if (isSuccess) {
            @strongify(self)
            [self stopTheMedia];
            NSMutableArray *mutableCoreFlowArray = [self.dataList mutableCopy];
            [mutableCoreFlowArray removeObjectAtIndex:indexpath.item];
            self.dataList = [mutableCoreFlowArray copy];
            self.currentIndex = MIN(self.currentIndex, self.dataList.count - 1);
            [self.mainCollection performBatchUpdates:^{
                [self.mainCollection deleteItemsAtIndexPaths:@[indexpath]];
            } completion:^(BOOL finished) {
                [self.mainCollection reloadData];
            }];
        }else {
            [WHHud showString:error.descriptionFromServer];
        }
    }];
}

- (UICollectionView *)mainCollection {
    if (!_mainCollection) {
        MFYAudioFlowLayout *layout = [[MFYAudioFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = itemSpacing;
        layout.itemSize = CGSizeMake(cellWidth, cellHeight);
        //初始化collectionView
        _mainCollection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, VERTICAL_SCREEN_WIDTH, cellHeight) collectionViewLayout:layout];
        _mainCollection.backgroundColor = [UIColor clearColor];
        _mainCollection.showsHorizontalScrollIndicator = NO;
        _mainCollection.delegate = self;
        _mainCollection.dataSource = self;
        _mainCollection.decelerationRate = 0.5;
    }
    return _mainCollection;
}

@end

