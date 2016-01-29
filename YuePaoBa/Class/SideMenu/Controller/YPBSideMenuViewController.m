//
//  YPBSideMenuViewController.m
//  YuePaoBa
//
//  Created by Sean Yue on 15/12/2.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import "YPBSideMenuViewController.h"
#import "YPBSideMenuCell.h"
#import "MobClick.h"

@interface YPBSideMenuViewController ()
{
    UITableView *_layoutTableView;
}
//@property (nonatomic,retain) NSMutableDictionary<NSNumber *, YPBSideMenuCell *> *cells;
@end

@implementation YPBSideMenuViewController

//DefineLazyPropertyInitialization(NSMutableDictionary, cells)

//- (instancetype)initWithViewControllers:(NSArray<UIViewController *> *)viewControllers {
//    self = [super init];
//    if (self) {
//        _viewControllers = viewControllers;
//        
//        [viewControllers enumerateObjectsUsingBlock:^(UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            obj.sideMenuVC = self;
//        }];
//    }
//    return self;
//}

- (instancetype)initWithSideMenuItems:(NSArray<YPBSideMenuItem *> *)sideMenuItems {
    self = [self init];
    if (self) {
        _sideMenuItems = sideMenuItems;
        
        [sideMenuItems enumerateObjectsUsingBlock:^(YPBSideMenuItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.rootViewController.sideMenuVC = self;
        }];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.layoutTableView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.85];
    self.layoutTableView.scrollEnabled = NO;
    self.layoutTableView.hasRowSeparator = NO;
    self.layoutTableView.hasSectionBorder = NO;
    [self.view addSubview:self.layoutTableView];
    {
        const CGFloat rightOffset = [UIScreen mainScreen].bounds.size.width/2 -CONTENT_VIEW_OFFSET_CENTERX;
        [self.layoutTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0,rightOffset));
        }];
    }
    [self initLayoutCells];
}

- (void)initLayoutCells {
    
    [self.sideMenuItems enumerateObjectsUsingBlock:^(YPBSideMenuItem * _Nonnull sideMenuItem, NSUInteger idx, BOOL * _Nonnull stop) {
        YPBSideMenuCell *cell;
        if (sideMenuItem.title || sideMenuItem.image) {
            cell = [[YPBSideMenuCell alloc] initWithTitle:sideMenuItem.title iconImage:sideMenuItem.image];
        } else {
            cell = [[YPBSideMenuCell alloc] init];
        }
        
        if (sideMenuItem.delegate
            && [sideMenuItem.delegate respondsToSelector:@selector(sideMenuController:willAddToSideMenuCell:)]) {
            [sideMenuItem.delegate sideMenuController:self willAddToSideMenuCell:cell];
        }
        
        CGFloat cellHeight = sideMenuItem.height;
        if (cellHeight == 0) {
            cellHeight = kScreenHeight * 0.1;
        }
        
        if (sideMenuItem.delegate
            && [sideMenuItem.delegate respondsToSelector:@selector(sideMenuItemHeight)]) {
            cellHeight = [sideMenuItem.delegate sideMenuItemHeight];
        }
        [self setLayoutCell:cell cellHeight:cellHeight inRow:idx andSection:0];
    }];
    
}

//- (NSUInteger)selectedIndex {
//    return [self.viewControllers indexOfObject:self.sideMenuViewController.contentViewController];
//}
//
//- (void)setSelectedIndex:(NSUInteger)selectedIndex {
//    if (selectedIndex < self.viewControllers.count) {
//        [self.sideMenuViewController setContentViewController:self.viewControllers[selectedIndex] animated:YES];
//    }
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//#pragma mark - UITableViewDataSource,UITableViewDelegate
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    YPBSideMenuCell *cell = self.cells[@(indexPath.row)];
//    if (cell) {
//        return cell;
//    }
//    
//    UIViewController *viewController = self.viewControllers[indexPath.row];
//    if (viewController.sideMenuItem.title || viewController.sideMenuItem.image) {
//        cell = [[YPBSideMenuCell alloc] initWithTitle:viewController.sideMenuItem.title iconImage:viewController.sideMenuItem.image];
//    } else {
//        cell = [[YPBSideMenuCell alloc] init];
//    }
//
//    if (viewController.sideMenuItem.delegate
//        && [viewController.sideMenuItem.delegate respondsToSelector:@selector(sideMenuController:willAddToSideMenuCell:)]) {
//        [viewController.sideMenuItem.delegate sideMenuController:self willAddToSideMenuCell:cell];
//    }
//    [self.cells setObject:cell forKey:@(indexPath.row)];
//    return cell;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return self.viewControllers.count;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UIViewController *viewController = self.viewControllers[indexPath.row];
//    if (viewController.sideMenuItem.delegate
//        && [viewController.sideMenuItem.delegate respondsToSelector:@selector(sideMenuItemHeight)]) {
//        return [viewController.sideMenuItem.delegate sideMenuItemHeight];
//    }
//    return viewController.sideMenuItem.height;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    YPBSideMenuItem *sideMenuItem = self.sideMenuItems[indexPath.row];
    
    if (sideMenuItem.delegate
        && [sideMenuItem.delegate respondsToSelector:@selector(sideMenuController:shouldPresentContentViewController:)]) {
        if (![sideMenuItem.delegate sideMenuController:self shouldPresentContentViewController:sideMenuItem.rootViewController]) {
            return ;
        }
    }
    
    [self.sideMenuViewController hideMenuViewController];
    [self.sideMenuViewController setContentViewController:sideMenuItem.rootViewController animated:YES];
}

#pragma mark - RESideMenuDelegate

- (void)sideMenu:(RESideMenu *)sideMenu willShowMenuViewController:(UIViewController *)menuViewController {
    [self.allCells enumerateKeysAndObjectsUsingBlock:^(NSIndexPath * _Nonnull key, UITableViewCell * _Nonnull obj, BOOL * _Nonnull stop) {
        YPBSideMenuItem *sideMenuItem = self.sideMenuItems[key.row];
        if (sideMenuItem.delegate
            && [sideMenuItem.delegate respondsToSelector:@selector(badgeValueOfSideMenuItem:)]) {
            YPBSideMenuCell *cell = (YPBSideMenuCell *)obj;
            cell.badgeValue = [sideMenuItem.delegate badgeValueOfSideMenuItem:sideMenuItem];
        }
        
    }];
}

- (void)sideMenu:(RESideMenu *)sideMenu didShowMenuViewController:(UIViewController *)menuViewController {
    [MobClick event:@"YPB_VIEW_SIDE_MENU" attributes:@{@"userId":[YPBUser currentUser].userId ?: @"",
                                                       @"loginTimes":@([YPBUtil loginFrequency]).stringValue}];
}

@end
