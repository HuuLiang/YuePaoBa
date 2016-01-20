//
//  YPBEditMineDetailViewController.m
//  YuePaoBa
//
//  Created by Sean Yue on 15/12/24.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import "YPBEditMineDetailViewController.h"
#import "YPBTableViewCell.h"
#import "YPBInputTextViewController.h"
#import "YPBMineFigureViewController.h"
#import <ActionSheetStringPicker.h>
#import "YPBUser+Mine.h"
#import "YPBUserDetailUpdateModel.h"

@interface YPBEditMineDetailViewController ()
{
    YPBTableViewCell *_wechatCell;
    YPBTableViewCell *_interestCell;
    YPBTableViewCell *_professionCell;
    
    YPBTableViewCell *_heightCell;
    YPBTableViewCell *_figureCell;
    YPBTableViewCell *_ageCell;
    
    YPBTableViewCell *_incomeCell;
    YPBTableViewCell *_assetsCell;
}
@property (nonatomic,retain) YPBUserDetailUpdateModel *updateModel;
@property (nonatomic) BOOL canEditWeChat;
@end

@implementation YPBEditMineDetailViewController

DefineLazyPropertyInitialization(YPBUserDetailUpdateModel, updateModel)

- (instancetype)initWithUser:(YPBUser *)user {
    self = [super init];
    if (self) {
        _user = user;
        _canEditWeChat = user.weixinNum.length == 0;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"编辑资料";
    
    self.layoutTableView.rowHeight = kDefaultCellHeight;
    [self.layoutTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self initCellLayouts];
    
    @weakify(self);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"保存"
                                                                                 style:UIBarButtonItemStylePlain
                                                                               handler:^(id sender)
    {
        @strongify(self);
        [self onSave];
    }];
    [self.navigationItem.rightBarButtonItem setTitlePositionAdjustment:UIOffsetMake(-5, 0) forBarMetrics:UIBarMetricsDefault];
    
    self.layoutTableViewAction = ^(NSIndexPath *indexPath, UITableViewCell *cell) {
        @strongify(self);
        
        if (cell == self->_wechatCell) {
            [self onWechatCell];
        } else if (cell == self->_interestCell) {
            [self onInterestCell];
        } else if (cell == self->_professionCell) {
            [self onProfessionCell];
        } else if (cell == self->_heightCell) {
            [self onHeightCell];
        } else if (cell == self->_figureCell) {
            [self onFigureCell];
        } else if (cell == self->_ageCell) {
            [self onAgeCell];
        } else if (cell == self->_incomeCell) {
            [self onIncomeCell];
        } else if (cell == self->_assetsCell) {
            [self onAssetsCell];
        }
    };
}

