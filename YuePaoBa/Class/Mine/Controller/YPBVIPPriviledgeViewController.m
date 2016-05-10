//
//  YPBVIPPriviledgeViewController.m
//  YuePaoBa
//
//  Created by Sean Yue on 15/12/22.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import "YPBVIPPriviledgeViewController.h"
#import "YPBUserVIPUpgradeModel.h"
#import "YPBVIPPriceButton.h"
#import "YPBPaymentPopView.h"
#import "YPBPaymentInfo.h"
#import "WeChatPayManager.h"
#import "YPBPaymentModel.h"
#import "AlipayManager.h"
#import "YPBPaymentIssueReportViewController.h"
#import "YPBPayCell.h"
#import "YPBPayIntroduceView.h"


@interface YPBVIPPriviledgeViewController () <UITableViewDelegate,UITableViewDataSource>
{
    UIImageView *_backgroundImageView;
    UIButton *_feedbackButton;
    YPBPayIntroduceView *_introduceView;
    NSMutableArray *_dataSource;
    UITableView *_payTableView;
    UIView *_labelView;
    NSTimer * _timer;
    NSInteger _count;
}
@property (nonatomic,retain) YPBUserVIPUpgradeModel *vipUpgradeModel;
@property (nonatomic,retain) YPBPaymentInfo *paymentInfo;
@property (nonatomic,retain) YPBPaymentPopView *paymentPopView;
@property (nonatomic) NSMutableArray *userNames;
@end

@implementation YPBVIPPriviledgeViewController

DefineLazyPropertyInitialization(YPBUserVIPUpgradeModel, vipUpgradeModel)
DefineLazyPropertyInitialization(NSMutableArray, userNames);

