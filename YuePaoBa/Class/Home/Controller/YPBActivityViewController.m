//
//  YPBActivityViewController.m
//  YuePaoBa
//
//  Created by Liang on 16/5/10.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "YPBActivityViewController.h"
#import "YPBUser.h"
#import "YPBVIPPriviledgeViewController.h"
#import "YPBMessageCenter.h"
#import "YPBUserDetailUpdateModel.h"

@interface YPBActivityViewController ()
{
    UIImageView *_bannerView;
}
@property (nonatomic,retain) YPBUserDetailUpdateModel *updateModel;

@end

@implementation YPBActivityViewController

DefineLazyPropertyInitialization(YPBUserDetailUpdateModel, updateModel)

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"话费兑换";

    self.view.backgroundColor = [UIColor colorWithHexString:@"#f6f7ec"];
    
    _bannerView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bannerImg.jpg"]];
    [self.view addSubview:_bannerView];
    {
        [_bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.top.equalTo(self.view).offset(64);
            make.height.equalTo(@(SCREEN_WIDTH/2.22));
        }];
    }
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"领取话费" forState:UIControlStateNormal];
    button.layer.cornerRadius = 5;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor colorWithHexString:@"#ee8188"];
    [button bk_whenTapped:^{
        [button removeFromSuperview];
        if ([YPBUser currentUser].isVip) {
            [self popPhoneNumberView];
        } else {
            [self popVIPNoti];
        }
//        [self popPhoneNumberView];
    }];
    [self.view addSubview:button];
    {
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.top.equalTo(_bannerView.mas_bottom).offset(15);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH*0.9, 50));
        }];
    }
    
    UIView *serveView = [[UIView alloc] init];
    serveView.backgroundColor = [UIColor colorWithHexString:@"00a9f5"];
    serveView.userInteractionEnabled = YES;
    serveView.layer.cornerRadius = 25;
    [self.view addSubview:serveView];
    {
        [serveView bk_whenTapped:^{
           //弹出客服联系方式
            [UIAlertView bk_showAlertViewWithTitle:@"咨询客服QQ:2686229951\n投诉客服QQ:3153715820" message:@"工作时间:每周一至周五10:00-18:00" cancelButtonTitle:@"确定" otherButtonTitles:nil handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                
            }];
        }];
    }

    UIImageView *serveImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"serveImg"]];
    serveImg.transform = CGAffineTransformMakeScale(1.0, 1.0);
    [serveView addSubview:serveImg];
    
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:13.];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"联系客服";
    [self.view addSubview:label];
    
    {
        [serveView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.view).offset(-20);
            make.bottom.equalTo(self.view).offset(-30);
            make.size.mas_equalTo(CGSizeMake(50, 50));
        }];
        
        [serveImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(serveView);
        }];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(serveView);
            make.top.equalTo(serveView.mas_bottom).offset(0);
            make.size.mas_equalTo(CGSizeMake(100, 15));
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)popPhoneNumberView {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.3];
    view.layer.borderColor = [UIColor colorWithHexString:@"d9dad5"].CGColor;
    view.layer.borderWidth = 1;
    view.layer.masksToBounds = YES;
    [self.view addSubview:view];
    {
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.top.equalTo(_bannerView.mas_bottom).offset(15);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH*1.01, 60));
        }];
    }
    
    UITextField *textField = [[UITextField alloc] init];
    textField.placeholder = @"  请输入您需要兑换的手机号码";
    textField.font = [UIFont systemFontOfSize:15.];
    [view addSubview:textField];
    {
        [textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view).offset(10);
            make.top.bottom.equalTo(view);
            make.width.equalTo(@(SCREEN_WIDTH*0.7-10));
        }];
    }
    
    UILabel *line = [[UILabel alloc] init];
    line.backgroundColor = [UIColor lightGrayColor];
    line.alpha = 0.5;
    [view addSubview:line];
    {
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(textField.mas_right).offset(5);
            make.centerY.equalTo(view);
            make.size.mas_equalTo(CGSizeMake(1, 40));
        }];
    }
    
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    saveBtn.backgroundColor = [UIColor colorWithHexString:@"#ee8188"];
    [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    saveBtn.layer.cornerRadius = 3;
    [view addSubview:saveBtn];
    {
        [saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(line.mas_right).offset(10);
            make.centerY.equalTo(view);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH*0.25, 30));
        }];
    }
    
    [saveBtn bk_whenTapped:^{
        if (textField.text.length != 11) {
            YPBShowError(@"请输入正确的号码！");
        } else {
            NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
            NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
            NSString *CT_NUM = @"^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$";
            
            NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
            BOOL isMatch1 = [pred1 evaluateWithObject:textField.text];
            NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
            BOOL isMatch2 = [pred2 evaluateWithObject:textField.text];
            NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
            BOOL isMatch3 = [pred3 evaluateWithObject:textField.text];
            
            if (isMatch1 || isMatch2 || isMatch3) {
                [view removeFromSuperview];
                [self.updateModel updateUserPhoneWithUserID:[YPBUser currentUser].userId
                                                      Phone:textField.text withCompletionHandler:^(BOOL success, id obj)
                {
                    if (success) {
                        [self popSuccessWithInfo:textField.text];
                    }
                }];
                //上传数据到服务器
            } else {
                YPBShowError(@"请输入正确的号码！");
            }
        }
    }];
}

