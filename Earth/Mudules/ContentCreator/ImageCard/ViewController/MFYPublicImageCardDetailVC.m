//
//  MFYPublicImageCardDetailVC.m
//  Earth
//
//  Created by colr on 2020/1/21.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import "MFYPublicImageCardDetailVC.h"
#import "MFYBaseTableView.h"
#import "MFYPrivacyOptionCell.h"
#import "MFYPublicManager.h"
#import "MFYDynamicManager.h"
#import "MFYQiNiuModel.h"
#import "MFYResponseObject.h"


typedef enum : NSUInteger {
    MFYCardPublicType,
    MFYCardPrivacyType,
} MFYCardViewType;

@interface MFYPublicImageCardDetailVC ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic)MFYBaseTableView * mainTable;

@property (assign, nonatomic)MFYCardViewType viewType;

@property (nonatomic, strong)UIButton * publicBtn;

@property (nonatomic, strong)MFYPublicManager * publicManager;

@property (nonatomic, strong)MFYPublishItemModel * itemModel;

@property (nonatomic, strong)UITextField * redField;

@property (nonatomic, strong)UITextField * descField;

@end

@implementation MFYPublicImageCardDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.viewType = MFYCardPublicType;
    [self setupViews];
    [self bindEvents];
}

- (void)setupViews {
    self.navBar.titleLabel.text = @"编辑";
    self.navBar.backgroundColor = wh_colorWithHexString(@"#FF3F70");
    [self.navBar setRightButton:self.publicBtn];
    [self.navBar.leftButton setImage:WHImageNamed(@"ico_arrow_back") forState:UIControlStateNormal];
    [self.view addSubview:self.mainTable];
    [self.mainTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(NAVIGATION_BAR_HEIGHT);
        make.left.right.bottom.mas_equalTo(0);
    }];
}

- (void)bindEvents {
    @weakify(self)
    [[self.navBar.rightButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        [self _uploadToQiniu];
    }];
}

