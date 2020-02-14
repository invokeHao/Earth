//
//  MFYItem.h
//  Earth
//
//  Created by colr on 2020/2/11.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MFYMedia.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, MFYMediaType) {
    MFYMediaPictureType = 1,
    MFYMediaAudioType,
    MFYMediavideoType
};

@interface MFYItem : NSObject

@property (nonatomic, strong) NSString * articleId;
@property (nonatomic, strong) NSString * bodyText;
@property (nonatomic, assign) NSInteger createDate;
@property (nonatomic, strong) NSArray * embeddedArticles;
@property (nonatomic, assign) NSInteger formatType;
@property (nonatomic, assign) NSInteger functionType;
@property (nonatomic, strong) MFYMedia * media;
@property (nonatomic, assign) NSInteger postType;
@property (nonatomic, assign) CGFloat priceAmount;


//业务字段
@property (nonatomic, assign) BOOL isbig; //判断是否为大图

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;

- (MFYMediaType)mediaType;

@end

NS_ASSUME_NONNULL_END
