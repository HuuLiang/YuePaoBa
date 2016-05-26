//
//  YPBAccountViewController.m
//  YuePaoBa
//
//  Created by Liang on 16/5/24.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "YPBAccountViewController.h"
#import "YPBActionButton.h"
#import "YPBRegisterAccountViewController.h"
#import "YPBSystemConfig.h"
#import "WXApi.h"
#import "YPBAppDelegate.h"
#import "YPBWeChatURLRequest.h"

@interface YPBAccountViewController () <UITextFieldDelegate,checkRegisterWeChatDelegate,WXApiDelegate>
{
    UILabel *_title;
    
    UILabel *_accountLabel;
    UITextField *_account;
    UIButton *_closeBtnA;
    
    UILabel *_passwordLabel;
    UITextField *_password;
    UIButton *_closeBtnB;
    
    UIButton *_registerBtn;
    
    UILabel *_notiLabel;
    CAShapeLayer *_lineC;
    CAShapeLayer *_lineD;
}
@property (nonatomic,retain) YPBWeChatURLRequest *request;
@end
@implementation YPBAccountViewController

DefineLazyPropertyInitialization(YPBWeChatURLRequest, request)


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    UIImageView *view = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loginImg.jpg"]];
    [self.view addSubview:view];
    {
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.top.equalTo(self.view);
        }];
    }
    
    [self initSubViews];
}

- (void)initSubViews {
    [self initTitle];
    [self initAccount];
    [self initEnterBtn];
    [self initOtherLogin];
    
}

- (void)initTitle {
    _title = [[UILabel alloc] init];
    _title.text = @"登录账号";
    _title.textColor = [UIColor whiteColor];
    _title.font = [UIFont systemFontOfSize:22.];
    _title.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_title];
    {
        [_title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.top.equalTo(self.view).offset(SCREEN_HEIGHT/15);
            make.height.mas_equalTo(40);
        }];
    }
}


- (void)initAccount {
    _accountLabel = [[UILabel alloc] init];
    _accountLabel.backgroundColor = [UIColor clearColor];
    _accountLabel.text = @"账号:";
    _accountLabel.textColor = [UIColor whiteColor];
    _accountLabel.font = [UIFont systemFontOfSize:15.];
    [self.view addSubview:_accountLabel];
 
    _account = [[UITextField alloc] init];
    _account.backgroundColor = [UIColor clearColor];
//    _account.placeholder = @"请输入用户名/账号ID";
    _account.textColor = [UIColor whiteColor];
//    [_account setValue:[UIColor colorWithHexString:@"#989994"] forKeyPath:@"_placeholderLabel.textColor"];
//    [_account setValue:[UIFont systemFontOfSize:16.] forKeyPath:@"_placeholderLabel.font"];
    _account.textAlignment = NSTextAlignmentRight;
    _account.delegate = self;
    _account.returnKeyType = UIReturnKeyContinue;
    _account.clearButtonMode = UITextFieldViewModeNever;
    [self.view addSubview:_account];
    
    _closeBtnA = [UIButton buttonWithType:UIButtonTypeSystem];
    [_closeBtnA setBackgroundImage:[UIImage imageNamed:@"account_close"] forState:UIControlStateNormal];
    _closeBtnA.layer.cornerRadius = 17.5;
    _closeBtnA.layer.masksToBounds = YES;
    [self.view addSubview:_closeBtnA];
    {
        [_closeBtnA bk_whenTapped:^{
            _account.text = @"";
        }];
        
        [_accountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(20);
            make.top.equalTo(_title.mas_bottom).offset(SCREEN_HEIGHT/20);
            make.width.mas_equalTo(35);
            make.height.mas_equalTo(45);
        }];
        
        [_account mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_accountLabel.mas_right).offset(20);
            make.centerY.equalTo(_accountLabel.mas_centerY);
            make.height.mas_equalTo(45);
        }];
        
        [_closeBtnA mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_account.mas_right).offset(5);
            make.centerY.equalTo(_account);
            make.right.equalTo(self.view).offset(-20);
            make.size.mas_equalTo(CGSizeMake(35, 35));
        }];
    }
    
    _passwordLabel = [[UILabel alloc] init];
    _passwordLabel.text = @"密码:";
    _passwordLabel.font = [UIFont systemFontOfSize:15.];
    _passwordLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:_passwordLabel];
    
    _password = [[UITextField alloc] init];
    _password.backgroundColor = [UIColor clearColor];
    _password.textColor = [UIColor whiteColor];
