//
//  MFYPublicImageCardVC.m
//  Earth
//
//  Created by colr on 2020/1/19.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import "MFYPublicImageCardVC.h"
#import "MFYVideoAndImageView.h"
#import "MFYPublicImageCardDetailVC.h"
#import "MFYPublishModel.h"
#import "MFYDynamicManager.h"
#import "MFYPublicManager.h"

typedef NS_ENUM(NSUInteger, MFYImageViewType) {
    MFYBigViewType,
    MFYTopSmallViewType,
    MFYBottomSmallViewType,
};

@interface MFYPublicImageCardVC ()<UITextFieldDelegate>

@property (nonatomic, strong)UIButton * publicBtn;

@property (nonatomic, strong)UIScrollView * mainScroll;

@property (nonatomic, strong)UIView * contentView;

@property (nonatomic, strong)UITextField * titleField;

@property (nonatomic, strong)UIView * lineView;

@property (nonatomic, strong)UIView * backView;

@property (nonatomic, strong)MFYVideoAndImageView * bigView;

@property (nonatomic, strong)MFYVideoAndImageView * topSmallView;

@property (nonatomic, strong)MFYVideoAndImageView * bottomSmallView;

@property (nonatomic, strong)MFYPublishModel * publishModel;

@property (nonatomic, strong)MFYPublicManager * publicManager;


@end

@implementation MFYPublicImageCardVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
    [self setupConstraint];
    [self bindEvents];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.titleField resignFirstResponder];
}

- (void)setupViews {
    self.navBar.titleLabel.text = @"颜控";
    self.navBar.backgroundColor = wh_colorWithHexString(@"#FF3F70");
    [self.navBar setRightButton:self.publicBtn];
    [self.navBar.leftButton setImage:WHImageNamed(@"ico_arrow_back") forState:UIControlStateNormal];
    
    [self.view addSubview:self.mainScroll];
    [self.mainScroll addSubview:self.contentView];
    [self.contentView addSubview:self.titleField];
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.backView];
    [self.backView addSubview:self.bigView];
    [self.backView addSubview:self.topSmallView];
    [self.backView addSubview:self.bottomSmallView];
    
    if (@available(iOS 11.0, *)) {
        self.mainScroll.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (void)setupConstraint {
    [self.mainScroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(NAVIGATION_BAR_HEIGHT);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-HOME_INDICATOR_HEIGHT);
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.mainScroll);
        make.width.mas_equalTo(VERTICAL_SCREEN_WIDTH);
        make.bottom.equalTo(self.backView.mas_bottom).offset(10);
    }];
    
    [self.titleField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
        make.height.mas_equalTo(40);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.titleField);
        make.top.mas_equalTo(self.titleField.mas_bottom).offset(2);
        make.height.mas_equalTo(1);
    }];
    
    CGFloat itemW = ( VERTICAL_SCREEN_WIDTH - 27) / 3;
    CGFloat itemH = itemW * 4 / 3;
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.lineView.mas_bottom).offset(20);
        make.left.right.equalTo(self.lineView);
        make.height.mas_equalTo(2 * itemH + 3);
    }];
    
    [self.bigView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(self.backView).offset(1);
        make.size.mas_equalTo(CGSizeMake(itemW * 2, itemH * 2 + 1));
    }];
    
    [self.topSmallView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.backView).offset(1);
        make.right.mas_equalTo(self.backView).offset(-1);
        make.size.mas_equalTo(CGSizeMake(itemW, itemH));
    }];
    
    [self.bottomSmallView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.mas_equalTo(self.backView).offset(-1);
        make.size.mas_equalTo(CGSizeMake(itemW, itemH));
    }];
}

- (void)bindEvents {
    @weakify(self)
    [[self.publicBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        if (self.titleField.text.length < 1) {
            [self.view showString:@"请输入描述"];
            return ;
        }
        if ([self.publishModel unVerify]) {
            [self.view showString:@"请至少上传一张图片"];
            return;
        }
        self.publishModel.title = self.titleField.text;
        self.publishModel.topicId = self.topicId;
        [MFYDynamicManager publishTheArticle:self.publishModel completion:^(MFYArticle * article, NSError * error) {
            if (article != nil) {
                [WHHud showString:@"发布成功"];
                //发布成功的通知
                [[NSNotificationCenter defaultCenter] postNotificationName:MFYNotificationPublishImageSuccess object:nil];
                [self dismissViewControllerAnimated:YES completion:NULL];
            }
        }];
    
    }];
}

