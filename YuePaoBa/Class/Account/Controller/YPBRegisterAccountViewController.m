//
//  YPBRegisterAccountViewController.m
//  YuePaoBa
//
//  Created by Liang on 16/5/25.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "YPBRegisterAccountViewController.h"
#import "YPBActionButton.h"
#import "YPBWebViewController.h"
#import "YPBRadioButton.h"
#import "YPBRadioButtonGroup.h"
#import "YPBReigsterSecondViewController.h"

@interface YPBRegisterAccountViewController () <UITextFieldDelegate>
{
    UITextField *_account;
    UITextField *_password;
}
@property (nonatomic,retain) YPBRadioButtonGroup *genderButtonGroup;
@property (nonatomic) YPBUser *user;


@end

@implementation YPBRegisterAccountViewController

DefineLazyPropertyInitialization(YPBUser, user)

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = NO;
    self.title = @"注册";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f6f7ec"];
    
    self.layoutTableView.userInteractionEnabled = YES;
    self.layoutTableView.layer.cornerRadius = 5;
    
    self.layoutTableView.rowHeight = MAX(kScreenHeight * 0.08, 50);
    self.layoutTableView.scrollEnabled = NO;
    self.layoutTableView.separatorInset = UIEdgeInsetsZero;
    self.layoutTableView.backgroundColor = [UIColor colorWithHexString:@"#fffffd"];
    [self.layoutTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view).dividedBy(3);
        make.left.right.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
        make.height.mas_equalTo(self.layoutTableView.rowHeight*3);
    }];
    
    [self initCells];
    [self initEnterBtn];
    [self initRegisterProtocol];
    
}

- (void)initCells {
    [self initAccountCell];
    [self initPasswordCell];
    [self initGenderCell];
}

- (void)initEnterBtn {
    YPBActionButton *nextButton = [[YPBActionButton alloc] initWithTitle:@"确认注册" action:^(id sender) {
        self.user.gender = [self.genderButtonGroup.selectedButton.title isEqualToString:@"男"] ? YPBUserGenderMale : YPBUserGenderFemale;

        [self registerUser];
    }];
    nextButton.backgroundColor = [UIColor colorWithHexString:@"#ee8838"];
    [self.view addSubview:nextButton];
    {
        [nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view).insets(UIEdgeInsetsMake(0, 20, 0, 20));
            make.top.equalTo(self.layoutTableView.mas_bottom).offset(30);
            make.height.mas_equalTo(self.layoutTableView.rowHeight);
        }];
    }
}

- (void)registerUser {
    if (_account.text.length < 3) {
        YPBShowWarning(@"昵称不能为空");
        return;
    }
    
    if (_password.text.length < 3) {
        YPBShowWarning(@"请设置密码");
        return;
    }
    
    self.user.nickName = _account.text;
    self.user.password = _password.text;
    
    YPBReigsterSecondViewController *secondVC = [[YPBReigsterSecondViewController alloc] initWithYPBUser:self.user];
    [self.navigationController pushViewController:secondVC animated:YES];
}


- (void)initGenderCell {
    UITableViewCell *genderCell = [[UITableViewCell alloc] init];
    
    genderCell.backgroundColor = [UIColor colorWithHexString:@"#fffffd"];
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
            make.left.equalTo(titleLabel.mas_right).offset(30);
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


- (void)initAccountCell {
    UITableViewCell *accountCell = [[UITableViewCell alloc] init];
    accountCell.backgroundColor = [UIColor colorWithHexString:@"#fffffd"];
    accountCell.selectionStyle = UITableViewCellSelectionStyleNone;
    [self setLayoutCell:accountCell cellHeight:MAX(kScreenHeight * 0.08, 50) inRow:1 andSection:0];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"昵称";
    titleLabel.font = [UIFont systemFontOfSize:15.];
    [accountCell addSubview:titleLabel];
    {
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(accountCell);
            make.left.equalTo(accountCell).offset(15);
            make.width.mas_equalTo(35);
        }];
    }
    _account = [[UITextField alloc] init];
    _account.placeholder = @"请输入昵称";
    [_account setValue:[UIColor colorWithHexString:@"#989994"] forKeyPath:@"_placeholderLabel.textColor"];
    [_account setValue:[UIFont systemFontOfSize:16.] forKeyPath:@"_placeholderLabel.font"];
    _account.textAlignment = NSTextAlignmentRight;
    _account.delegate = self;
    _account.returnKeyType = UIReturnKeyContinue;
    _account.clearButtonMode = UITextFieldViewModeWhileEditing;
    [accountCell addSubview:_account];
    {
        [_account mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(titleLabel.mas_right).offset(20);
            make.top.right.bottom.equalTo(accountCell).insets(UIEdgeInsetsMake(5, 0, 5, 15));
        }];
    }
}