//    _password.placeholder = @"请输入密码";
//    [_password setValue:[UIColor colorWithHexString:@"#989994"] forKeyPath:@"_placeholderLabel.textColor"];
//    [_password setValue:[UIFont systemFontOfSize:16.] forKeyPath:@"_placeholderLabel.font"];
    _password.textAlignment = NSTextAlignmentRight;
    _password.delegate = self;
    _password.returnKeyType = UIReturnKeyGoogle;
    _password.clearButtonMode = UITextFieldViewModeNever;
    [self.view addSubview:_password];
    
    _closeBtnB = [UIButton buttonWithType:UIButtonTypeSystem];
    [_closeBtnB setBackgroundImage:[UIImage imageNamed:@"account_close"] forState:UIControlStateNormal];
    _closeBtnB.layer.cornerRadius = 17.5;
    _closeBtnB.layer.masksToBounds = YES;
    [self.view addSubview:_closeBtnB];
    {
        [_closeBtnB bk_whenTapped:^{
            _password.text = @"";
        }];
        
        [_passwordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(20);
            make.top.equalTo(_accountLabel.mas_bottom).offset(15);
            make.width.mas_equalTo(35);
            make.height.mas_equalTo(45);
        }];
        
        [_password mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_passwordLabel.mas_right).offset(20);
            make.top.equalTo(_account.mas_bottom).offset(15);
            make.height.mas_equalTo(45);
        }];
        
        [_closeBtnB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_password.mas_right).offset(5);
            make.centerY.equalTo(_password);
            make.right.equalTo(self.view).offset(-20);
            make.size.mas_equalTo(CGSizeMake(35, 35));
        }];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated {
//    DLog("%@",NSStringFromCGRect(_closeBtnA.frame));
    CAShapeLayer *lineA = [CAShapeLayer layer];
    CGMutablePathRef linePathA = CGPathCreateMutable();
    [lineA setFillColor:[[UIColor clearColor] CGColor]];
    [lineA setStrokeColor:[[UIColor whiteColor] CGColor]];
    lineA.lineWidth = 0.5f;
    CGPathMoveToPoint(linePathA, NULL, _accountLabel.frame.origin.x , _accountLabel.frame.origin.y + _accountLabel.frame.size.height + 5);
    CGPathAddLineToPoint(linePathA, NULL, _closeBtnA.frame.origin.x + _closeBtnA.frame.size.width, _closeBtnA.frame.origin.y + _closeBtnA.frame.size.height + 10);
    [lineA setPath:linePathA];
    CGPathRelease(linePathA);
    [self.view.layer addSublayer:lineA];
    
    CAShapeLayer *lineB = [CAShapeLayer layer];
    CGMutablePathRef linePathB = CGPathCreateMutable();
    [lineB setFillColor:[[UIColor clearColor] CGColor]];
    [lineB setStrokeColor:[[UIColor whiteColor] CGColor]];
    lineB.lineWidth = 0.5f;
    CGPathMoveToPoint(linePathB, NULL, _passwordLabel.frame.origin.x , _passwordLabel.frame.origin.y + _passwordLabel.frame.size.height + 5);
    CGPathAddLineToPoint(linePathB, NULL, _closeBtnB.frame.origin.x + _closeBtnB.frame.size.width, _closeBtnB.frame.origin.y + _closeBtnB.frame.size.height + 10);
    [lineB setPath:linePathB];
    CGPathRelease(linePathB);
    [self.view.layer addSublayer:lineB];
}