- (void)popVIPNoti {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
    view.layer.cornerRadius = 10;
    view.layer.borderColor = [UIColor lightGrayColor].CGColor;
    view.layer.borderWidth = 1;
    view.layer.masksToBounds = YES;
    
    [self.view addSubview:view];
    {
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.top.equalTo(_bannerView.mas_bottom).offset(15);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH*0.7, 120));
        }];
    }
    
    UILabel *label = [[UILabel alloc] init];
    label.text =@"您不是VIP用户，无法领取话费";
    label.font = [UIFont systemFontOfSize:15.];
    label.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label];
    {
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(view);
            make.top.equalTo(view).offset(15);
            make.height.equalTo(@(20));
        }];
    }
    
    UIButton *vipBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [vipBtn setTitle:@"立即开通" forState:UIControlStateNormal];
    [vipBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    vipBtn.layer.cornerRadius = 5;
    vipBtn.backgroundColor = [UIColor colorWithHexString:@"#ee8188"];
    [view addSubview:vipBtn];
    {
        [vipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(view);
            make.top.equalTo(label.mas_bottom).offset(20);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH*0.5, 40));
        }];
    }
    [vipBtn bk_whenTapped:^{
        YPBVIPPriviledgeViewController *vipVC = [[YPBVIPPriviledgeViewController alloc] initWithContentType:YPBPaymnetContentTypeActivity];
        [self.navigationController pushViewController:vipVC animated:YES];
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view becomeFirstResponder];
}

- (void)popSuccessWithInfo:(NSString *)info {
    UILabel *label = [[UILabel alloc] init];
    label.text = [NSString stringWithFormat:@"您已成功绑定 %@ 的手机",info];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:15.];
    label.backgroundColor = [UIColor blackColor];
    label.alpha= 0.5;
    label.layer.cornerRadius = 8;
    label.layer.masksToBounds = YES;
    [self.view addSubview:label];
    {
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.top.equalTo(_bannerView.mas_bottom).offset(30);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH*0.8, 60));
        }];
    }
}

//- (void)drawRect:(CGRect)rect {
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetLineCap(context, kCGLineCapSquare);
//    CGContextSetLineWidth(context, 2.0);
//    CGContextSetRGBStrokeColor(context, 0.314, 0.486, 0.859, 1.0);
//    CGContextBeginPath(context);
//    CGContextMoveToPoint(context, SCREEN_WIDTH*0.72, _bannerView.frame.origin.y + 200);
//    CGContextAddLineToPoint(context, SCREEN_WIDTH*0.72, _bannerView.frame.origin.y+450);
//    CGContextStrokePath(context);
//}

@end
