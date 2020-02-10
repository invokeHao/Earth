//
//  MOPhotoLibraryExportCenter.h
//  PhotoLibraryKit
//
//  Created by colr on 2018/6/11.
//  Copyright © 2018年 colr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYImage.h>

@interface MOPhotoLibraryExportCenter : NSObject

- (void)exportPhotoLibrary:(void (^)(NSArray<YYImage *> *))completion;

@end
