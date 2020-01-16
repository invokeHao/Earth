//
//  MFYFlowListVM.m
//  Earth
//
//  Created by colr on 2019/12/27.
//  Copyright © 2019 fuYin. All rights reserved.
//

#import "MFYFlowListVM.h"

@interface MFYFlowListVM()

@property (nonatomic, strong) NSMutableArray<MFYRow *> * dataList;

@end

@implementation MFYFlowListVM

-(instancetype)init {
    self = [super init];
    if (self) {
        [self setupData];
    }
    return self;
}

-(void)setupData {
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *path = [bundle pathForResource:@"coreFlowList" ofType:@"plist"];
    NSDictionary * dic  = [NSDictionary dictionaryWithContentsOfFile:path];
    NSArray * resultArr = dic[@"rows"];
    for (NSDictionary * dic in resultArr) {
        MFYRow * row = [[MFYRow alloc]initWithDictionary:dic];
        [self.dataList addObject:row];
    }
}

- (NSMutableArray<MFYRow *> *)dataList {
    if (!_dataList) {
        _dataList = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataList;
}

@end
