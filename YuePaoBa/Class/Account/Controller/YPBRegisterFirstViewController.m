//
//  YPBRegisterFirstViewController.m
//  YuePaoBa
//
//  Created by Sean Yue on 15/12/11.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import "YPBRegisterFirstViewController.h"
#import "YPBActionButton.h"
#import "YPBRadioButton.h"
#import "YPBRadioButtonGroup.h"
#import "YPBReigsterSecondViewController.h"

@interface YPBRegisterFirstViewController () <UITextFieldDelegate>
{
    UITextField *_nicknameTextField;
}
@property (nonatomic,retain) YPBRadioButtonGroup *genderButtonGroup;
@property (nonatomic,retain) YPBUser *user;
@end

@implementation YPBRegisterFirstViewController

DefineLazyPropertyInitialization(YPBUser, user)

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"设置个人信息";
    self.edgesForExtendedLayout = UIRectEdgeNone;

    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"register_background"]];
    backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    backgroundImageView.userInteractionEnabled = YES;
    [self.view insertSubview:backgroundImageView atIndex:0];
    {
        [backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    
    @weakify(self);
    [backgroundImageView bk_whenTapped:^{
        @strongify(self);
        [self->_nicknameTextField resignFirstResponder];
    }];
    
    self.layoutTableView.layer.cornerRadius = 5;
    self.layoutTableView.rowHeight = MAX(kScreenHeight * 0.08, 50);
    self.layoutTableView.scrollEnabled = NO;
    self.layoutTableView.separatorInset = UIEdgeInsetsZero;
    [self.layoutTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view).dividedBy(2);
        make.left.right.equalTo(self.view).insets(UIEdgeInsetsMake(0, 30, 0, 30));
        make.height.mas_equalTo(self.layoutTableView.rowHeight*2);
    }];
    
    UILabel *promptLabel = [[UILabel alloc] init];
    promptLabel.text = @"进入后不能修改以上信息";
    promptLabel.textColor = [UIColor redColor];
    promptLabel.font = [UIFont systemFontOfSize:14.];
    [self.view addSubview:promptLabel];
    {
        [promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.layoutTableView.mas_bottom).offset(5);
            make.centerX.equalTo(self.layoutTableView);
        }];
    }
    
    YPBActionButton *nextButton = [[YPBActionButton alloc] initWithTitle:@"下一步" action:^(id sender) {
        @strongify(self);
        [self registerNext];
    }];
    
    [self.view addSubview:nextButton];
    {
        [nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.layoutTableView);
            make.top.equalTo(promptLabel.mas_bottom).offset(30);
            make.height.mas_equalTo(self.layoutTableView.rowHeight);
        }];
    }
    
    [self initLayoutCells];
}

- (void)initLayoutCells {
    [self initGenderCell];
    [self initNicknameCell];
}

- (void)initGenderCell {
    UITableViewCell *genderCell = [[UITableViewCell alloc] init];
    genderCell.selectionStyle = UITableViewCellSelectionStyleNone;
    [self setLayoutCell:genderCell cellHeight:MAX(kScreenHeight * 0.08, 50) inRow:0 andSection:0];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"性别";
    titleLabel.font = [UIFont systemFontOfSize:15.];
    [genderCell addSubview:titleLabel];
    {
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(genderCell);
            make.left.equalTo(genderCell).offset(15);
            make.width.mas_equalTo(35);
        }];
    }
    
    YPBRadioButton *maleButton = [[YPBRadioButton alloc] init];
    [maleButton setImage:[UIImage imageNamed:@"gender_normal"] forState:UIControlStateNormal];
    [maleButton setImage:[UIImage imageNamed:@"gender_selected"] forState:UIControlStateSelected];
    maleButton.title = @"男";
    [genderCell addSubview:maleButton];
    {
        [maleButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(genderCell);
            make.left.equalTo(titleLabel.mas_right).offset(20);
            make.size.mas_equalTo(CGSizeMake(35, 15));
        }];
    }
    
    YPBRadioButton *femaleButton = [[YPBRadioButton alloc] init];
    [femaleButton setImage:[UIImage imageNamed:@"gender_normal"] forState:UIControlStateNormal];
    [femaleButton setImage:[UIImage imageNamed:@"gender_selected"] forState:UIControlStateSelected];
    femaleButton.title = @"女";
    [genderCell addSubview:femaleButton];
    {
        [femaleButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(genderCell);
            make.left.equalTo(maleButton.mas_right).offset(50);
            make.size.equalTo(maleButton);
        }];
    }
    
    self.genderButtonGroup = [YPBRadioButtonGroup groupWithRadioButtons:@[maleButton,femaleButton]];
}

