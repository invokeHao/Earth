//
//  MFYPrivacyOptionCell.h
//  Earth
//
//  Created by colr on 2020/1/21.
//  Copyright © 2020 fuYin. All rights reserved.
//

typedef enum : NSUInteger {
    MFYPrivacyOptionTextType,
    MFYPrivacyOptionCheckType,
    MFYPrivacyOptionRedEnvelopeType,
    MFYPrivacyOptionTitleType,
    MFYPrivacyOptionImageType
} MFYPrivacyOptionType;

#import "MFYBaseTableViewCell.h"
#import "MFYVideoAndImageView.h"

NS_ASSUME_NONNULL_BEGIN

@interface MFYPrivacyOptionCell : MFYBaseTableViewCell

@property (strong, nonatomic)UILabel * titleLabel;

@property (strong, nonatomic)UIButton * checkBtn;

@property (strong, nonatomic)UITextField * redField;

@property (strong, nonatomic)UITextField * titleField;

@property (strong, nonatomic)UILabel * tipsLabel;

@property (strong, nonatomic)MFYVideoAndImageView * videoView;

@property (copy, nonatomic) void(^checkBtnBlock)(void);

@property (copy, nonatomic) void(^addPhotoBlock)(void);

+ (MFYPrivacyOptionCell *)mfy_cellWithTableView:(MFYBaseTableView *)tableView type:(MFYPrivacyOptionType)type;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier type:(MFYPrivacyOptionType)type;

@end

NS_ASSUME_NONNULL_END
