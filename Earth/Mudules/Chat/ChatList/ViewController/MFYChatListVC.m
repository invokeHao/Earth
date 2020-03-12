//
//  MFYChatListVC.m
//  Earth
//
//  Created by colr on 2020/3/6.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import "MFYChatListVC.h"
#import "MFYBaseTableView.h"
#import "MFYChatSearchView.h"
#import "MFYChatFriendCell.h"
#import "MFYChatListVM.h"
#import "MFYSingleChatVC.h"
#import "MFYChatSearchFriendVC.h"
#import "MFYChatMayKnowVC.h"

@interface MFYChatListVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)MFYBaseTableView * mainTable;

@property (nonatomic, strong)MFYChatSearchView * searchView;

@property (nonatomic, strong)MFYChatListVM * viewModel;

@property (nonatomic, strong)UIButton * mayKnowBtn;

@end

@implementation MFYChatListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
    [self bindEvents];
    [self bindData];
}

- (void)setupViews {
    self.navBar.backgroundColor = wh_colorWithHexString(@"#FF3F70");
    self.navBar.titleLabel.text = @"消息";
    self.navBar.rightButton = self.mayKnowBtn;
    
    [self.view addSubview:self.mainTable];
    [self.mainTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(NAVIGATION_BAR_HEIGHT);
        make.left.right.bottom.mas_equalTo(0);
    }];
}

- (void)bindEvents {
    self.viewModel = [[MFYChatListVM alloc]initWithType:MFYChatListFriendsType];
    @weakify(self)
    [[self.mayKnowBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        MFYChatMayKnowVC * mayKnowVC = [[MFYChatMayKnowVC alloc]init];
        [self.navigationController pushViewController:mayKnowVC animated:YES];
    }];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]init];
    [[tap rac_gestureSignal] subscribeNext:^(id x) {
        @strongify(self)
        MFYChatSearchFriendVC * chatSearchVC = [[MFYChatSearchFriendVC alloc]init];
        [self.navigationController pushViewController:chatSearchVC animated:NO];
    }];
    [self.searchView addGestureRecognizer:tap];
    
}

- (void)bindData {
    @weakify(self)
    RACSignal * dataObserve = RACObserve(self, viewModel.dataList);
    
    [[[dataObserve skipUntilBlock:^BOOL(id x) {
        @strongify(self)
        return self.viewModel.dataList.count > 0;
    }] deliverOnMainThread] subscribeNext:^(id x) {
        @strongify(self)
        [self.mainTable reloadData];
    }];
}


#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.dataList.count;
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
    JMSGConversation * conversation = [self.viewModel.dataList objectAtIndex:indexPath.row];
    [cell setConversation:conversation];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MFYSingleChatVC * singleChatVC = [[MFYSingleChatVC alloc]init];
    JMSGConversation *conversation = [self.viewModel.dataList objectAtIndex:indexPath.row];
    singleChatVC.conversation = conversation;
    singleChatVC.userProfile.nickname = conversation.title;
    [self.navigationController pushViewController:singleChatVC animated:YES];
     
//     NSInteger badge = _unreadCount - [conversation.unreadCount integerValue];
//     [self saveBadge:badge];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75;
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view {
    
}

/**
 *  左滑cell时出现什么按钮
 */
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JMSGConversation *conversation = [self.viewModel.dataList objectAtIndex:indexPath.row];
    NSString * titleStr = conversation.isTop? @"取消置顶" : @"置顶";
    UITableViewRowAction *action0 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:titleStr handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        // 收回左滑出现的按钮(退出编辑模式)
        if (conversation.isTop) {
            [self.viewModel deleteTheTopChat:conversation];
        }else {
            [self.viewModel addChatTop:conversation];
        }
        tableView.editing = NO;
    }];
    UITableViewRowAction *action1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        JMSGConversation *conversation = [self.viewModel.dataList objectAtIndex:indexPath.row];
        [JMSGConversation deleteSingleConversationWithUsername:((JMSGUser *)conversation.target).username appKey:JMESSAGE_APPKEY];
        [self.viewModel.dataList removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }];

    return @[action1, action0];
}

- (MFYBaseTableView *)mainTable {
    if (!_mainTable) {
        _mainTable = [[MFYBaseTableView alloc]init];
        _mainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTable.backgroundColor = [UIColor clearColor];
        _mainTable.tableHeaderView = self.searchView;
        _mainTable.delegate = self;
        _mainTable.dataSource = self;
    }
    return _mainTable;
}

- (MFYChatSearchView *)searchView {
    if (!_searchView) {
        _searchView = [[MFYChatSearchView alloc]initWithFrame:CGRectMake(0, 0, VERTICAL_SCREEN_WIDTH, 70)];
        _searchView.textField.enabled = NO;
    }
    return _searchView;
}

- (UIButton *)mayKnowBtn {
    if (!_mayKnowBtn) {
        _mayKnowBtn = UIButton.button.WH_setImage_forState(WHImageNamed(@"chat_mayKnow"),UIControlStateNormal);
    }
    return _mayKnowBtn;
}

@end
