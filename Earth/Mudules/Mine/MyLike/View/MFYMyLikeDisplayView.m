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
        return audioCell;
    }else {
        [collectionView registerClass:[MFYImageCardCell class] forCellWithReuseIdentifier:[MFYImageCardCell reuseID]];
        MFYImageCardCell * imageCell = [collectionView dequeueReusableCellWithReuseIdentifier:[MFYImageCardCell reuseID] forIndexPath:indexPath];
        [imageCell setArticle:article];
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
    WHLog(@"EndDecelerating==%d",index);
    
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