- (void)backButtonAction:(UIButton *)button {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *) textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.titleField) {
        NSUInteger oldLength = [textField.text length];
        NSUInteger replacementLength = [string length];
        NSUInteger rangeLength = range.length;
        NSUInteger newLength = oldLength - rangeLength + replacementLength;
        BOOL returnKey = [string rangeOfString: @"\n"].location != NSNotFound;
        return newLength <= 20 || returnKey;
    }
    return NO;
}

#pragma mark- 选图发帖
- (void)tapToSlecetedPicType:(MFYImageViewType)type {
    @weakify(self)
    [self.publicManager publishPhotoFromVC:self publishType:mfyPublicTypeNull completion:^(MFYAssetModel * _Nullable model) {
        if (model) {
            @strongify(self)
            MFYPublicImageCardDetailVC * detailVC = [[MFYPublicImageCardDetailVC alloc]init];
            detailVC.isBig = type == MFYBigViewType;
            detailVC.itemModel.assetModel = model;
            detailVC.publishB = ^(MFYPublishItemModel * _Nullable itemModel) {
                @strongify(self)
                [self setupImageDataWithType:type itemModel:itemModel];
            };
            [self.navigationController pushViewController:detailVC animated:YES];
        }
    }];
}

- (void)setupImageDataWithType:(MFYImageViewType)type itemModel:(MFYPublishItemModel*)itemModel{
    switch (type) {
        case MFYBigViewType:
            self.publishModel.bigitem = itemModel;
            [self.bigView setImageData:itemModel.assetModel];
            break;
        case MFYTopSmallViewType:
            self.publishModel.smallTopItem = itemModel;
            [self.topSmallView setImageData:itemModel.assetModel];
            break;
        case MFYBottomSmallViewType:
            self.publishModel.smallBottomItem = itemModel;
            [self.bottomSmallView setImageData:itemModel.assetModel];
            break;
        default:
            break;
    }
}


- (UIScrollView *)mainScroll {
    if (!_mainScroll) {
        _mainScroll = [[UIScrollView alloc]init];
        _mainScroll.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    }
    return _mainScroll;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc]init];
    }
    return _contentView;
}

- (UITextField *)titleField {
    if (!_titleField) {
        _titleField = [[UITextField alloc]init];
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"请输入自我介绍" attributes:@{NSForegroundColorAttributeName:wh_colorWithHexString(@"#939499"),
               NSFontAttributeName:WHFont(16)
               }];
        _titleField.attributedPlaceholder = attrString;
        _titleField.textColor = wh_colorWithHexString(@"333333");
        _titleField.tintColor = wh_colorWithHexString(@"333333");
        _titleField.delegate = self;
    }
    return _titleField;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = wh_colorWithHexString(@"#F0F1F5");
    }
    return _lineView;
}

- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc]init];
        _backView.backgroundColor = UIColor.whiteColor;
    }
    return  _backView;
}

- (MFYVideoAndImageView *)bigView {
    if (!_bigView) {
        _bigView = [[MFYVideoAndImageView alloc]initWithType:MFYVideoAndImageViewBigType];
        @weakify(self);
        _bigView.tapAddBlock = ^{
            @strongify(self)
            [self tapToSlecetedPicType:MFYBigViewType];
        };
    }
    return _bigView;
}

- (MFYVideoAndImageView *)topSmallView {
    if (!_topSmallView) {
        _topSmallView = [[MFYVideoAndImageView alloc]initWithType:MFYVideoAndImageViewSmallType];
        @weakify(self)
        _topSmallView.tapAddBlock = ^{
            @strongify(self)
            [self tapToSlecetedPicType:MFYTopSmallViewType];
        };
    }
    return _topSmallView;
}

- (MFYVideoAndImageView *)bottomSmallView {
    if (!_bottomSmallView) {
        _bottomSmallView = [[MFYVideoAndImageView alloc]initWithType:MFYVideoAndImageViewSmallType];
        @weakify(self)
        _bottomSmallView.tapAddBlock = ^{
            @strongify(self)
            [self tapToSlecetedPicType:MFYBottomSmallViewType];
        };
    }
    return _bottomSmallView;
}

- (UIButton *)publicBtn {
    if (!_publicBtn) {
        _publicBtn = UIButton.button.WH_setTitle_forState(@"发布",UIControlStateNormal).WH_setTitleColor_forState([UIColor whiteColor],UIControlStateNormal);
    }
    return _publicBtn;
}

- (MFYPublishModel *)publishModel {
    if (!_publishModel) {
        _publishModel = [[MFYPublishModel alloc]init];
    }
    return _publishModel;
}

- (MFYPublicManager *)publicManager {
    if (!_publicManager) {
        _publicManager = [[MFYPublicManager alloc]init];
    }
    return  _publicManager;
}



@end