- (instancetype)initWithContentType:(YPBPaymentContentType)contentType {
    self = [super init];
    if (self) {
        _contentType = contentType;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"会员支付";
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f6f7ec"];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    _dataSource = [[NSMutableArray alloc] init];
    NSString *oneMonth = @"one";
    NSString *threeMonth = @"three";
    [_dataSource addObject:threeMonth];
    [_dataSource addObject:oneMonth];

    UILabel *notiLabel = [[UILabel alloc] init];
    notiLabel.text = @"开通VIP可24小时无限制聊天";
    notiLabel.textAlignment = NSTextAlignmentCenter;
    notiLabel.font = [UIFont systemFontOfSize:14.];
    notiLabel.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:notiLabel];
    
    _backgroundImageView = [[UIImageView alloc] init];
    _backgroundImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [_backgroundImageView sd_setImageWithURL:[NSURL URLWithString:[YPBSystemConfig sharedConfig].payImgUrl]
                            placeholderImage:[UIImage imageNamed:@"vip_page"]];
    DLog("------userid---%@--",[YPBUser currentUser].userId);
    _backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:_backgroundImageView];
    
    //购买选项
    _payTableView = [[UITableView alloc] init];
    _payTableView.scrollEnabled = NO;
    _payTableView.delegate = self;
    _payTableView.dataSource = self;
    [_payTableView registerClass:[YPBPayCell class] forCellReuseIdentifier:@"cellID"];
    
    UIView *payHearderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 23)];
    payHearderView.backgroundColor = [UIColor clearColor];
    UILabel *paylabel = [[UILabel alloc] init];
    paylabel.textColor = [UIColor grayColor];
    paylabel.text = @"   选择钻石VIP套餐";
    [payHearderView addSubview:paylabel];
    _payTableView.tableHeaderView = payHearderView;
    [self.view addSubview:_payTableView];
    {
        [paylabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(payHearderView);
            make.centerY.equalTo(payHearderView);
        }];
    }
    
    //会员特权说明
    _introduceView = [[YPBPayIntroduceView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
    [self.view addSubview:_introduceView];
    
    
    _labelView = [[UIView alloc] init];
    _labelView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_labelView];
    _userNames = [NSMutableArray arrayWithArray:[YPBSystemConfig sharedConfig].userNames];
    _count = 0;
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.8 target:self selector:@selector(scrollUserNames) userInfo:nil repeats:YES];
    if (_userNames.count > 0) {
        [_timer setFireDate:[NSDate distantPast]];

    }
    
    @weakify(self);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onVIPUpgradeSuccessNotification) name:kVIPUpgradeSuccessNotification object:nil];
    
    _feedbackButton = [[UIButton alloc] init];
    NSDictionary *attributes = @{NSForegroundColorAttributeName:[UIColor redColor],
                                 //NSFontAttributeName:[UIFont systemFontOfSize:16.],
                                 NSUnderlineStyleAttributeName:@1};
    NSAttributedString *feedbackTitle = [[NSAttributedString alloc] initWithString:@"如您遇到支付问题，请按此处反馈问题" attributes:attributes];
    [_feedbackButton setAttributedTitle:feedbackTitle forState:UIControlStateNormal];
    _feedbackButton.titleLabel.font = [UIFont systemFontOfSize:12.];
    [self.view addSubview:_feedbackButton];
    
    [_feedbackButton bk_addEventHandler:^(id sender) {
        @strongify(self);
        YPBPaymentIssueReportViewController *reportVC = [[YPBPaymentIssueReportViewController alloc] init];
        [self.navigationController pushViewController:reportVC animated:YES];
    } forControlEvents:UIControlEventTouchUpInside];
    
    
    {
        [notiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self.view);
            make.height.equalTo(@(15));
        }];
        
        [_backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.top.equalTo(notiLabel.mas_bottom);
            make.height.equalTo(@(SCREEN_WIDTH/4));
        }];
        
        [_payTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.top.equalTo(_backgroundImageView.mas_bottom).offset(5);
            make.height.equalTo(@(SCREEN_HEIGHT*2/11+23));
        }];
        
        [_introduceView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.top.equalTo(_payTableView.mas_bottom).offset(5);
            make.height.equalTo(@(100));
        }];
        
        [_labelView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.top.equalTo(_introduceView.mas_bottom).offset(2);
            make.bottom.equalTo(self.view).offset(-10);
        }];
        
        [_feedbackButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.bottom.equalTo(self.view).offset(0);
        }];
    }
}

- (void)scrollUserNames {
    if (_count > _userNames.count - 1) {
        _count = 0;
    } else {
        UILabel *vipLabel = [[UILabel alloc] init];
        vipLabel.font = [UIFont systemFontOfSize:15.];
        NSString *string = [NSString stringWithFormat:@"%@充值了100元,成为了尊贵的VIP用户",[YPBSystemConfig sharedConfig].userNames[_count]];
        NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:string];
        [attributedStr addAttribute:NSForegroundColorAttributeName
                              value:[UIColor redColor] range:[string rangeOfString:[YPBSystemConfig sharedConfig].userNames[_count]]];
        vipLabel.attributedText = attributedStr;
        [_labelView addSubview:vipLabel];
        {
            [vipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_labelView).offset(5);
                make.bottom.equalTo(_labelView).offset(20);
                make.size.mas_equalTo(CGSizeMake(150, 15));
            }];
        }
        [UIView animateWithDuration:5 delay:0 options:UIViewAnimationOptionCurveLinear
                         animations:^{
            vipLabel.transform = CGAffineTransformMakeTranslation(0, -_labelView.frame.size.height+5);
        } completion:^(BOOL finished) {
            [vipLabel removeFromSuperview];
        }];
    }
    _count++;
}


- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _feedbackButton.titleLabel.font = [UIFont systemFontOfSize:MIN(16,CGRectGetHeight(self.view.bounds) * 0.03)];
}

