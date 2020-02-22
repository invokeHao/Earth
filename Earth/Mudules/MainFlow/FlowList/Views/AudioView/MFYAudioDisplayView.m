//
//  MFYAudioDisplayView.m
//  Earth
//
//  Created by colr on 2020/2/16.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import "MFYAudioDisplayView.h"
#import "MFYAudioFlowLayout.h"
#import "MFYAudioPlayCell.h"

#define cellWidth W_SCALE(280)
#define cellHeight H_SCALE(440)
#define itemSpacing W_SCALE(15)


@interface MFYAudioDisplayView ()<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate>


@property (nonatomic,strong) NSArray *dataList;

@property (nonatomic,assign) NSInteger currentIndex;

@property (nonatomic, strong) UICollectionView * mainCollection;

@end

@implementation MFYAudioDisplayView

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

-(void)reloadDataWithArray:(NSArray*)arr {
    if (arr.count > 0) {
        self.dataList = arr;
        [self.mainCollection reloadData];
        [self.mainCollection layoutIfNeeded];
        @weakify(self)
        wh_dispatch_main_async(^{
            @strongify(self)
            [self playTheAudio];
        });
    }else {
        return;
    }
}

- (void)playTheAudio {
    NSIndexPath * indexPath = [NSIndexPath indexPathForItem:self.currentIndex inSection:0];
    MFYAudioPlayCell * cell = (MFYAudioPlayCell *) [self.mainCollection cellForItemAtIndexPath:indexPath];
    [cell playTheAudio];
}

- (void)stopTheAudio {
    NSIndexPath * indexPath = [NSIndexPath indexPathForItem:self.currentIndex inSection:0];
    MFYAudioPlayCell * cell = (MFYAudioPlayCell *) [self.mainCollection cellForItemAtIndexPath:indexPath];
    [cell stopTheAudio];
}

#pragma mark- CollectionView dataSource && delegate

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataList.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MFYAudioPlayCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[MFYAudioPlayCell reuseID] forIndexPath:indexPath];
    MFYArticle * article = self.dataList[indexPath.item];
    [cell setModel:article];
    return cell;
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
        MFYAudioPlayCell * lastCell = (MFYAudioPlayCell *) [self.mainCollection cellForItemAtIndexPath:lastIndex];
        [lastCell stopTheAudio];
        //下一个cell
        NSIndexPath * nextIndex = [NSIndexPath indexPathForItem:index inSection:0];
        MFYAudioPlayCell * nextCell = (MFYAudioPlayCell *) [self.mainCollection cellForItemAtIndexPath:nextIndex];
        [nextCell playTheAudio];

        _currentIndex = index;
    }
    WHLog(@"EndDecelerating==%d",index);
    
}

- (UICollectionView *)mainCollection {
    if (!_mainCollection) {
        MFYAudioFlowLayout *layout = [[MFYAudioFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = itemSpacing;
        layout.itemSize = CGSizeMake(cellWidth, cellHeight);
        //初始化collectionView
        _mainCollection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, VERTICAL_SCREEN_WIDTH, cellHeight) collectionViewLayout:layout];
        [_mainCollection registerClass:[MFYAudioPlayCell class] forCellWithReuseIdentifier:[MFYAudioPlayCell reuseID]];
        _mainCollection.backgroundColor = [UIColor clearColor];
        _mainCollection.showsHorizontalScrollIndicator = NO;
        _mainCollection.delegate = self;
        _mainCollection.dataSource = self;
        _mainCollection.decelerationRate = 0.5;
    }
    return _mainCollection;
}


@end