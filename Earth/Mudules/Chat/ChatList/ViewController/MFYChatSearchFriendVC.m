//
//  MFYChatSearchFriendVC.m
//  Earth
//
//  Created by colr on 2020/3/11.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import "MFYChatSearchFriendVC.h"
#import "MFYBaseTableView.h"
#import "MFYChatSearchTopView.h"
#import "MFYChatFriendCell.h"
#import "MFYSingleChatVC.h"
#import "MFYChatListVM.h"

@interface MFYChatSearchFriendVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)MFYBaseTableView * mainTable;

@property (nonatomic, strong)MFYChatSearchTopView * TopView;

@property (nonatomic, strong)MFYChatListVM * viewModel;

@end

@implementation MFYChatSearchFriendVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
    [self bindEvents];
    [self dataBind];
}

- (void)setupViews {
    self.navBar.hidden = YES;
    [self.view addSubview:self.TopView];
    [self.view addSubview:self.mainTable];
    
    [self.TopView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(STATUS_BAR_HEIGHT);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(150);
    }];
    
    [self.mainTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.TopView.mas_bottom).offset(15);
        make.left.right.bottom.mas_equalTo(0);
    }];
    
    [self.TopView.searchView.textField becomeFirstResponder];
}

- (void)bindEvents {
    @weakify(self)
    [self.TopView searchAction:^(NSString * _Nonnull keywork) {
        @strongify(self)
        [self.viewModel searchTheFriendWithKeyWord:keywork];
    } cancelAction:^{
        @strongify(self)
        [self.navigationController popViewControllerAnimated:NO];
    }];
}

- (void)dataBind {
    self.viewModel = [[MFYChatListVM alloc]initWithType:MFYChatListSearchType];
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


- (MFYChatSearchTopView *)TopView {
    if (!_TopView) {
        _TopView = [[MFYChatSearchTopView alloc]init];
    }
    return _TopView;
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
