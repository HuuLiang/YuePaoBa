//
//  YPBMineViewController.m
//  YuePaoBa
//
//  Created by Sean Yue on 15/12/3.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import "YPBMineViewController.h"
#import "YPBAvatarView.h"
#import "YPBMineProfileCell.h"
#import "YPBReceivedGreetingViewController.h"
#import "YPBSentGreetingViewController.h"
#import "YPBAccessedViewController.h"
#import "YPBUserDetailModel.h"

@interface YPBMineViewController ()
@property (nonatomic,retain) YPBAvatarView *sideMenuAvatarView;
@property (nonatomic,retain) YPBMineProfileCell *profileCell;
@end

@implementation YPBMineViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onCurrentUserChange) name:kCurrentUserChangeNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.layoutTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"VIP特权"
                                                                                 style:UIBarButtonItemStylePlain
                                                                               handler:^(id sender)
    {
        
    }];
    
    [self initLayoutCells];
}

- (void)initLayoutCells {
    [self setLayoutCell:self.profileCell cellHeight:kScreenWidth/1.5 inRow:0 andSection:0];
}

- (YPBMineProfileCell *)profileCell {
    if (_profileCell) {
        return _profileCell;
    }
    
    @weakify(self);
    _profileCell = [[YPBMineProfileCell alloc] init];
    _profileCell.viewFollowedAction = ^{
        @strongify(self);
        YPBReceivedGreetingViewController *recvVC = [[YPBReceivedGreetingViewController alloc] init];
        [self.navigationController pushViewController:recvVC animated:YES];
    };
    _profileCell.viewFollowingAction = ^{
        @strongify(self);
        YPBSentGreetingViewController *recvVC = [[YPBSentGreetingViewController alloc] init];
        [self.navigationController pushViewController:recvVC animated:YES];
    };
    _profileCell.viewAccessedAction = ^{
        @strongify(self);
        YPBAccessedViewController *recvVC = [[YPBAccessedViewController alloc] init];
        [self.navigationController pushViewController:recvVC animated:YES];
    };
    return _profileCell;
}

- (YPBAvatarView *)sideMenuAvatarView {
    if (_sideMenuAvatarView) {
        return _sideMenuAvatarView;
    }
    
//    _sideMenuAvatarView = [[YPBAvatarView alloc] initWithName:@"美丽"
//                                                     imageURL:[NSURL URLWithString:@"http://v1.qzone.cc/avatar/201403/01/10/36/531147afa4197738.jpg%21200x200.jpg"]
//                                                        isVIP:YES];
    _sideMenuAvatarView = [[YPBAvatarView alloc] init];
    @weakify(self);
    [_sideMenuAvatarView bk_whenTapped:^{
        @strongify(self);
        
        [[YPBUtil sideMenuViewController] hideMenuViewController];
        [[YPBUtil sideMenuViewController] setContentViewController:self.navigationController animated:YES];
    }];
    return _sideMenuAvatarView;
}

- (void)onCurrentUserChange {
    self.sideMenuAvatarView.imageURL = [NSURL URLWithString:[YPBUser currentUser].logoUrl];
    self.sideMenuAvatarView.name = [YPBUser currentUser].nickName;
    self.sideMenuAvatarView.isVIP = [YPBUser currentUser].isVip;
    self.profileCell.name = [YPBUser currentUser].nickName;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - YPBSideMenuItemDelegate

- (void)sideMenuController:(UIViewController *)viewController willAddToSideMenuCell:(UITableViewCell *)cell {
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    @weakify(viewController,self);
    self.sideMenuAvatarView.avatarImageLoadHandler = ^(UIImage *image) {
        @strongify(viewController,self);
        viewController.backgroundImageView.image = image;
        self.profileCell.avatarImage = image;
    };
    
    if (![cell.subviews containsObject:self.sideMenuAvatarView]) {
        [cell addSubview:self.sideMenuAvatarView];
        {
            [self.sideMenuAvatarView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(cell);
                make.width.equalTo(cell).multipliedBy(0.35);
                make.height.equalTo(cell).multipliedBy(0.8);
            }];
        }
    }
    
    [[YPBUserDetailModel sharedModel] fetchUserDetailWithUserId:[YPBUser currentUser].userId completionHandler:^(BOOL success, id obj) {
        if (success) {
            YPBUser *user = obj;
            [user setAsCurrentUser];
        }
    }];
}

- (BOOL)sideMenuController:(UIViewController *)sideMenuVC shouldPresentContentViewController:(UIViewController *)contentVC {
    return NO;
}

- (CGFloat)sideMenuItemHeight {
    return kScreenHeight * 0.3;
}
@end
