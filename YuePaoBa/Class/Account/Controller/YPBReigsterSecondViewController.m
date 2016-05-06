//
//  YPBReigsterSecondViewController.m
//  YuePaoBa
//
//  Created by Sean Yue on 15/12/11.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import "YPBReigsterSecondViewController.h"
#import "YPBActionButton.h"
#import <ActionSheetStringPicker.h>
#import <ActionSheetMultipleStringPicker.h>
#import "YPBUser+Account.h"
#import "YPBRegisterModel.h"
#import "YPBActivateModel.h"

@interface YPBReigsterSecondViewController ()
{
    UITableViewCell *_heightCell;
    UITableViewCell *_ageCell;
    UITableViewCell *_cupCell;
}
//@property (nonatomic,retain) UIView *titleView;
@property (nonatomic,retain) YPBUser *user;
@property (nonatomic,retain) YPBRegisterModel *registerModel;
@property (nonatomic,retain) YPBActivateModel *activateModel;
@end

@implementation YPBReigsterSecondViewController

DefineLazyPropertyInitialization(YPBRegisterModel, registerModel)
DefineLazyPropertyInitialization(YPBActivateModel, activateModel)

- (instancetype)initWithYPBUser:(YPBUser *)user {
    self = [super init];
    if (self) {
        _user = user;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"设置交友对象";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"register_background"]];
    backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view insertSubview:backgroundImageView atIndex:0];
    {
        [backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
//    
//    [self.view addSubview:self.titleView];
//    {
//        [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.equalTo(self.view);
//            make.centerY.equalTo(self.view).dividedBy(3);
//            make.left.right.equalTo(self.view).insets(UIEdgeInsetsMake(0, 30, 0, 30));
//            make.height.mas_equalTo(60);
//        }];
//    }
    
    self.layoutTableView.layer.cornerRadius = 8;
    self.layoutTableView.rowHeight = MAX(kScreenHeight * 0.08, 50);
    self.layoutTableView.scrollEnabled = NO;
    self.layoutTableView.separatorInset = UIEdgeInsetsZero;
    [self.layoutTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view).insets(UIEdgeInsetsMake(0, 30, 0, 30));
        make.top.equalTo(self.view).offset(30);
        make.height.mas_equalTo(self.layoutTableView.rowHeight*(self.user.gender==YPBUserGenderMale?3:2));
    }];
    
    @weakify(self);
    YPBActionButton *nextButton = [[YPBActionButton alloc] initWithTitle:@"确    定" action:^(id sender) {
        @strongify(self);
        
        if (!self) {
            return ;
        }
        
        @weakify(self);
        void (^RegisterBlock)(void) = ^{
            @strongify(self);
            [self.registerModel requestRegisterUser:self.user withCompletionHandler:^(BOOL success, id obj) {
                @strongify(self);
                if (!self) {
                    return ;
                }
                
                if (success) {
                    [self onRegisterSuccessfullyWithUserId:obj];
                } else {
                    [self.view endLoading];
                }
            }];
        };
        
        [self.view beginLoading];
        if ([YPBUtil activationId].length == 0) {
            [self.activateModel requestActivationWithCompletionHandler:^(BOOL success, id obj) {
                if (success) {
                    RegisterBlock();
                } else {
                    [self.view endLoading];
                }
            }];
        } else {
            RegisterBlock();
        }
    }];
    
    [self.view addSubview:nextButton];
    {
        [nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.layoutTableView);
            make.top.equalTo(self.layoutTableView.mas_bottom).offset(30);
            make.height.mas_equalTo(self.layoutTableView.rowHeight);
        }];
    }
    
    [self initLayoutCells];
}

- (void)initLayoutCells {
    _heightCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    _heightCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    _heightCell.textLabel.text = @"身高";
    _heightCell.textLabel.font = [UIFont systemFontOfSize:15.];
    _heightCell.detailTextLabel.text = self.user.targetHeightDescription;
    [self setLayoutCell:_heightCell inRow:0 andSection:0];
    
    _ageCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    _ageCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    _ageCell.textLabel.text = @"年龄";
    _ageCell.textLabel.font = [UIFont systemFontOfSize:15.];
    _ageCell.detailTextLabel.text = self.user.targetAgeDescription;
    [self setLayoutCell:_ageCell inRow:1 andSection:0];
    
    if (self.user.gender == YPBUserGenderMale) {
        _cupCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
        _cupCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        _cupCell.textLabel.text = @"罩杯";
        _cupCell.textLabel.font = [UIFont systemFontOfSize:15.];
        _cupCell.detailTextLabel.text = self.user.targetCupDescription;
        [self setLayoutCell:_cupCell inRow:2 andSection:0];
    }
}

- (void)onRegisterSuccessfullyWithUserId:(NSString *)uid {
    [[YPBMessageCenter defaultCenter] showSuccessWithTitle:@"注册成功" inViewController:self];
    
    @weakify(self);
    [self bk_performBlock:^(id receiver) {
        @strongify(self);
        [[YPBMessageCenter defaultCenter] dismissMessageWithCompletion:^{
            self.user.userId = uid;
            [self.user saveAsCurrentUser];
            [self dismissViewControllerAnimated:YES completion:nil];
            [YPBUtil notifyRegisterSuccessfully];
        }];
        
    } afterDelay:1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    @weakify(self);
    if (indexPath.row == 0) {
        [ActionSheetMultipleStringPicker showPickerWithTitle:@"选择对象身高"
                                                        rows:@[[YPBUser allHeightRangeDescription],[YPBUser allHeightRangeDescription]]
                                            initialSelection:self.user.valueIndexesOfTargetHeight
                                                   doneBlock:^(ActionSheetMultipleStringPicker *picker, NSArray *selectedIndexes, id selectedValues)
        {
            @strongify(self);
            [self.user setTargetHeightWithRangeStringBetween:selectedValues[0] and:selectedValues[1]];
            self->_heightCell.detailTextLabel.text = self.user.targetHeightDescription;
        } cancelBlock:nil origin:self.view];
    } else if (indexPath.row == 1) {
        [ActionSheetMultipleStringPicker showPickerWithTitle:@"选择对象年龄"
                                                        rows:@[[YPBUser allAgeRangeDescription],[YPBUser allAgeRangeDescription]]
                                            initialSelection:self.user.valueIndexesOfTargetAge
                                                   doneBlock:^(ActionSheetMultipleStringPicker *picker, NSArray *selectedIndexes, id selectedValues)
        {
            @strongify(self);
            [self.user setTargetAgeWithRangeStringBetween:selectedValues[0] and:selectedValues[1]];
            self->_ageCell.detailTextLabel.text = self.user.targetAgeDescription;
        } cancelBlock:nil origin:self.view];
    } else if (indexPath.row == 2) {
        [ActionSheetStringPicker showPickerWithTitle:@"选择对象罩杯"
                                                rows:[YPBUser allCupsDescription]
                                    initialSelection:self.user.valueIndexOfTargetCup
                                           doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue)
        {
            @strongify(self);
            [self.user setTargetCupWithString:selectedValue];
            self->_cupCell.detailTextLabel.text = self.user.targetCupDescription;
        } cancelBlock:nil origin:self.view];
    }
}
@end
