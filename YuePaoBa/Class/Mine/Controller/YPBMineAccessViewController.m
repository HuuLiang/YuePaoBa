//
//  YPBMineAccessViewController.m
//  YuePaoBa
//
//  Created by Sean Yue on 15/12/31.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import "YPBMineAccessViewController.h"
#import "YPBUserAccessQueryModel.h"
#import "YPBMineGreetingCell.h"

static NSString *const kMineGreetingCellReusableIdentifier = @"MineGreetingCellReusableIdentifier";

@interface YPBMineAccessViewController () <UITableViewDataSource,UITableViewSeparatorDelegate>
{
    UITableView *_layoutTableView;
}
@property (nonatomic,retain) YPBUserAccessQueryModel *accessQueryModel;
@property (nonatomic,retain) NSMutableArray<YPBUserGreet *> *userGreets;
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
    [_layoutTableView registerClass:[YPBMineGreetingCell class] forCellReuseIdentifier:kMineGreetingCellReusableIdentifier];
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
    [_layoutTableView YPB_triggerPullToRefresh];
    
    [_layoutTableView YPB_addPagingRefreshWithHandler:^{
        @strongify(self);
        [self loadDataWithRefresh:NO];
    }];
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
        
        if (success) {
            if (isRefresh) {
                [self.userGreets removeAllObjects];
            }
            
            [self.userGreets addObjectsFromArray:obj];
            [self->_layoutTableView reloadData];
            
            if ([self.accessQueryModel.userAccess nextPage] == NSNotFound) {
                [self->_layoutTableView YPB_pagingRefreshNoMoreData];
            }
        }
        
        [self->_layoutTableView YPB_endPullToRefresh];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource,UITableViewSeparatorDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YPBMineGreetingCell *cell = [tableView dequeueReusableCellWithIdentifier:kMineGreetingCellReusableIdentifier forIndexPath:indexPath];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.userGreets.count;
}

@end