- (void)initNicknameCell {
    UITableViewCell *nicknameCell = [[UITableViewCell alloc] init];
    nicknameCell.selectionStyle = UITableViewCellSelectionStyleNone;
    [self setLayoutCell:nicknameCell cellHeight:MAX(kScreenHeight * 0.08, 50) inRow:1 andSection:0];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"昵称";
    titleLabel.font = [UIFont systemFontOfSize:15.];
    [nicknameCell addSubview:titleLabel];
    {
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(nicknameCell);
            make.left.equalTo(nicknameCell).offset(15);
            make.width.mas_equalTo(35);
        }];
    }
    
    _nicknameTextField = [[UITextField alloc] init];
    _nicknameTextField.placeholder = @"输入昵称";
    _nicknameTextField.font = [UIFont systemFontOfSize:15.];
    _nicknameTextField.delegate = self;
    _nicknameTextField.returnKeyType = UIReturnKeyNext;
    _nicknameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [nicknameCell addSubview:_nicknameTextField];
    {
        [_nicknameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(titleLabel.mas_right).offset(20);
            make.top.right.bottom.equalTo(nicknameCell).insets(UIEdgeInsetsMake(5, 0, 5, 15));
        }];
    }
}

- (void)registerNext {
    self.user.gender = [self.genderButtonGroup.selectedButton.title isEqualToString:@"男"] ? YPBUserGenderMale : YPBUserGenderFemale;
    self.user.nickName = _nicknameTextField.text;
    
    NSError *error = [self.user validate];
    if (error) {
        [[YPBMessageCenter defaultCenter] showErrorWithTitle:error.userInfo[kErrorMessageKeyName] inViewController:self];
        [_nicknameTextField becomeFirstResponder];
        return ;
    }
    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [_nicknameTextField resignFirstResponder];
//    });
    
    [self->_nicknameTextField resignFirstResponder];
    
    @weakify(self);
    void (^ConfirmAction)(void) = ^{
        @strongify(self);
        YPBReigsterSecondViewController *registerSecondVC = [[YPBReigsterSecondViewController alloc] initWithYPBUser:self.user];
        [self.navigationController pushViewController:registerSecondVC animated:YES];
    };
    
    void (^CancelAction)(void) = ^{
        @strongify(self);
        [self->_nicknameTextField becomeFirstResponder];
    };
    
    if (NSStringFromClass([UIAlertController class])) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"信息确认" message:@"注册后，性别和昵称将无法修改。是否确认？" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [alertController dismissViewControllerAnimated:YES completion:nil];
            CancelAction();
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [alertController dismissViewControllerAnimated:YES completion:nil];
            ConfirmAction();
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] bk_initWithTitle:@"信息确认" message:@"注册后，性别和昵称将无法修改。是否确认？"];
        [alertView bk_setCancelButtonWithTitle:@"取消" handler:^{
            CancelAction();
        }];
        [alertView bk_addButtonWithTitle:@"确定" handler:^{
            ConfirmAction();
        }];
        [alertView show];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self registerNext];
    return YES;
}

- (BOOL)disablesAutomaticKeyboardDismissal {
    return NO;
}
@end
