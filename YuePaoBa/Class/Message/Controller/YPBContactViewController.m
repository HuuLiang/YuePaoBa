//
//  YPBContactViewController.m
//  YuePaoBa
//
//  Created by Sean Yue on 16/1/6.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "YPBContactViewController.h"
#import "YPBContact.h"
#import "YPBContactCell.h"
#import "YPBMessageViewController.h"
#import "YPBUserDetailViewController.h"
#import "YPBVIPEntranceView.h"
#import "YPBVIPPriviledgeViewController.h"

static NSString *const kContactCellReusableIdentifier = @"ContactCellReusableIdentifier";

@interface YPBContactViewController () <UITableViewDataSource,UITableViewSeparatorDelegate>
{
    UITableView *_layoutTableView;
}
@property (nonatomic,retain) NSArray<YPBContact *> *contacts;
@end

@implementation YPBContactViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onMessagePushNotification:)
                                                     name:kMessagePushNotification
                                                   object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _layoutTableView = [[UITableView alloc] init];
    _layoutTableView.delegate = self;
    _layoutTableView.dataSource = self;
    _layoutTableView.hasSectionBorder = YES;
    _layoutTableView.hasRowSeparator = YES;
    _layoutTableView.rowHeight = kScreenHeight * 0.12;
    [_layoutTableView registerClass:[YPBContactCell class] forCellReuseIdentifier:kContactCellReusableIdentifier];
    [self.view addSubview:_layoutTableView];
    {
        [_layoutTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onVIPUpgradeSuccessNotification:) name:kVIPUpgradeSuccessNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self reloadContacts];
}

- (void)reloadContacts {
    self.contacts = [YPBContact allContacts];
    [_layoutTableView reloadData];
}

- (void)onMessagePushNotification:(NSNotification *)notification {
    if ([self isVisibleViewController]) {
        [self reloadContacts];
    }
}

- (void)onVIPUpgradeSuccessNotification:(NSNotification *)notification {
    [[YPBVIPEntranceView VIPEntranceInView:self.view] hide];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource,UITableViewSeparatorDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YPBContactCell *cell = [tableView dequeueReusableCellWithIdentifier:kContactCellReusableIdentifier forIndexPath:indexPath];
    
    if (indexPath.row < self.contacts.count) {
        YPBContact *contact = self.contacts[indexPath.row];
        cell.imageURL = [NSURL URLWithString:contact.logoUrl];
        cell.title = contact.nickName;
        cell.subtitle = contact.recentMessage;
        cell.numberOfNotifications = contact.unreadMessages.unsignedIntegerValue;
        
        @weakify(self);
        cell.avatarTapAction = ^(id obj) {
            @strongify(self);
            YPBUserDetailViewController *detailVC = [[YPBUserDetailViewController alloc] initWithUserId:contact.userId];
            [self.navigationController pushViewController:detailVC animated:YES];
        };
        
        cell.notificationTapAction = ^(id obj) {
            @strongify(self);
            YPBContact *contact = self.contacts[indexPath.row];
            [YPBMessageViewController showMessageWithContact:contact inViewController:self];
        };
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.contacts.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([YPBUtil isVIP]) {
        YPBContact *contact = self.contacts[indexPath.row];
        [YPBMessageViewController showMessageWithContact:contact inViewController:self];
    } else {
        [YPBVIPEntranceView showVIPEntranceInView:self.view canClose:YES withEnterAction:^(id obj) {
            YPBVIPPriviledgeViewController *vipVC = [[YPBVIPPriviledgeViewController alloc] init];
            [self.navigationController pushViewController:vipVC animated:YES];
        }];
    }
    
}

#pragma mark - YPBSideMenuItemDelegate

- (NSString *)badgeValueOfSideMenuItem:(YPBSideMenuItem *)sideMenuItem {
    __block NSUInteger unreadMessages = 0;
    [[YPBContact allContacts] enumerateObjectsUsingBlock:^(YPBContact * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        unreadMessages += obj.unreadMessages.unsignedIntegerValue;
    }];
    
    NSString *badgeValue;
    if (unreadMessages > 99) {
         badgeValue = @"99+";
    } else if (unreadMessages > 0) {
        badgeValue = [NSString stringWithFormat:@"%ld", (unsigned long)unreadMessages];
    }
    return badgeValue;
}
@end
