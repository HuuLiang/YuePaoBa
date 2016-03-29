//
//  YPBMineAccessViewController.m
//  YuePaoBa
//
//  Created by Sean Yue on 15/12/31.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import "YPBMineAccessViewController.h"
#import "YPBUserAccessQueryModel.h"
#import "YPBMineAccessCell.h"
#import "YPBUserDetailViewController.h"

static NSString *const kMineAccessCellReusableIdentifier = @"MineAccessCellReusableIdentifier";

@interface YPBMineAccessViewController () <UITableViewDataSource,UITableViewSeparatorDelegate>
{
    UITableView *_layoutTableView;
}
@property (nonatomic,retain) YPBUserAccessQueryModel *accessQueryModel;
@property (nonatomic,retain) NSMutableArray<YPBUserGreet *> *userGreets;
@property (nonatomic,retain) NSDateFormatter *dateFormatter;
@end

@implementation YPBMineAccessViewController

DefineLazyPropertyInitialization(YPBUserAccessQueryModel, accessQueryModel)
DefineLazyPropertyInitialization(NSMutableArray, userGreets)

- (instancetype)initWithAccessType:(YPBMineAccessType)accessType {
    self = [self init];
    if (self) {
        _accessType = accessType;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    switch (_accessType) {
        case YPBMineAccessTypeGreetingSent:
            self.title = @"打过的招呼";
            break;
        case YPBMineAccessTypeGreetingReceived:
            self.title = @"收到的招呼";
            break;
        case YPBMineAccessTypeAccessViewed:
            self.title = @"谁访问了我";
            break;
        default:
            break;
    }
    
    _layoutTableView = [[UITableView alloc] init];
    _layoutTableView.delegate = self;
    _layoutTableView.dataSource = self;
    _layoutTableView.hasRowSeparator = YES;
    _layoutTableView.hasSectionBorder = YES;
    _layoutTableView.rowHeight = MAX(kScreenHeight * 0.15, 80);
    [_layoutTableView registerClass:[YPBMineAccessCell class] forCellReuseIdentifier:kMineAccessCellReusableIdentifier];
    [self.view addSubview:_layoutTableView];
    {
        [_layoutTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    
    @weakify(self);
    [_layoutTableView YPB_addPullToRefreshWithHandler:^{
        @strongify(self);
        [self loadDataWithRefresh:YES];
    }];
    
    
    [_layoutTableView YPB_addPagingRefreshWithHandler:^{
        @strongify(self);
        [self loadDataWithRefresh:NO];
    }];
    
    [_layoutTableView YPB_triggerPullToRefresh];
}

- (void)loadDataWithRefresh:(BOOL)isRefresh {
    @weakify(self);
    
    YPBUserAccessType userAccessType = _accessType == YPBMineAccessTypeAccessViewed ? YPBUserAccessTypeViewing : YPBUserAccessTypeGreeting;
    YPBUserGreetingType userGreetingType = _accessType == YPBMineAccessTypeGreetingSent ? YPBUserGreetingTypeSent : YPBUserGreetingTypeReceived;
    [self.accessQueryModel queryUser:[YPBUser currentUser].userId
                      withAccessType:userAccessType
                           greetType:userGreetingType
                                page:isRefresh?1:[self.accessQueryModel.userAccess nextPage]
                   completionHandler:^(BOOL success, id obj)
    {
        @strongify(self);
        if (!self) {
            return ;
        }
        
        [self->_layoutTableView YPB_endPullToRefresh];
        
        if (success) {
            NSArray *userGreets = obj;
            if (isRefresh) {
                [self.userGreets removeAllObjects];
                
                if (userGreets.count == 0) {
                    NSString *noDataMsg;
                    if (_accessType == YPBMineAccessTypeGreetingSent) {
                        noDataMsg = @"您没有和任何人打过招呼";
                    } else if (_accessType == YPBMineAccessTypeGreetingReceived) {
                        noDataMsg = @"没有人和你打过招呼";
                    } else if (_accessType == YPBMineAccessTypeAccessViewed) {
                        noDataMsg = @"没有人访问过你";
                    }
                    [[YPBMessageCenter defaultCenter] showWarningWithTitle:noDataMsg inViewController:self];
                }
            }
            
            [self.userGreets addObjectsFromArray:userGreets];
            [self->_layoutTableView reloadData];
            
            if ([self.accessQueryModel.userAccess nextPage] == NSNotFound) {
                [self->_layoutTableView YPB_pagingRefreshNoMoreData];
            }
            
            [self processUnreadAccesses];
        }
    }];
}

- (void)processUnreadAccesses {
    switch (_accessType) {
        case YPBMineAccessTypeAccessViewed:
            [YPBUser currentUser].readAccessCount = [YPBUser currentUser].accessCount;
            break;
        case YPBMineAccessTypeGreetingReceived:
            [YPBUser currentUser].readReceiveGreetCount = [YPBUser currentUser].receiveGreetCount;
            break;
        case YPBMineAccessTypeGreetingSent:
            [YPBUser currentUser].readGreetCount = [YPBUser currentUser].greetCount;
            break;
        default:
            break;
    }
    
    [[YPBUser currentUser] saveAsCurrentUser];
}

- (NSDateFormatter *)dateFormatter {
    if (_dateFormatter) {
        return _dateFormatter;
    }
    
    _dateFormatter = [[NSDateFormatter alloc] init];
    [_dateFormatter setDateFormat:kDefaultDateFormat];
    return _dateFormatter;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource,UITableViewSeparatorDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YPBMineAccessCell *cell = [tableView dequeueReusableCellWithIdentifier:kMineAccessCellReusableIdentifier forIndexPath:indexPath];
    
    if (indexPath.row < self.userGreets.count) {
        YPBUserGreet *userGreet = self.userGreets[indexPath.row];
        cell.imageURL = [NSURL URLWithString:userGreet.logoUrl];
        cell.title = userGreet.nickName;
        
        NSDate *accessDate = [self.dateFormatter dateFromString:userGreet.accessTime];
        NSDateComponents *diff = [[NSCalendar currentCalendar] components:NSCalendarUnitSecond|NSCalendarUnitMinute|NSCalendarUnitHour|NSCalendarUnitDay
                                                                 fromDate:accessDate
                                                                   toDate:[NSDate date]
                                                                  options:0];
        NSString *accessTime;
        if (diff.day > 0) {
            accessTime = [NSString stringWithFormat:@"%ld天前", (long)diff.day];
        } else if (diff.hour > 0) {
            accessTime = [NSString stringWithFormat:@"%ld小时前", (long)diff.hour];
        } else if (diff.minute > 0) {
            accessTime = [NSString stringWithFormat:@"%ld分钟前", (long)diff.minute];
        } else if (diff.second > 0) {
            accessTime = [NSString stringWithFormat:@"%ld秒钟前", (long)diff.second];
        }
        
        NSString *details = [NSString stringWithFormat:@"年龄：%@   身高：%@cm\n%@", userGreet.age, userGreet.height, accessTime];
        cell.subtitle = details;
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.userGreets.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    YPBUserGreet *userGreet = self.userGreets[indexPath.row];
    YPBUserDetailViewController *detailVC = [[YPBUserDetailViewController alloc] initWithUserId:userGreet.userId];
    [self.navigationController pushViewController:detailVC animated:YES];
}

@end