- (void)initPasswordCell {
    UITableViewCell *passwordCell = [[UITableViewCell alloc] init];
    passwordCell.backgroundColor = [UIColor colorWithHexString:@"#fffffd"];
    passwordCell.selectionStyle = UITableViewCellSelectionStyleNone;
    [self setLayoutCell:passwordCell cellHeight:MAX(kScreenHeight * 0.08, 50) inRow:2 andSection:0];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"密码";
    titleLabel.font = [UIFont systemFontOfSize:15.];
    [passwordCell addSubview:titleLabel];
    {
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(passwordCell);
            make.left.equalTo(passwordCell).offset(15);
            make.width.mas_equalTo(35);
        }];
    }
    
    _password = [[UITextField alloc] init];
    _password.placeholder = @"请输入密码";
    [_password setValue:[UIColor colorWithHexString:@"#989994"] forKeyPath:@"_placeholderLabel.textColor"];
    [_password setValue:[UIFont systemFontOfSize:16.] forKeyPath:@"_placeholderLabel.font"];
    _password.textAlignment = NSTextAlignmentRight;
    _password.delegate = self;
    _password.returnKeyType = UIReturnKeyGoogle;
    _password.clearButtonMode = UITextFieldViewModeWhileEditing;
    [passwordCell addSubview:_password];
    {
        [_password mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(titleLabel.mas_right).offset(20);
            make.top.right.bottom.equalTo(passwordCell).insets(UIEdgeInsetsMake(5, 0, 5, 15));
        }];
    }
}

- (void)initRegisterProtocol {
    UIButton *agreementButton = [[UIButton alloc] init];
    NSString *appName = [NSBundle mainBundle].infoDictionary[@"CFBundleDisplayName"];
    NSMutableAttributedString *agreementTitle = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"《%@许可及服务协议》",appName]
                                                                                       attributes:@{NSForegroundColorAttributeName:[UIColor redColor],
                                                                                                    NSFontAttributeName:[UIFont systemFontOfSize:14.]}];
    [agreementTitle addAttribute:NSUnderlineStyleAttributeName value:@1 range:NSMakeRange(1, agreementTitle.string.length-2)];
    [agreementButton setAttributedTitle:agreementTitle forState:UIControlStateNormal];
    [self.view addSubview:agreementButton];
    {
        [agreementButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.bottom.equalTo(self.view).offset(-15);
        }];
    }
    
    [agreementButton bk_addEventHandler:^(id sender) {
        YPBWebViewController *webVC = [[YPBWebViewController alloc] initWithURL:[NSURL URLWithString:YPB_AGREEMENT_URL]];
        webVC.title = @"用户协议";
        [self.navigationController pushViewController:webVC animated:YES];
    } forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *agreementLabel = [[UILabel alloc] init];
    agreementLabel.font = [UIFont systemFontOfSize:14.];
//    agreementLabel.textColor = [UIColor blackColor];
    agreementLabel.text = @"轻触上面的\"确定注册\"按钮，即表示你同意";
    [self.view addSubview:agreementLabel];
    {
        [agreementLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.bottom.equalTo(agreementButton.mas_top).offset(-2);
        }];
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_account resignFirstResponder];
    [_password resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [_password becomeFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (BOOL)disablesAutomaticKeyboardDismissal {
    return NO;
}

@end
