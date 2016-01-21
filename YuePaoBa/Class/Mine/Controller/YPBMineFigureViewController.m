//
//  YPBMineFigureViewController.m
//  YuePaoBa
//
//  Created by Sean Yue on 15/12/29.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import "YPBMineFigureViewController.h"
#import "YPBTableViewCell.h"
#import "YPBUser+Mine.h"
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
        _user = user.copy;
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
            [self onBust];
        } else if (cell == _waistCell) {
            [self onWaist];
        } else if (cell == _hipCell) {
            [self onHip];
        } else if (cell == _cupCell) {
            [self onCup];
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
    _bustCell = [self cellWithCommonStylesAndTitle:@"胸围" subtitle:self.user.bustDescription];
    [self setLayoutCell:_bustCell inRow:row++ andSection:0];
    
    _waistCell = [self cellWithCommonStylesAndTitle:@"腰围" subtitle:self.user.waistDescription];
    [self setLayoutCell:_waistCell inRow:row++ andSection:0];
    
    _hipCell = [self cellWithCommonStylesAndTitle:@"臀围" subtitle:self.user.hipDescription];
    [self setLayoutCell:_hipCell inRow:row++ andSection:0];
    
    _cupCell = [self cellWithCommonStylesAndTitle:@"罩杯" subtitle:self.user.cupDescription];
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
    SafelyCallBlock1(self.saveAction, [self.user.bwh stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]);
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onBust {
    NSArray *allBusts = [YPBUser allBustStrings];
    NSUInteger bustIndex = [[YPBUser allBustValues] indexOfObject:@(self.user.bust)];
    if (bustIndex == NSNotFound) {
        bustIndex = 0;
    }
    
    @weakify(self);
    [ActionSheetStringPicker showPickerWithTitle:@"选择胸围"
                                            rows:allBusts
                                initialSelection:bustIndex
                                       doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue)
    {
        @strongify(self);
        self.user.bust = ((NSString *)selectedValue).floatValue;
        self->_bustCell.subtitleLabel.text = selectedValue;
    } cancelBlock:nil origin:self.view];
}

- (void)onWaist {
    NSArray *allWaists = [YPBUser allWaistStrings];
    NSUInteger waistIndex = [[YPBUser allWaistValues] indexOfObject:@(self.user.waist)];
    if (waistIndex == NSNotFound) {
        waistIndex = 0;
    }
    
    @weakify(self);
    [ActionSheetStringPicker showPickerWithTitle:@"选择腰围"
                                            rows:allWaists
                                initialSelection:waistIndex
                                       doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue)
    {
        @strongify(self);
        self.user.waist = ((NSString *)selectedValue).floatValue;
        self->_waistCell.subtitleLabel.text = selectedValue;
    } cancelBlock:nil origin:self.view];
}

- (void)onHip {
    NSArray *allHips = [YPBUser allHipStrings];
    NSUInteger hipIndex = [[YPBUser allHipValues] indexOfObject:@(self.user.hip)];
    if (hipIndex == NSNotFound) {
        hipIndex = 0;
    }
    
    @weakify(self);
    [ActionSheetStringPicker showPickerWithTitle:@"选择臀围"
                                            rows:allHips
                                initialSelection:hipIndex
                                       doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue)
    {
        @strongify(self);
        self.user.hip = ((NSString *)selectedValue).floatValue;
        self->_hipCell.subtitleLabel.text = selectedValue;
    } cancelBlock:nil origin:self.view];
}

- (void)onCup {
    NSArray *cups = [YPBUser allCupsDescription];
    
    @weakify(self);
    [ActionSheetStringPicker showPickerWithTitle:@"选择罩杯"
                                            rows:cups
                                initialSelection:self.user.cup
                                       doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue)
     {
         @strongify(self);
         self.user.cup = selectedIndex;
         self->_cupCell.subtitleLabel.text = selectedValue;
     } cancelBlock:nil origin:self.view];
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
