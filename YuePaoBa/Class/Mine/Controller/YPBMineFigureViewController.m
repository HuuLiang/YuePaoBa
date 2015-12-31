//
//  YPBMineFigureViewController.m
//  YuePaoBa
//
//  Created by Sean Yue on 15/12/29.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import "YPBMineFigureViewController.h"
#import "YPBTableViewCell.h"
#import "YPBUser.h"
#import <ActionSheetStringPicker.h>

@interface YPBMineFigureViewController ()
{
    YPBTableViewCell *_bustCell;
    YPBTableViewCell *_waistCell;
    YPBTableViewCell *_hipCell;
    YPBTableViewCell *_cupCell;
}
@end

@implementation YPBMineFigureViewController

- (instancetype)initWithUser:(YPBUser *)user {
    self = [super init];
    if (self) {
        _user = user;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"编辑身材";
    
    self.layoutTableView.rowHeight = kDefaultCellHeight;
    [self.layoutTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self initCellLayouts];
    
    @weakify(self);
    self.layoutTableViewAction = ^(NSIndexPath *indexPath, UITableViewCell *cell) {
        @strongify(self);
        if (cell == _bustCell) {
            
        } else if (cell == _waistCell) {
            
        } else if (cell == _hipCell) {
            
        } else if (cell == _cupCell) {
            
            NSArray *cups = [YPBUser allCupsDescription];
            NSUInteger index = [cups indexOfObject:self->_cupCell.subtitleLabel.text];
            [ActionSheetStringPicker showPickerWithTitle:@"选择罩杯"
                                                    rows:cups
                                        initialSelection:index==NSNotFound?0:index
                                               doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue)
            {
                self->_cupCell.subtitleLabel.text = selectedValue;
            } cancelBlock:nil origin:self.view];
        }
    };
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"保存"
                                                                                 style:UIBarButtonItemStylePlain
                                                                               handler:^(id sender)
                                              {
                                                  @strongify(self);
                                                  [self onSave];
                                              }];
    [self.navigationItem.rightBarButtonItem setTitlePositionAdjustment:UIOffsetMake(-5, 0) forBarMetrics:UIBarMetricsDefault];
}

- (void)initCellLayouts {
    NSUInteger row = 0;
    _bustCell = [self cellWithCommonStylesAndTitle:@"胸围" subtitle:nil];
    [self setLayoutCell:_bustCell inRow:row++ andSection:0];
    
    _waistCell = [self cellWithCommonStylesAndTitle:@"腰围" subtitle:nil];
    [self setLayoutCell:_waistCell inRow:row++ andSection:0];
    
    _hipCell = [self cellWithCommonStylesAndTitle:@"臀围" subtitle:nil];
    [self setLayoutCell:_hipCell inRow:row++ andSection:0];
    
    _cupCell = [self cellWithCommonStylesAndTitle:@"罩杯" subtitle:nil];
    [self setLayoutCell:_cupCell inRow:row++ andSection:0];
}

- (YPBTableViewCell *)cellWithCommonStylesAndTitle:(NSString *)title subtitle:(NSString *)subtitle {
    YPBTableViewCell *cell = [[YPBTableViewCell alloc] init];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.titleLabel.font = [UIFont systemFontOfSize:16.];
    cell.subtitleLabel.font = [UIFont systemFontOfSize:16.];
    cell.titleLabel.text = title;
    cell.subtitleLabel.text = subtitle;
    return cell;
}

- (void)onSave {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = tableView.backgroundColor;
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 15;
}

@end
