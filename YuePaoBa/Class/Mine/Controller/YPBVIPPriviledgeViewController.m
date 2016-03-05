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

@interface YPBVIPPriviledgeViewController ()
{
    UIImageView *_backgroundImageView;
    YPBVIPPriceButton *_1MonthPriceButton;
    YPBVIPPriceButton *_3MonthsPriceButton;
    UIButton *_feedbackButton;
}
@property (nonatomic,retain) YPBUserVIPUpgradeModel *vipUpgradeModel;
@property (nonatomic,retain) YPBPaymentInfo *paymentInfo;
@property (nonatomic,retain) YPBPaymentPopView *paymentPopView;
@end

@implementation YPBVIPPriviledgeViewController

DefineLazyPropertyInitialization(YPBUserVIPUpgradeModel, vipUpgradeModel)

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
    self.title = @"VIP特权";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    _backgroundImageView = [[UIImageView alloc] init];
    [_backgroundImageView sd_setImageWithURL:[NSURL URLWithString:[YPBSystemConfig sharedConfig].payImgUrl]
                            placeholderImage:[UIImage imageNamed:@"vip_page"]];
    _backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:_backgroundImageView];
    
    YPBSystemConfig *systemConfig = [YPBSystemConfig sharedConfig];
    NSUInteger price1Month = ((NSString *)systemConfig.vipPointDictionary[@"1"]).integerValue;
    NSUInteger price3Month = ((NSString *)systemConfig.vipPointDictionary[@"3"]).integerValue;
    
    _1MonthPriceButton = [[YPBVIPPriceButton alloc] init];
    _1MonthPriceButton.backgroundImage = [UIImage imageNamed:@"vip_payment_1month"];
    _1MonthPriceButton.title = [NSString stringWithFormat:@"首月体验：%@元/1个月", [YPBUtil priceStringWithValue:price1Month]];
    [self.view addSubview:_1MonthPriceButton];
    
    _3MonthsPriceButton = [[YPBVIPPriceButton alloc] init];
    _3MonthsPriceButton.backgroundImage = [UIImage imageNamed:@"vip_payment_3month"];
    _3MonthsPriceButton.title = [NSString stringWithFormat:@"限时特价：%@元/3个月", [YPBUtil priceStringWithValue:price3Month]];
    [self.view addSubview:_3MonthsPriceButton];
    
    @weakify(self);
    [_1MonthPriceButton bk_addEventHandler:^(id sender) {
        @strongify(self);
        [self popPaymentViewWithPrice:price1Month forMonths:1];
    } forControlEvents:UIControlEventTouchUpInside];
    
    [_3MonthsPriceButton bk_addEventHandler:^(id sender) {
        @strongify(self);
        [self popPaymentViewWithPrice:price3Month forMonths:3];
    } forControlEvents:UIControlEventTouchUpInside];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onVIPUpgradeSuccessNotification) name:kVIPUpgradeSuccessNotification object:nil];
    
    _feedbackButton = [[UIButton alloc] init];
    NSDictionary *attributes = @{NSForegroundColorAttributeName:[UIColor redColor],
                                 //NSFontAttributeName:[UIFont systemFontOfSize:16.],
                                 NSUnderlineStyleAttributeName:@1};
    NSAttributedString *feedbackTitle = [[NSAttributedString alloc] initWithString:@"如您遇到支付问题，请按此处反馈问题" attributes:attributes];
    [_feedbackButton setAttributedTitle:feedbackTitle forState:UIControlStateNormal];
    _feedbackButton.titleLabel.font = [UIFont systemFontOfSize:12.];
    [self.view addSubview:_feedbackButton];
    {
        [_feedbackButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.bottom.equalTo(self.view).offset(-5);
        }];
    }
    
    [_feedbackButton bk_addEventHandler:^(id sender) {
        @strongify(self);
        YPBPaymentIssueReportViewController *reportVC = [[YPBPaymentIssueReportViewController alloc] init];
        [self.navigationController pushViewController:reportVC animated:YES];
    } forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    _backgroundImageView.frame = self.view.bounds;
    
    const CGFloat width1 = self.view.bounds.size.width*0.5;
    const CGFloat height1 = width1 * _1MonthPriceButton.backgroundImage.size.height/_1MonthPriceButton.backgroundImage.size.width;
    _1MonthPriceButton.center = CGPointMake(self.view.bounds.size.width*0.6, self.view.bounds.size.height*0.55);
    _1MonthPriceButton.bounds = CGRectMake(0, 0, width1, height1);
    _1MonthPriceButton.contentEdgeInsets = UIEdgeInsetsMake(height1*0.3, 0, 0, 0);
    _1MonthPriceButton.titleLabel.font = [UIFont boldSystemFontOfSize:height1*0.2];
    
    const CGFloat width2 = self.view.bounds.size.width*0.7;
    const CGFloat height2 = width2 * _3MonthsPriceButton.backgroundImage.size.height/_3MonthsPriceButton.backgroundImage.size.width;
    _3MonthsPriceButton.center = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height*0.82);
    _3MonthsPriceButton.bounds = CGRectMake(0, 0, width2, height2);
    _3MonthsPriceButton.contentEdgeInsets = UIEdgeInsetsMake(height2*0.1, 0, 0, 0);
    _3MonthsPriceButton.titleLabel.font = [UIFont boldSystemFontOfSize:height2*0.15];
    
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
    [self.view.window beginLoading];
    [[YPBPaymentManager sharedManager] payWithPaymentInfo:paymentInfo completionHandler:^(BOOL success, id obj) {
        @strongify(self);
        [self.view.window endLoading];
        
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

- (void)onVIPUpgradeSuccessNotification {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
