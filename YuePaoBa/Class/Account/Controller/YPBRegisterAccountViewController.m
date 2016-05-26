//
//  YPBRegisterAccountViewController.m
//  YuePaoBa
//
//  Created by Liang on 16/5/25.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "YPBRegisterAccountViewController.h"
#import "YPBActionButton.h"

@interface YPBRegisterAccountViewController () <UITextFieldDelegate>
{
    UITextField *_account;
    UITextField *_password;
}
@end

@implementation YPBRegisterAccountViewController

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
        make.height.mas_equalTo(self.layoutTableView.rowHeight*2);
    }];
    
    [self initCells];
    [self initEnterBtn];
}

- (void)initCells {
    [self initAccountCell];
    [self initPasswordCell];
}

- (void)initEnterBtn {
    YPBActionButton *nextButton = [[YPBActionButton alloc] initWithTitle:@"确认注册" action:^(id sender) {
        [self login];
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

- (void)login {
    //输入内容合法性判断  账号判断
    if (_account.text.length == 0) {
        YPBShowWarning(@"请输入正确的帐号");
    } else {
        //密码判断
        if (_password.text.length == 0) {
            YPBShowWarning(@"请输入正确的密码");
        } else {
            //向服务器发送登录请求
            
            //返回成功 跳转首页
            [self dismissViewControllerAnimated:YES completion:nil];
            [YPBUtil notifyRegisterSuccessfully];
            //返回失败 返回错误原因 用户名不存在 or 密码错误
        }
    }
}

- (void)initAccountCell {
    UITableViewCell *accountCell = [[UITableViewCell alloc] init];
    accountCell.backgroundColor = [UIColor colorWithHexString:@"#fffffd"];
    accountCell.selectionStyle = UITableViewCellSelectionStyleNone;
    [self setLayoutCell:accountCell cellHeight:MAX(kScreenHeight * 0.08, 50) inRow:0 andSection:0];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"账号";
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
    _account.placeholder = @"请输入用户名/账号ID";
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
    [self setLayoutCell:passwordCell cellHeight:MAX(kScreenHeight * 0.08, 50) inRow:1 andSection:0];
    
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