- (void)initCellLayouts {
    _wechatCell = [self newCellWithCommonStylesAndImage:[UIImage imageNamed:@"wechat_icon"]
                                                  title:@"微信" subtitle:self.user.weixinNum];
    if (!self.canEditWeChat) {
        _wechatCell.accessoryType = UITableViewCellAccessoryNone;
        _wechatCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [self setLayoutCell:_wechatCell inRow:0 andSection:0];

    _interestCell = [self newCellWithCommonStylesAndImage:[UIImage imageNamed:@"interest_icon"]
                                                    title:@"兴趣" subtitle:self.user.note];
    [self setLayoutCell:_interestCell inRow:1 andSection:0];
    
    _professionCell = [self newCellWithCommonStylesAndImage:[UIImage imageNamed:@"profession_icon"]
                                                      title:@"职业" subtitle:self.user.profession];
    [self setLayoutCell:_professionCell inRow:2 andSection:0];
    
    _heightCell = [self newCellWithCommonStylesAndImage:[UIImage imageNamed:@"height_icon"]
                                                  title:@"身高" subtitle:self.user.heightDescription];
    [self setLayoutCell:_heightCell inRow:0 andSection:1];
    
    _figureCell = [self newCellWithCommonStylesAndImage:[UIImage imageNamed:@"figure_icon"]
                                                  title:self.user.gender == YPBUserGenderFemale ? @"身材" : @"体重"
                                               subtitle:self.user.gender == YPBUserGenderFemale ? self.user.bwh : (self.user.bwh.length > 0 ? [self.user.bwh stringByAppendingString:@" kg"] :nil)];
    [self setLayoutCell:_figureCell inRow:1 andSection:1];
    
    _ageCell = [self newCellWithCommonStylesAndImage:[UIImage imageNamed:@"age_icon"]
                                               title:@"年龄" subtitle:self.user.ageDescription];
    [self setLayoutCell:_ageCell inRow:2 andSection:1];
    
    _incomeCell = [self newCellWithCommonStylesAndImage:[UIImage imageNamed:@"income_icon"]
                                                  title:@"月收入" subtitle:self.user.monthIncome];
    [self setLayoutCell:_incomeCell inRow:0 andSection:2];
    
    _assetsCell = [self newCellWithCommonStylesAndImage:[UIImage imageNamed:@"assets_icon"]
                                                  title:@"资产情况" subtitle:self.user.assets];
    [self setLayoutCell:_assetsCell inRow:1 andSection:2];
    
}

- (YPBTableViewCell *)newCellWithCommonStylesAndImage:(UIImage *)image title:(NSString *)title subtitle:(NSString *)subtitle {
    
    YPBTableViewCell *newCell = [[YPBTableViewCell alloc] initWithImage:image title:title subtitle:subtitle];
    newCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    newCell.titleLabel.font = [UIFont systemFontOfSize:16.];
    newCell.subtitleLabel.font = [UIFont systemFontOfSize:16.];
    return newCell;
}

- (void)onWechatCell {
    if (!self.canEditWeChat) {
        return ;
    }
    
    @weakify(self);
    YPBInputTextViewController *inputVC = [[YPBInputTextViewController alloc] initWithTextBlock:NO];
    inputVC.title = @"编辑微信号";
    inputVC.placeholder = @"输入微信号";
    inputVC.note = @"微信资料输入后无法修改\n为了让有缘人及时找到，请正确填写。";
    inputVC.text = self->_wechatCell.subtitleLabel.text;
    inputVC.completionHandler = ^BOOL(id sender, NSString *text) {
        @strongify(self);
        self.user.weixinNum = text;
        self->_wechatCell.subtitleLabel.text = text;
        return YES;
    };
    inputVC.changeHandler = ^BOOL(id sender, NSString *text) {
        return text.length > 0;
    };
    [self.navigationController pushViewController:inputVC animated:YES];
}

- (void)onInterestCell {
    @weakify(self);
    YPBInputTextViewController *inputVC = [[YPBInputTextViewController alloc] initWithTextBlock:YES];
    inputVC.title = @"编辑兴趣";
    inputVC.placeholder = @"填写您的兴趣爱好，例如音乐、电影等";
    inputVC.text = self->_interestCell.subtitleLabel.text;
    inputVC.limitedTextLength = 50;
    inputVC.completionHandler = ^BOOL(id sender, NSString *text) {
        @strongify(self);
        self.user.note = text;
        self->_interestCell.subtitleLabel.text = text;
        return YES;
    };
    [self.navigationController pushViewController:inputVC animated:YES];
}

- (void)onHeightCell {
    @weakify(self);
    NSArray *allHeights = [YPBUser allHeightStrings];
    NSUInteger index = self.user.heightIndex;
    [ActionSheetStringPicker showPickerWithTitle:@"选择身高"
                                            rows:allHeights
                                initialSelection:index
                                       doneBlock:^(ActionSheetStringPicker *picker,
                                                   NSInteger selectedIndex,
                                                   id selectedValue)
    {
        @strongify(self);
        [self.user setHeightWithIndex:selectedIndex];
        self->_heightCell.subtitleLabel.text = self.user.heightDescription;
    } cancelBlock:nil origin:self.view];
}

- (void)onProfessionCell {
    @weakify(self);
    YPBInputTextViewController *inputVC = [[YPBInputTextViewController alloc] initWithTextBlock:NO];
    inputVC.title = @"编辑职业";
    inputVC.placeholder = @"输入职业";
    inputVC.text = self->_professionCell.subtitleLabel.text;
    inputVC.completionHandler = ^BOOL(id sender, NSString *text) {
        @strongify(self);
        self.user.profession = text;
        self->_professionCell.subtitleLabel.text = text;
        return YES;
    };
    [self.navigationController pushViewController:inputVC animated:YES];
}

- (void)onAgeCell {
    NSArray *allAges = [YPBUser allAgeStrings];
    NSUInteger index = self.user.ageIndex;
    
    @weakify(self);
    [ActionSheetStringPicker showPickerWithTitle:@"选择年龄"
                                            rows:allAges
                                initialSelection:index
                                       doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue)
    {
       @strongify(self);
       [self.user setAgeWithIndex:selectedIndex];
       self->_ageCell.subtitleLabel.text = selectedValue;
    } cancelBlock:nil origin:self.view];
}

- (void)onIncomeCell {
    NSArray *allIncomes = [YPBUser allIncomeStrings];
    NSUInteger index = self.user.incomeIndex;
    
    @weakify(self);
    [ActionSheetStringPicker showPickerWithTitle:@"选择收入范围"
                                            rows:allIncomes
                                initialSelection:index
                                       doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue)
    {
        @strongify(self);
        [self.user setIncomeWithIndex:selectedIndex];
        self->_incomeCell.subtitleLabel.text = selectedValue;
    } cancelBlock:nil origin:self.view];
}

- (void)onAssetsCell {
    NSArray *assets = [YPBUser allAssetsStrings];
    NSUInteger index = self.user.assetsIndex;
    
    @weakify(self);
    [ActionSheetStringPicker showPickerWithTitle:@"选择资产情况"
                                            rows:assets
                                initialSelection:index
                                       doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue)
    {
        @strongify(self);
        [self.user setAssetsWithIndex:selectedIndex];
        self->_assetsCell.subtitleLabel.text = selectedValue;
    } cancelBlock:nil origin:self.view];
}

- (void)onFigureCell {
    if (self.user.gender == YPBUserGenderFemale) {
        YPBMineFigureViewController *figureVC = [[YPBMineFigureViewController alloc] initWithUser:self.user];
        [self.navigationController pushViewController:figureVC animated:YES];
    } else {
        
        NSArray *weights = [YPBUser allWeightStrings];
        NSUInteger index = self.user.weightIndex;
        
        @weakify(self);
        [ActionSheetStringPicker showPickerWithTitle:@"选择体重"
                                                rows:weights
                                    initialSelection:index
                                           doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue)
        {
            @strongify(self);
            [self.user setWeightWithIndex:selectedIndex];
            self->_figureCell.subtitleLabel.text = selectedValue;
        } cancelBlock:nil origin:self.view];
    }
    
}

- (void)onSave {
    @weakify(self);
    [self.view beginLoading];
    [self.updateModel updateDetailOfUser:self.user withCompletionHandler:^(BOOL success, id obj) {
        @strongify(self);
        [self.view endLoading];
        if (success) {
            [self.user saveAsCurrentUser];
            [[YPBMessageCenter defaultCenter] showSuccessWithTitle:@"个人资料修改成功" inViewController:self];
            
            SafelyCallBlock1(self.successHandler, self.user);
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
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
