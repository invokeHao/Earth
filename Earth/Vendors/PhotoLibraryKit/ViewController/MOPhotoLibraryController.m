//
//  MOPhotoLibraryController.m
//  PhotoLibraryKit
//
//  Created by colr on 2018/6/7.
//  Copyright © 2018年 colr. All rights reserved.
//

#import "MOPhotoLibraryController.h"

#import <ReactiveCocoa/ReactiveCocoa.h>
#import <Masonry.h>
#import "MOPhotoUtil.h"
#import "MOPhotoLibraryManager.h"
#import "MOPhotoTransformer.h"
#import "MOMacro.h"
#import "MOPhotoLibraryExportCenter.h"
#import "MOAssetDownloadManager.h"

#import "MOPhotoLibraryNavigationBar.h"
#import "MOPhotoListTableView.h"
#import "MOAssetCell.h"

#import "UIView+MOHud.h"
#import "MOExportLoadingView.h"
#import "MOPhotoLibraryExportCenter.h"
#import "MOPhotoPreviewViewController.h"
#import "MODownloadNotificationModel.h"
#import "MFYPhotosManager.h"

#import "MFYFirstModel.h"
#import "MFYTakePhotoCell.h"
#import "SRAlbumViewController.h"

@interface MOPhotoLibraryController () <PhotoLibraryNavigationBarDelegate, PhotoListTableViewDelegate, MOAssetCellDelegate,UICollectionViewDelegate, UICollectionViewDataSource,SRAlbumViewControllerDelegate>

@property (nonatomic, strong) MOPhotoLibraryNavigationBar *navigationBar;
@property (nonatomic, strong) MOPhotoListTableView *photoListTableView;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, copy) NSArray<MOAssetModel *> *dataList;
@property (nonatomic, assign) NSInteger selectedAlbumIndex;
@property (nonatomic, strong) MOPhotoLibraryExportCenter *exportCenter;
@property (nonatomic, strong) MOPhotoLibraryConfiguration *configuration;

@end

@implementation MOPhotoLibraryController

- (instancetype)initWithPhotoLibraryConfiguration:(MOPhotoLibraryConfiguration *)configuration {
    self = [super init];
    if (self) {
        self.configuration = configuration;
        [self.navigationBar loadWithPhotoLibraryConfiguration:configuration];
        [[MOPhotoLibraryManager sharedManager] loadMaxSelectedCount:configuration.maxSelectedCount];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    [self setupConstraint];
    [self dataBinding];
    [self addNotification];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];;
}

-(void)setupUI {
    self.view.backgroundColor = [UIColor wh_colorWithHexString:@"0x1B1A28"];
    [self.view addSubview:self.navigationBar];
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.photoListTableView];
}

-(void)setupConstraint {
    CGFloat top = SREEN_HEIGHT == 812 ? 88 : 64;
    CGFloat height = SREEN_HEIGHT - top;
    
    if ([self.dataSource respondsToSelector:@selector(photoLibraryControllerAddHeaderView:)]) {
        UIView *headerView = [self.dataSource photoLibraryControllerAddHeaderView:self];
        if (headerView) {
            [self.view insertSubview:headerView atIndex:2];
            top = CGRectGetHeight(headerView.frame) + top + 10;
            height = SREEN_HEIGHT - top;
            self.collectionView.frame = CGRectMake(0, top, SREEN_WIDTH, height);
            return;
        }
    }
    self.collectionView.frame = CGRectMake(0, top, SREEN_WIDTH, height);
}

-(void)dataBinding {
    self.selectedAlbumIndex = 1;
    self.exportCenter = [[MOPhotoLibraryExportCenter alloc] init];

    @weakify(self)
    [MOPhotoUtil checkAuthStatus:^(BOOL hasAuthority) {
        @strongify(self)
        if (hasAuthority) {
            [self fetchAssetCollections];
        }else {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"请开启相册读取权限" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSURL* url =[NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if([[UIApplication sharedApplication] canOpenURL:url]) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                }
            }];
            [alertController addAction:cancelAction];
            [alertController addAction:okAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }];
    
  
}

- (void)addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willDownloadNotification:) name:MOAssetDownloadWillDownloadNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadProgressNotification:) name:MOAssetDownloadProgressNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadDidFinishDownloadNotification:) name:MOAssetDownloadDidFinishDownloadNotification object:nil];
}

#pragma mark - notification

