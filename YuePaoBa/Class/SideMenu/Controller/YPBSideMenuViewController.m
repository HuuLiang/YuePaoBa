//
//  YPBSideMenuViewController.m
//  YuePaoBa
//
//  Created by Sean Yue on 15/12/2.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import "YPBSideMenuViewController.h"
#import "YPBSideMenuCell.h"

@interface YPBSideMenuViewController () <UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_layoutTableView;
}
@property (nonatomic,retain) NSMutableDictionary<NSNumber *, YPBSideMenuCell *> *cells;
@end

@implementation YPBSideMenuViewController

DefineLazyPropertyInitialization(NSMutableDictionary, cells)

- (instancetype)initWithViewControllers:(NSArray<UIViewController *> *)viewControllers {
    self = [super init];
    if (self) {
        _viewControllers = viewControllers;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _layoutTableView = [[UITableView alloc] init];
    _layoutTableView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.85];
    _layoutTableView.delegate = self;
    _layoutTableView.dataSource = self;
    _layoutTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _layoutTableView.scrollEnabled = NO;
    [self.view addSubview:_layoutTableView];
    {
        const CGFloat rightOffset = [UIScreen mainScreen].bounds.size.width/2 -CONTENT_VIEW_OFFSET_CENTERX;
        [_layoutTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0,rightOffset));
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource,UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YPBSideMenuCell *cell = self.cells[@(indexPath.row)];
    if (cell) {
        return cell;
    }
    
    UIViewController *viewController = self.viewControllers[indexPath.row];
    if (viewController.sideMenuItem.title || viewController.sideMenuItem.image) {
        cell = [[YPBSideMenuCell alloc] initWithTitle:viewController.sideMenuItem.title iconImage:viewController.sideMenuItem.image];
    } else {
        cell = [[YPBSideMenuCell alloc] init];
    }

    if (viewController.sideMenuItem.delegate
        && [viewController.sideMenuItem.delegate respondsToSelector:@selector(sideMenuController:willAddToSideMenuCell:)]) {
        [viewController.sideMenuItem.delegate sideMenuController:self willAddToSideMenuCell:cell];
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewControllers.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UIViewController *viewController = self.viewControllers[indexPath.row];
    if (viewController.sideMenuItem.delegate
        && [viewController.sideMenuItem.delegate respondsToSelector:@selector(sideMenuItemHeight)]) {
        return [viewController.sideMenuItem.delegate sideMenuItemHeight];
    }
    return viewController.sideMenuItem.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIViewController *viewController = self.viewControllers[indexPath.row];
    if (viewController.sideMenuItem.delegate
        && [viewController.sideMenuItem.delegate respondsToSelector:@selector(sideMenuController:shouldPresentContentViewController:)]) {
        if (![viewController.sideMenuItem.delegate sideMenuController:self shouldPresentContentViewController:viewController]) {
            return ;
        }
    }
    
    [self.sideMenuViewController hideMenuViewController];
    [self.sideMenuViewController setContentViewController:viewController animated:YES];
}
@end