- (void)_uploadToQiniu {
    if (self.itemModel.assetModel == nil) {
        [self.view showString:@"图片不能为空"];
        return;
    }
    self.itemModel.priceAmount = [self.redField.text floatValue];
    self.itemModel.fileDesc = self.descField.text;
    if (self.viewType == MFYCardPrivacyType && self.itemModel.priceAmount <= 0) {
        [self.view showString:@"设置为隐私后，别忘记设置金额呦"];
        return;
    }
    @weakify(self)
    [WHHud showActivityView];
    [MFYDynamicManager UploadTheAssetModel:self.itemModel.assetModel completion:^(MFYQiNiuResponse * model, NSError * error) {
        WHLog(@"%@",model);
        @strongify(self)
        if (model) {
            self.itemModel.fileId = model.storeId;
            self.itemModel.fileType = [MFYPublishItemModel qiNiuMimeTypeChangeMfy:model.mimeType];
            if (self.publishB) {
                self.publishB(self.itemModel);
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
        [WHHud hideActivityView];
    }];
}


#pragma mark- tableView delegate&dataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.viewType == MFYCardPrivacyType){
        return 4;
    }else {
        return 2;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

-(void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    view.tintColor = wh_colorWithHexString(@"#EBEBF5");
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (self.viewType == MFYCardPublicType) {
        if (section == 1) {
            return 0;
        }else{
            return 10;
        }
    }else{
        if (section == 3) {
            return  0;
        }else{
            return 10;
        }
    }
}

- (UITableViewCell *)tableView:(MFYBaseTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 ) {
        if (indexPath.row == 0) {
            MFYPrivacyOptionCell * publicCell = [MFYPrivacyOptionCell mfy_cellWithTableView:tableView type:MFYPrivacyOptionCheckType];
            publicCell.titleLabel.text = @"公开";
            publicCell.checkBtn.selected = self.viewType == MFYCardPublicType;
            @weakify(self)
            publicCell.checkBtnBlock = ^{
                @strongify(self)
                if (self.viewType == MFYCardPrivacyType) {
                    self.viewType = MFYCardPublicType;
                    [self.mainTable reloadData];
                }
            };
            return publicCell;
        }else{
            MFYPrivacyOptionCell * privacyCell = [MFYPrivacyOptionCell mfy_cellWithTableView:tableView type:MFYPrivacyOptionCheckType];
            privacyCell.titleLabel.text = @"私密";
            privacyCell.checkBtn.selected = self.viewType == MFYCardPrivacyType;
            @weakify(self)
            privacyCell.checkBtnBlock = ^{
                @strongify(self)
                if (self.isBig) {
                    [WHHud showString:@"大图不可以设置为私密"];
                    return ;
                }
                if (self.viewType == MFYCardPublicType) {
                    self.viewType = MFYCardPrivacyType;
                    [self.mainTable reloadData];
                }
            };
            return privacyCell;
        }
    }else if (indexPath.section == 1){
        if (self.viewType == MFYCardPublicType){
            if (indexPath.row == 0) {
                MFYPrivacyOptionCell * titleCell = [MFYPrivacyOptionCell mfy_cellWithTableView:tableView type:MFYPrivacyOptionTextType];
                titleCell.titleLabel.text = @"上传图片/视频";
                return titleCell;
            }else{
                MFYPrivacyOptionCell * videoCell = [MFYPrivacyOptionCell mfy_cellWithTableView:tableView type:MFYPrivacyOptionImageType];
                @weakify(self)
                @weakify(videoCell)
                [videoCell setAddPhotoBlock:^{
                    @strongify(self)
                    [self.publicManager publishPhotoFromVC:self publishType:mfyPublicTypeNull completion:^(MFYAssetModel * _Nullable model) {
                        @strongify(videoCell)
                        if (model) {
                            self.itemModel.assetModel = model;
                            [videoCell.videoView setImageData:model];
                        }
                    }];
                }];
                return videoCell;
            }
        }else {
            if (indexPath.row == 0) {
                MFYPrivacyOptionCell * titleCell = [MFYPrivacyOptionCell mfy_cellWithTableView:tableView type:MFYPrivacyOptionTextType];
                titleCell.titleLabel.text = @"查看方式";
                return titleCell;
            }else{
                MFYPrivacyOptionCell * redCell = [MFYPrivacyOptionCell mfy_cellWithTableView:tableView type:MFYPrivacyOptionRedEnvelopeType];
                self.redField = redCell.redField;
                return  redCell;
            }
        }
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            MFYPrivacyOptionCell * titleCell = [MFYPrivacyOptionCell mfy_cellWithTableView:tableView type:MFYPrivacyOptionTextType];
            titleCell.titleLabel.text = @"标题";
            return titleCell;
        }else {
            MFYPrivacyOptionCell * titleFieldCell = [MFYPrivacyOptionCell mfy_cellWithTableView:tableView type:MFYPrivacyOptionTitleType];
            self.descField = titleFieldCell.titleField;
            return titleFieldCell;
        }
    }else{
        if (indexPath.row == 0) {
             MFYPrivacyOptionCell * titleCell = [MFYPrivacyOptionCell mfy_cellWithTableView:tableView type:MFYPrivacyOptionTextType];
             titleCell.titleLabel.text = @"上传图片/视频";
             return titleCell;
         }else{
             MFYPrivacyOptionCell * videoCell = [MFYPrivacyOptionCell mfy_cellWithTableView:tableView type:MFYPrivacyOptionImageType];
             @weakify(self)
             @weakify(videoCell)
             [videoCell setAddPhotoBlock:^{
                 @strongify(self)
                 [self.publicManager publishPhotoFromVC:self publishType:mfyPublicTypeNull completion:^(MFYAssetModel * _Nullable model) {
                     @strongify(videoCell)
                     if (model) {
                         self.itemModel.assetModel = model;
                         [videoCell.videoView setImageData:model];
                     }
                 }];
             }];

             return videoCell;
         }
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.viewType == MFYCardPrivacyType){
        if (indexPath.section == 3 && indexPath.row == 1) {
            return 180;
        }else{
            return 52;
        }
    }else {
        if (indexPath.section == 1 && indexPath.row == 1) {
            return 180;
        }else{
            return 52;
        }
    }
}


- (MFYBaseTableView *)mainTable {
    if (!_mainTable) {
        _mainTable = [[MFYBaseTableView alloc]init];
        _mainTable.delegate = self;
        _mainTable.dataSource = self;
        _mainTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _mainTable.separatorColor = wh_colorWithHexString(@"#EBEBF5");
        _mainTable.backgroundColor = [UIColor whiteColor];
    }
    return  _mainTable;
}

- (UIButton *)publicBtn {
    if (!_publicBtn) {
        _publicBtn = UIButton.button.WH_setTitle_forState(@"上传",UIControlStateNormal).WH_setTitleColor_forState([UIColor whiteColor],UIControlStateNormal);
    }
    return _publicBtn;
}

- (MFYPublicManager *)publicManager {
    if (!_publicManager) {
        _publicManager = [[MFYPublicManager alloc]init];
    }
    return  _publicManager;
}

- (MFYPublishItemModel *)itemModel {
    if (!_itemModel) {
        _itemModel = [[MFYPublishItemModel alloc]init];
    }
    return _itemModel;
}


@end
