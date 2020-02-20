//
//  MFYMineHpVM.m
//  Earth
//
//  Created by colr on 2020/2/19.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import "MFYMineHpVM.h"
#import "MFYMineService.h"

@interface MFYMineHpVM ()

@property (nonatomic, strong) MFYProfile *profile;

@end

@implementation MFYMineHpVM

- (instancetype)init {
    self = [super init];
    if (self) {
        [self refreshData];
    }
    return self;
}

- (void)refreshData {
    [MFYMineService getSelfDetailInfoCompletion:^(MFYProfile * _Nonnull profile, NSError * _Nonnull error) {
        if (profile) {
            self.profile = profile;
        }
        if (error) {
            [WHHud showString:error.descriptionFromServer];
        }
    }];
}

@end