- (void)willDownloadNotification:(NSNotification *)notification {
    
}

- (void)downloadProgressNotification:(NSNotification *)notification {
    MODownloadNotificationModel *notificationModel = [MODownloadNotificationModel yy_modelWithDictionary:notification.userInfo];
    [self.dataList enumerateObjectsUsingBlock:^(MOAssetModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([notificationModel.identifier isEqualToString:obj.identifier]) {
            obj.isDownloadFinish = NO;
            obj.progress = (double)notificationModel.progress;
            *stop = YES;
        }
    }];
}

- (void)downloadDidFinishDownloadNotification:(NSNotification *)notification {
    MODownloadNotificationModel *notificationModel = [MODownloadNotificationModel yy_modelWithDictionary:notification.userInfo];
    [self.dataList enumerateObjectsUsingBlock:^(MOAssetModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([notificationModel.identifier isEqualToString:obj.identifier] && !obj.isDownloadFinish) {
            obj.isDownloadFinish = YES;
            obj.progress = (double)notificationModel.progress;
            *stop = YES;
        }
    }];
}


#pragma mark - pubilc method

- (void)loadWithSelectedData {
    if ([MOPhotoLibraryManager sharedManager].selectedCount == 0) {
        [self.navigationBar changeRightTitle:@"下一步"];
    }else {
        NSString *nextText = [NSString stringWithFormat:@"下一步 (%ld)",(long)[MOPhotoLibraryManager sharedManager].selectedCount];
        [self.navigationBar changeRightTitle:nextText];
    }
    self.dataList = [self rememberSelectedModelWithAssetModelList:self.dataList];
    [self.collectionView reloadData];
}

- (void)addItem:(MOAssetModel *)item {
    NSMutableArray *arrM = [NSMutableArray arrayWithArray:self.dataList];
    [arrM insertObject:item atIndex:0];
    NSArray *changeArray = [arrM copy];
    [self.photoListTableView.dataList enumerateObjectsUsingBlock:^(MOAlbumModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (self.dataList == obj.assetModelList) {
            obj.assetModelList = changeArray;
        }
    }];
    self.dataList = changeArray;
}

#pragma mark - private method

- (void)fetchAssetCollections {
    @weakify(self)
    [MOPhotoUtil fetchAssetCollectionsWithAlbumType:self.configuration.albumType completion:^(NSArray<PHAssetCollection *> *collectionList) {
        @strongify(self)
        NSArray<MOAlbumModel *> *albumList = [MOPhotoTransformer collectionTransformer:collectionList];
        [self.photoListTableView loadData:albumList];
        if (albumList.count > 0) {
            MOAlbumModel *firstAlbum = albumList.firstObject;
            [self refreshAssetList:firstAlbum];
        }
    }];
}

- (void)refreshAssetList:(MOAlbumModel *)albumModel {
    [self.navigationBar changePhotoColletionTitle:albumModel.name];
    if (albumModel.assetModelList) {
        albumModel.assetModelList = [self rememberSelectedModelWithAssetModelList:albumModel.assetModelList];
        self.dataList = albumModel.assetModelList;
        [self.collectionView reloadData];
        [self.navigationBar recoverEvent];
        [self.collectionView setContentOffset:CGPointZero animated:NO];
    }else {
        [MOPhotoUtil fetchAssetListFromAssetCollection:albumModel.collection assetType:self.configuration.assetType completion:^(NSArray<PHAsset *> *list) {
            NSArray<MOAssetModel *> *assetModelList = [MOPhotoTransformer assetTransformer:list];
            albumModel.assetModelList = [self rememberSelectedModelWithAssetModelList:assetModelList];
            NSMutableArray * newArr = [NSMutableArray arrayWithArray:albumModel.assetModelList];
            MFYFirstModel * firstModel = [[MFYFirstModel alloc]init];
            [newArr insertObject:firstModel atIndex:0];
//            self.dataList = albumModel.assetModelList;
            self.dataList = [newArr copy];
            [self.collectionView reloadData];
            [self.navigationBar recoverEvent];
            [self.collectionView setContentOffset:CGPointZero animated:NO];
        }];
    }
    
    // 只有第一个相册显示在线gif搜索   (设计要改成这样, 很蛋疼~~)
    CGFloat top = SREEN_HEIGHT == 812 ? 88 : 64;
    CGFloat height = SREEN_HEIGHT - top;
    UIView *headerView = nil;
    if ([self.dataSource respondsToSelector:@selector(photoLibraryControllerAddHeaderView:)]) {
        headerView = [self.dataSource photoLibraryControllerAddHeaderView:self];
    }
    if (self.selectedAlbumIndex == 1 && headerView) {
        top = CGRectGetHeight(headerView.frame) + top + 10;
        height = SREEN_HEIGHT - top;
        self.collectionView.frame = CGRectMake(0, top, SREEN_WIDTH, height);
        headerView.hidden = NO;
    }else {
        self.collectionView.frame = CGRectMake(0, top, SREEN_WIDTH, height);
        headerView.hidden = YES;
    }
}

