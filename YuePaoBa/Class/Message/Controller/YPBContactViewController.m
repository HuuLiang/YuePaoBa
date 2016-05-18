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
#import "YPBChatMessage.h"

static NSString *const kContactCellReusableIdentifier = @"ContactCellReusableIdentifier";


@interface YPBContactViewController () <UITableViewDataSource,UITableViewSeparatorDelegate>
{
    UITableView *_layoutTableView;
    BOOL isHaveRobot;
}
@property (nonatomic,retain) NSMutableArray<YPBContact *> *contacts;
@property (nonatomic,retain) NSMutableArray<YPBChatMessage *> *chatMessages;

@end

@implementation YPBContactViewController

DefineLazyPropertyInitialization(NSMutableArray, chatMessages)
DefineLazyPropertyInitialization(NSMutableArray, contacts);

- (instancetype)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onMessagePushNotification:)
                                                     name:kMessagePushNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onUnreadMessageChangeNotification)
                                                     name:kUnreadMessageChangeNotification
                                                   object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    isHaveRobot = NO;
    _layoutTableView = [[UITableView alloc] init];
    _layoutTableView.delegate = self;
    _layoutTableView.dataSource = self;
    _layoutTableView.hasSectionBorder = YES;
    _layoutTableView.hasRowSeparator = YES;
    _layoutTableView.rowHeight = MAX(kScreenHeight * 0.12,60);
    [_layoutTableView registerClass:[YPBContactCell class] forCellReuseIdentifier:kContactCellReusableIdentifier];
    [self.view addSubview:_layoutTableView];
    {
        [_layoutTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    
    if (!self.contacts) {
        [self reloadContactsWithUIReload:YES];
    }
    
    @weakify(self);
    [_layoutTableView YPB_addPullToRefreshWithHandler:^{
        @strongify(self);
        if (!self) {
            return ;
        }
        
        [self reloadContactsWithUIReload:YES];
        [self->_layoutTableView YPB_endPullToRefresh];
    }];
    
    [self reloadContactsWithUIReload:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onVIPUpgradeSuccessNotification:) name:kVIPUpgradeSuccessNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (!self.isMovingToParentViewController) {
        [self reloadContactsWithUIReload:YES];
    }
}

- (void)reloadContactsWithUIReload:(BOOL)reloadUI {
    self.contacts = [NSMutableArray arrayWithArray:[YPBContact allContacts]];
    
    __block NSUInteger unreadMessages = 0;
    [self.contacts enumerateObjectsUsingBlock:^(YPBContact * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        unreadMessages += obj.unreadMessages.unsignedIntegerValue;
        if ([obj.userType isEqualToNumber:[NSNumber numberWithInteger:76839]]) {
            isHaveRobot = YES;
            if ([self.contacts indexOfObject:obj] != 0) {
                [self.contacts exchangeObjectAtIndex:0 withObjectAtIndex:[self.contacts indexOfObject:obj]];
            }
        }
    }];
    //添加红娘小助手
    if (!isHaveRobot) {
        YPBContact *robotContact = [[YPBContact alloc] init];
        robotContact.userId = YPBROBOTID;
        robotContact.logoUrl = kRobotContactLogoUrl;
        robotContact.nickName = @"红娘小助手";
        robotContact.userType = [NSNumber numberWithInteger:[YPBROBOTID integerValue]];
        robotContact.recentMessage = @"欢迎来到心动速配";
        robotContact.recentTime = [YPBUtil stringFromDate:[NSDate date]];
        [robotContact persist];
        [self.contacts addObject:robotContact];
        
        [YPBMessageViewController sendSystemMessageWith:robotContact Type:YPBRobotPushTypeWelCome count:0 inViewController:self];
//        [_layoutTableView reloadData];
        isHaveRobot = YES;
    }
    
    if (unreadMessages > 0) {
        if (unreadMessages < 100) {
            self.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld", (unsigned long)unreadMessages];
        } else {
            self.navigationController.tabBarItem.badgeValue = @"99+";
        }
    } else {
        self.navigationController.tabBarItem.badgeValue = nil;
    }
    
    if (reloadUI) {
        [_layoutTableView reloadData];
    }
}

- (void)onMessagePushNotification:(NSNotification *)notification {
    [self reloadContactsWithUIReload:NO];
}

- (void)onUnreadMessageChangeNotification {
    
}

- (void)onVIPUpgradeSuccessNotification:(NSNotification *)notification {
    //[[YPBVIPEntranceView VIPEntranceInView:self.view] hide];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource,UITableViewSeparatorDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YPBContactCell *cell = [tableView dequeueReusableCellWithIdentifier:kContactCellReusableIdentifier forIndexPath:indexPath];
//    [self.chatMessages removeAllObjects];
    

    if (indexPath.row < self.contacts.count) {
        YPBContact *contact = self.contacts[indexPath.row];
        
//        self.chatMessages = [YPBChatMessage allMessagesForUser:contact.userId].mutableCopy;
//        YPBChatMessage *recentMessage = self.chatMessages.lastObject;
        DLog("%@",contact.userType);
        cell.imageURL = [NSURL URLWithString:contact.logoUrl];
        cell.title = contact.nickName;
//        cell.subtitle = recentMessage.msg;
        cell.subtitle = contact.recentMessage;
        cell.numberOfNotifications = contact.unreadMessages.unsignedIntegerValue;
        
        @weakify(self);
        cell.avatarTapAction = ^(id obj) {
            @strongify(self);
            if (![contact.userType isEqualToNumber:[NSNumber numberWithInteger:[YPBROBOTID integerValue]]]) {
                YPBUserDetailViewController *detailVC = [[YPBUserDetailViewController alloc] initWithUserId:contact.userId];
                [self.navigationController pushViewController:detailVC animated:YES];
            }
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
    
//    if ([YPBUtil isVIP]) {
        YPBContact *contact = self.contacts[indexPath.row];
        [YPBMessageViewController showMessageWithContact:contact inViewController:self];
//    } else {
////        [YPBVIPEntranceView showVIPEntranceInView:self.view canClose:YES withEnterAction:^(id obj) {
//            YPBVIPPriviledgeViewController *vipVC = [[YPBVIPPriviledgeViewController alloc] init];
//            [self.navigationController pushViewController:vipVC animated:YES];
////        }];
//    }
    
}
@end
