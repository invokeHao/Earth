//
//  MFYChatMayKnowVC.m
//  Earth
//
//  Created by colr on 2020/3/12.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import "MFYChatMayKnowVC.h"
#import "MFYBaseTableView.h"
#import "MFYChatListVM.h"
#import "MFYChatFriendCell.h"
#import "MFYSingleChatVC.h"

@interface MFYChatMayKnowVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)MFYBaseTableView * mainTable;

@property (nonatomic, strong)MFYChatListVM * viewModel;

@end

@implementation MFYChatMayKnowVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
    [self bindEvents];
    [self bindData];
}

- (void)setupViews {
    self.navBar.backgroundColor = wh_colorWithHexString(@"#FF3F70");
    self.navBar.titleLabel.text = @"可能认识";
    
    [self.view addSubview:self.mainTable];
    [self.mainTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(NAVIGATION_BAR_HEIGHT);
        make.left.right.bottom.mas_equalTo(0);
    }];
}

- (void)bindEvents {
    
}

- (void)bindData {
    self.viewModel = [[MFYChatListVM alloc]initWithType:MFYChatListMayKnowType];
    @weakify(self)
    RACSignal * dataObserve = RACObserve(self, viewModel.userList);
    
    [[[dataObserve skipUntilBlock:^BOOL(id x) {
        @strongify(self)
        return self.viewModel.userList.count > 0;
    }] deliverOnMainThread] subscribeNext:^(id x) {
        @strongify(self)
        [self.mainTable reloadData];
    }];
}


#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.userList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (UITableViewCell *)tableView:(MFYBaseTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MFYChatFriendCell * cell = [tableView dequeueReusableCellWithIdentifier:[MFYChatFriendCell reuseID]];
    if (!cell) {
        cell = [MFYChatFriendCell mfy_cellWithTableView:tableView];
    }
    MFYProfile * profile = [self.viewModel.userList objectAtIndex:indexPath.row];
    [cell setProfile:profile];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MFYProfile *profile = [self.viewModel.userList objectAtIndex:indexPath.row];
    MFYSingleChatVC * singleChatVC = [[MFYSingleChatVC alloc]init];
    singleChatVC.userProfile = profile;
    [JMSGConversation createSingleConversationWithUsername:profile.imId appKey:JMESSAGE_APPKEY completionHandler:^(id resultObject, NSError *error) {
        if (!error) {
            singleChatVC.conversation = resultObject;
            [self.navigationController pushViewController:singleChatVC animated:YES];
        }
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75;
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view {
    
}


- (MFYBaseTableView *)mainTable {
    if (!_mainTable) {
        _mainTable = [[MFYBaseTableView alloc]init];
        _mainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTable.backgroundColor = [UIColor clearColor];
        _mainTable.delegate = self;
        _mainTable.dataSource = self;
    }
    return _mainTable;
}




@end