- (NSArray<MOAssetModel *> *)rememberSelectedModelWithAssetModelList:(NSArray<MOAssetModel *> *)dataList {
    [dataList enumerateObjectsUsingBlock:^(MOAssetModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.selected = NO;
    }];
    [[MOPhotoLibraryManager sharedManager].selectedList enumerateObjectsUsingBlock:^(MOAssetModel * _Nonnull selectObj, NSUInteger selectIdx, BOOL * _Nonnull selectStop) {
        [dataList enumerateObjectsUsingBlock:^(MOAssetModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isEqual:selectObj]) {
                obj.videoTransformGifAssetModel = selectObj.videoTransformGifAssetModel;
                obj.serialNumber = selectObj.serialNumber;
                obj.selected = YES;
                *stop = YES;
            }
        }];
    }];
    [dataList enumerateObjectsUsingBlock:^(MOAssetModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.selected == NO) {
            obj.serialNumber = 0;
        }
    }];
    return dataList;
}

#pragma mark - getting

- (MOPhotoLibraryNavigationBar *)navigationBar {
    if (!_navigationBar) {
        _navigationBar = [[MOPhotoLibraryNavigationBar alloc] init];
        _navigationBar.delegate = self;
    }
    return _navigationBar;
}

- (MOPhotoListTableView *)photoListTableView {
    if (!_photoListTableView) {
        CGFloat height = SREEN_HEIGHT == 812 ? 88 : 64;
        CGRect frame = CGRectMake(0, height, SREEN_WIDTH, 0);
        _photoListTableView = [[MOPhotoListTableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        _photoListTableView.photoListDalagate = self;
    }
    return _photoListTableView;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        CGFloat margin = 1.5;
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumInteritemSpacing = margin;
        flowLayout.minimumLineSpacing = margin;
        CGFloat wh = (SREEN_WIDTH - 2.0 * margin) / 3.0;
        flowLayout.itemSize = CGSizeMake(wh, wh);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.contentInset = UIEdgeInsetsMake(margin, 0, 0, 0);
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[MOAssetCell class]
            forCellWithReuseIdentifier:NSStringFromClass([MOAssetCell class])];
        [_collectionView registerClass:[MFYTakePhotoCell class] forCellWithReuseIdentifier:[MFYTakePhotoCell reuseID]];
    }
    return _collectionView;
}

#pragma mark - PhotoLibraryNavigationBarDelegate