- (void)initEnterBtn {
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    loginBtn.layer.cornerRadius = 5;
    loginBtn.backgroundColor = [UIColor whiteColor];
    loginBtn.layer.masksToBounds = YES;
    [self.view addSubview:loginBtn];
    {
        [loginBtn bk_whenTapped:^{
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

        }];
    }
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"还没账号，立刻";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:12.];
    label.backgroundColor = [UIColor clearColor];
    [self.view addSubview:label];
    
    _registerBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [_registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    [_registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _registerBtn.backgroundColor = [UIColor clearColor];
    _registerBtn.layer.cornerRadius = 5;
    _registerBtn.layer.borderWidth = 0.5;
    _registerBtn.layer.borderColor = [[UIColor whiteColor] CGColor];
    _registerBtn.layer.masksToBounds = YES;
    [self.view addSubview:_registerBtn];
    
    {
        [_registerBtn bk_whenTapped:^{
            YPBRegisterAccountViewController *registerView = [[YPBRegisterAccountViewController alloc] init];
            [self.navigationController pushViewController:registerView animated:YES];
        }];
    }
    {
        [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(20);
            make.right.equalTo(self.view).offset(-20);
            make.top.equalTo(_password.mas_bottom).offset(20);
            make.height.mas_offset(50);
        }];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.top.equalTo(loginBtn.mas_bottom).offset(10);
            make.height.mas_equalTo(20);
        }];
        
        [_registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(20);
            make.right.equalTo(self.view).offset(-20);
            make.top.equalTo(label.mas_bottom).offset(5);
            make.height.mas_equalTo(50);
        }];
    }
}

- (void)initOtherLogin {
    _notiLabel = [[UILabel alloc] init];
    _notiLabel.text = @"您还可以使用别的登录方式";
    _notiLabel.font = [UIFont systemFontOfSize:12.];
    _notiLabel.textColor = [UIColor whiteColor];
    _notiLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_notiLabel];
    
    
    UIImageView *wxImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"account_wxImg"]];
    wxImg.layer.cornerRadius = SCREEN_WIDTH/12;
    wxImg.layer.masksToBounds = YES;
    wxImg.userInteractionEnabled = YES;
    [self.view addSubview:wxImg];
    {
        [wxImg bk_whenTapped:^{
            SendAuthReq *req = [[SendAuthReq alloc] init];
            req.scope = @"snsapi_userinfo";
            req.state = @"123";
            req.openID = @"000";
            [WXApi sendReq:req];
        }];
    }
    
    {
        [_notiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.view.mas_bottom).offset(-110);
            make.centerX.equalTo(self.view);
            make.size.mas_equalTo(CGSizeMake(150, 20));
        }];
        
        [wxImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.top.equalTo(_notiLabel.mas_bottom).offset(10);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH/6, SCREEN_WIDTH/6));
        }];
    }
}

- (void)viewDidLayoutSubviews {
    if (_notiLabel != nil) {
        _lineC = [CAShapeLayer layer];
        CGMutablePathRef linePathC = CGPathCreateMutable();
        [_lineC setFillColor:[[UIColor clearColor] CGColor]];
        [_lineC setStrokeColor:[[UIColor whiteColor] CGColor]];
        _lineC.lineWidth = 0.5f;
        CGPathMoveToPoint(linePathC, NULL, 0, _notiLabel.center.y);
        CGPathAddLineToPoint(linePathC, NULL, _notiLabel.frame.origin.x, _notiLabel.center.y);
        [_lineC setPath:linePathC];
        CGPathRelease(linePathC);
        [self.view.layer addSublayer:_lineC];
        
        _lineD = [CAShapeLayer layer];
        CGMutablePathRef linePathD = CGPathCreateMutable();
        [_lineD setFillColor:[[UIColor clearColor] CGColor]];
        [_lineD setStrokeColor:[[UIColor whiteColor] CGColor]];
        _lineD.lineWidth = 0.5f;
        CGPathMoveToPoint(linePathD, NULL, _notiLabel.frame.origin.x + _notiLabel.frame.size.width, _notiLabel.center.y);
        CGPathAddLineToPoint(linePathD, NULL, SCREEN_WIDTH, _notiLabel.center.y);
        [_lineD setPath:linePathD];
        CGPathRelease(linePathD);
        [self.view.layer addSublayer:_lineD];
    }
}

#pragma mark checkRegisterWeChatDelegate

- (void)checkRegisterWeChat {
    if ([WXApi isWXAppInstalled]) {
        [self initOtherLogin];
    }
}

- (void)sendAuthRespCode:(SendAuthResp *)resp {
    if (resp.errCode == 0) {
       [self.request requestWeChatAccessTokenWithInfo:resp.code responseHandler:^(NSDictionary *dic, NSError *error) {
           DLog("%@ %@",dic,error);
           if (dic != nil) {
               [self.request requesWeChatUserInfoWithTokenDic:dic responseHandler:^(NSDictionary *userDic, NSError *error) {
                   DLog("%@ %@",userDic,error);
               }];
           }
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