- (void)popPaymentViewWithPrice:(NSUInteger)price forMonths:(NSUInteger)months {
    
#ifdef DEBUG
    price = 1;
#endif
    self.paymentPopView = [[YPBPaymentPopView alloc] init];
    @weakify(self);
    [self.paymentPopView addPaymentWithImage:[UIImage imageNamed:@"vip_alipay_icon"] title:@"支付宝支付" available:YES action:^(id obj) {
        @strongify(self);
        [self payWithPrice:price paymentType:YPBPaymentTypeAlipay forMonths:months];
    }];
    [self.paymentPopView addPaymentWithImage:[UIImage imageNamed:@"vip_wechat_icon"] title:@"微信客户端支付" available:YES action:^(id obj) {
        @strongify(self);
        [self payWithPrice:price paymentType:YPBPaymentTypeWeChatPay forMonths:months];
    }];
    [self.paymentPopView showInView:self.view];
}

- (void)payWithPrice:(NSUInteger)price paymentType:(YPBPaymentType)paymentType forMonths:(NSUInteger)months {
    NSParameterAssert(paymentType==YPBPaymentTypeAlipay||paymentType==YPBPaymentTypeWeChatPay);
    
    YPBPaymentInfo *paymentInfo = [[YPBPaymentInfo alloc] init];
    paymentInfo.orderPrice = @(price);
    paymentInfo.paymentType = @(paymentType);
    paymentInfo.paymentResult = @(PAYRESULT_UNKNOWN);
    paymentInfo.paymentStatus = @(YPBPaymentStatusPaying);
    paymentInfo.monthsPaid = @(months);
    paymentInfo.payPointType = @(YPBPayPointTypeVIP);
    paymentInfo.contentType = @(self.contentType).stringValue;
    
    @weakify(self);
    [self.view beginLoading];
    [[YPBPaymentManager sharedManager] payWithPaymentInfo:paymentInfo completionHandler:^(BOOL success, id obj) {
        @strongify(self);
        [self.view endLoading];
        YPBPaymentInfo *paymentInfo = obj;
        PAYRESULT result = paymentInfo.paymentResult.unsignedIntegerValue;
        if (result == PAYRESULT_SUCCESS) {
            [self.paymentPopView hide];
            if (paymentInfo.contentType.integerValue == YPBPaymentContentTypeRenewVIP) {
                [[YPBMessageCenter defaultCenter] showSuccessWithTitle:@"VIP续费成功" inViewController:self];
            } else {
                [[YPBMessageCenter defaultCenter] showSuccessWithTitle:@"VIP开通成功" inViewController:self];
            }
        } else if (result == PAYRESULT_ABANDON) {
            [[YPBMessageCenter defaultCenter] showWarningWithTitle:@"已取消支付" inViewController:self];
        } else {
            [[YPBMessageCenter defaultCenter] showErrorWithTitle:@"支付失败" inViewController:self];
        }
    }];
}

- (void)payWithInfo:(NSString *)info {
    YPBSystemConfig *systemConfig = [YPBSystemConfig sharedConfig];
    NSUInteger price1Month = ((NSString *)systemConfig.vipPointDictionary[@"1"]).integerValue;
    NSUInteger price3Month = ((NSString *)systemConfig.vipPointDictionary[@"3"]).integerValue;
    @weakify(self);
    if ([info isEqualToString:@"one"]) {
        @strongify(self);
        [self popPaymentViewWithPrice:price1Month forMonths:1];
    } else if ([info isEqualToString:@"three"]) {
        @strongify(self);
        [self popPaymentViewWithPrice:price3Month forMonths:3];
    }
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YPBPayCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID" forIndexPath:indexPath];
    [cell setCellInfoWithMonth:_dataSource[indexPath.row]];
    [cell.payButton bk_addEventHandler:^(id sender) {
        [self payWithInfo:_dataSource[indexPath.row]];
    } forControlEvents:UIControlEventTouchUpInside];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self payWithInfo:_dataSource[indexPath.row]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return SCREEN_HEIGHT*1/11;
}

- (void)onVIPUpgradeSuccessNotification {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