- (void)navigationBar:(MOPhotoLibraryNavigationBar *)navigationBar didClickLeftButton:(UIButton *)leftButton {
    if (self.dismissBlock) {
        self.dismissBlock();
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    [[MFYPhotosManager sharedManager] reset];
}

- (void)navigationBar:(MOPhotoLibraryNavigationBar *)navigationBar didClickCenterButtonWithSelected:(BOOL)isSelected {
    CGFloat top = SREEN_HEIGHT == 812 ? 88 : 64;
    CGFloat height = isSelected ? SREEN_HEIGHT - top : 0;
    CGFloat alpha = isSelected ? 0.3 : 1.0;
    CGFloat buttonAlapha = isSelected ? 0.0 : 1.0;
    [UIView animateWithDuration:0.3 animations:^{
        [self.navigationBar changeViewAlpha:buttonAlapha];
        self.collectionView.alpha = alpha;
        self.photoListTableView.frame = CGRectMake(0, top, SREEN_WIDTH, height);
    }];
    if (isSelected) {
        [self.photoListTableView reloadData];
    }
}

- (void)navigationBar:(MOPhotoLibraryNavigationBar *)navigationBar didClickRightButton:(UIButton *)rightButton {
    
    __block BOOL isAllDownloadFinish = YES;
    [[MOPhotoLibraryManager sharedManager].selectedList enumerateObjectsUsingBlock:^(MOAssetModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!obj.isDownloadFinish) {
            isAllDownloadFinish = NO;
        }
    }];
    if (!isAllDownloadFinish) {
        [self.view showString:@"正在下载iCloud图片,请稍后重试..."];
        return;
    }
    
    [self.view showActivityView];
    @weakify(self)
    [self.exportCenter exportPhotoLibrary:^(NSArray<YYImage *> *photos) {
        @strongify(self)
        [self.view hideActivityView];
        if ([self.delegate respondsToSelector:@selector(photoLibraryController:didFinishPickingPhotos:sourceAssets:)]) {
            [self.delegate photoLibraryController:self didFinishPickingPhotos:photos sourceAssets:[MOPhotoLibraryManager sharedManager].selectedList];
        }
    }];
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSObject *model = self.dataList[indexPath.row];
    if ([model isKindOfClass:[MFYFirstModel class]]) {
        MFYTakePhotoCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:[MFYTakePhotoCell reuseID] forIndexPath:indexPath];
        return cell;
    }else {
        MOAssetCell *cell = [collectionView
                           dequeueReusableCellWithReuseIdentifier:NSStringFromClass([MOAssetCell class]) forIndexPath:indexPath];
        MOAssetModel * assetModel = (MOAssetModel *)model;
        [cell loadData:assetModel];
        cell.delegate = self;
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    //增加点击拍照
    if (indexPath.item == 0) {
        NSObject * model = [self.dataList firstObject];
        if ([model isKindOfClass:[MFYFirstModel class]]) {
            [self jumpToTakePhoto];
            return;
        }
    }
    
    __block BOOL isAllDownloadFinish = YES;
    [[MOPhotoLibraryManager sharedManager].selectedList enumerateObjectsUsingBlock:^(MOAssetModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!obj.isDownloadFinish) {
            isAllDownloadFinish = NO;
        }
    }];
    if (!isAllDownloadFinish) {
        [self.view showString:@"正在下载iCloud图片,请稍后重试..."];
        return;
    }
    
    MOAssetModel *assetModel = self.dataList[indexPath.row];
    // 单个视频直接回调
    if (assetModel.type == MOAssetTypeVideo && [MOPhotoLibraryManager sharedManager].maxSelectedCount == 1) {
        [[MOAssetDownloadManager sharedManager] startDownloadTaskWithAsset:assetModel];
        if ([self.delegate respondsToSelector:@selector(photoLibraryController:didFinishVideoAssets:)]) {
            [self.delegate photoLibraryController:self didFinishVideoAssets:assetModel];
        }
        return;
    }
    
    // 单个图片直接回调
    if ([MOPhotoLibraryManager sharedManager].maxSelectedCount == 1) {
        [[MOAssetDownloadManager sharedManager] startDownloadTaskWithAsset:assetModel];
        [MOPhotoLibraryManager sharedManager].selectedList = [NSMutableArray arrayWithObject:assetModel];
        [self navigationBar:self.navigationBar didClickRightButton:nil];
    }else {
        if (assetModel.type == MOAssetTypeVideo && !assetModel.videoTransformGifAssetModel) {
            //视频转GIF
            if ([self.delegate respondsToSelector:@selector(photoLibraryController:didFinishVideoTranformGif:)]) {
                [self.delegate photoLibraryController:self didFinishVideoTranformGif:assetModel];
            }
        }else {
            //多图预览
            if ([self.delegate respondsToSelector:@selector(photoLibraryController:didPreviewWithAssets:selectedAssetModel:)]) {
                [self.delegate photoLibraryController:self didPreviewWithAssets:self.dataList selectedAssetModel:assetModel];
            }
        }
    }
}

#pragma mark- 打开相机
- (void)jumpToTakePhoto {
    SRDeviceType deviceType = SRDeviceTypeCamera;
    SRAssetType assetType = SRAssetTypeNone;
    SRAlbumViewController *vc = [[SRAlbumViewController alloc] initWithDeviceType:deviceType];
    vc.albumDelegate = self;
    vc.assetType = assetType;
    vc.maxItem = 1;
    vc.maxlength = 500*1024;
    vc.isEidt = NO;
    vc.isShowPicList = YES;
    [self.navigationController presentViewController:vc animated:YES completion:nil];
}

#pragma mark - SRAlbumViewControllerDelegate
/**
 TODO:相册照片获取
 
 @param picker 相册
 @param images 图片列表
 */
- (void)srAlbumPickerController:(SRAlbumViewController *)picker didFinishPickingImages:(NSArray *)images{
    [picker dismissViewControllerAnimated:NO completion:^{
        
    }];
    NSLog(@"%@",[images firstObject]);
    UIImage *image = [images firstObject];
    if ([self.delegate respondsToSelector:@selector(takePhotoController:didFinishPickingPhoto:)]) {
        [self.delegate takePhotoController:self didFinishPickingPhoto:image];
    }
}

/**
 TODO:相册视频获取
 
 @param picker 相册
 @param vedios 视频列表
 */
- (void)srAlbumPickerController:(SRAlbumViewController *)picker didFinishPickingVedios:(NSArray *)vedios{
    [picker dismissViewControllerAnimated:NO completion:^{
        
    }];
    NSURL * fileUrl = [vedios firstObject];
    NSString * fileStr = [fileUrl absoluteString];
    fileStr = [fileStr stringByReplacingOccurrencesOfString:@"file://" withString:@""];
    if ([self.delegate respondsToSelector:@selector(takeVedioController:didFinishPickingVideo:)]) {
        [self.delegate takeVedioController:self didFinishPickingVideo:fileStr];
    }
}


#pragma mark - PhotoListTableViewDelegate

- (void)photoListTableView:(MOPhotoListTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedAlbumIndex = indexPath.row + 1;
    MOAlbumModel *albumModel = tableView.dataList[indexPath.row];
    [self refreshAssetList:albumModel];
}

#pragma mark - MOAssetCellDelegate

- (void)cellDidClickSelectBtn:(UIButton *)button selectedModel:(MOAssetModel *)model {
    
    // 条件拦截器
    if ([self.delegate respondsToSelector:@selector(photoLibraryController:canDidSelected:)] && !model.selected) {
       BOOL canDidSelected = [self.delegate photoLibraryController:self canDidSelected:model];
        if (!canDidSelected) {
            return;
        }
    }
    
    if (model.type == MOAssetTypeVideo && !model.videoTransformGifAssetModel) {
        //视频转GIF
        if ([self.delegate respondsToSelector:@selector(photoLibraryController:didFinishVideoTranformGif:)]) {
            [self.delegate photoLibraryController:self didFinishVideoTranformGif:model];
        }
        return;
    }
    
    button.selected = !button.isSelected;
    model.selected = button.isSelected;
    
    BOOL selected = model.selected;
    if (selected) {
        [[MOPhotoLibraryManager sharedManager].selectedList addObject:model];
        model.serialNumber = [MOPhotoLibraryManager sharedManager].selectedList.count;
    } else {
        [[MOPhotoLibraryManager sharedManager].selectedList removeObject:model];
        [[MOPhotoLibraryManager sharedManager].selectedList enumerateObjectsUsingBlock:^(MOAssetModel * _Nonnull selectObj, NSUInteger selectIdx, BOOL * _Nonnull selectStop) {
            if (selectObj.serialNumber > model.serialNumber) {
                selectObj.serialNumber = selectObj.serialNumber - 1;
            }
        }];
        [[MOPhotoLibraryManager sharedManager].selectedList enumerateObjectsUsingBlock:^(MOAssetModel * _Nonnull selectObj, NSUInteger selectIdx, BOOL * _Nonnull selectStop) {
            [self.dataList enumerateObjectsUsingBlock:^(MOAssetModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isEqual:selectObj]) {
                    obj.serialNumber = selectObj.serialNumber;
                    *stop = YES;
                }
            }];
        }];
        model.serialNumber = 0;
    }
    [self.collectionView reloadData];
    if ([MOPhotoLibraryManager sharedManager].selectedCount == 0) {
        [self.navigationBar changeRightTitle:@"下一步"];
    }else {
        NSString *nextText = [NSString stringWithFormat:@"下一步 (%ld)",(long)[MOPhotoLibraryManager sharedManager].selectedCount];
        [self.navigationBar changeRightTitle:nextText];
    }
}

- (void)dealloc {
    [[MOAssetDownloadManager sharedManager] cancelAllImageRequest];
    [[MOAssetDownloadManager sharedManager] reset];
    [[MOPhotoLibraryManager sharedManager] reset];
}


@end
