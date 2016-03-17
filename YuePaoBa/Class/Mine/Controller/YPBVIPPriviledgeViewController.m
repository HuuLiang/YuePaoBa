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


@interface YPBVIPPriviledgeViewController () <UITableViewDelegate>
{
    UIImageView *_backgroundImageView;
    YPBPayCell *_oneMonthCell;
    YPBPayCell *_threeMonthCell;
    UIButton *_feedbackButton;
    YPBPayIntroduceView *_introduceView;
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
    self.title = @"会员支付";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    _backgroundImageView = [[UIImageView alloc] init];
    _backgroundImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [_backgroundImageView sd_setImageWithURL:[NSURL URLWithString:[YPBSystemConfig sharedConfig].payImgUrl]
                            placeholderImage:[UIImage imageNamed:@"vip_page"]];
    _backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:_backgroundImageView];
    
    //购买选项
    _threeMonthCell = [[YPBPayCell alloc] init];
    _threeMonthCell.backgroundImage.image = [UIImage imageNamed:@"pay_153-1"];
    _threeMonthCell.priceLabel.text = @"6个月送6个月";
    [_threeMonthCell setDetailText:@"限时特惠:优惠50%"];
    [_threeMonthCell.payButton setTitle:@"96元" forState:UIControlStateNormal];
    [self.view addSubview:_threeMonthCell];
    
    _oneMonthCell = [[YPBPayCell alloc] init];
    _oneMonthCell.backgroundImage.image = [UIImage imageNamed:@"pay_153-2"];
    _oneMonthCell.priceLabel.text = @"1个月";
    [_oneMonthCell setDetailText:@""];
    [_oneMonthCell.payButton setTitle:@"38元" forState:UIControlStateNormal];
    [self.view addSubview:_oneMonthCell];
    
    //会员特权说明
    _introduceView = [[YPBPayIntroduceView alloc] init];
    [self.view addSubview:_introduceView];
    
    
    YPBSystemConfig *systemConfig = [YPBSystemConfig sharedConfig];
    NSUInteger price1Month = ((NSString *)systemConfig.vipPointDictionary[@"1"]).integerValue;
    NSUInteger price3Month = ((NSString *)systemConfig.vipPointDictionary[@"3"]).integerValue;
    
    @weakify(self);
    [_oneMonthCell.payButton bk_addEventHandler:^(id sender) {
        @strongify(self);
        [self popPaymentViewWithPrice:price1Month forMonths:1];
    } forControlEvents:UIControlEventTouchUpInside];
    [_threeMonthCell.payButton bk_addEventHandler:^(id sender) {
        @strongify(self);
        [self popPaymentViewWithPrice:price3Month forMonths:3];
    } forControlEvents:UIControlEventTouchUpInside];
    [_oneMonthCell bk_whenTouches:1 tapped:1 handler:^{
        @strongify(self)
         [self popPaymentViewWithPrice:price1Month forMonths:1];
    }];
    [_threeMonthCell bk_whenTouches:1 tapped:1 handler:^{
        @strongify(self)
        [self popPaymentViewWithPrice:price3Month forMonths:3];
    }];
    
    
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
    NSDictionary * layoutDic = @{@"_back":_backgroundImageView,
                                 @"_three":_threeMonthCell,
                                 @"_one":_oneMonthCell,
                                 @"_intro":_introduceView};
    NSDictionary * metrices = @{@"_backHeight":@(self.view.frame.size.width/4)};
    NSArray *contraints1 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_back]-0-|" options:0 metrics:nil views:layoutDic];
    NSArray *contraints2 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_three]-0-|" options:0 metrics:nil views:layoutDic];
    NSArray *contraints3 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_one]-0-|" options:0 metrics:nil views:layoutDic];
    NSArray *contraints4 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_intro]-0-|" options:0 metrics:nil views:layoutDic];
    NSArray *contraints5 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_back(_backHeight)]-0-[_three(80)]-0-[_one(80)]-0-[_intro]-5-|" options:0 metrics:metrices views:layoutDic];
    NSMutableArray * array = [[NSMutableArray alloc] init];
    [array addObjectsFromArray:contraints1];
    [array addObjectsFromArray:contraints2];
    [array addObjectsFromArray:contraints3];
    [array addObjectsFromArray:contraints4];
    [array addObjectsFromArray:contraints5];
    [self.view addConstraints:array];
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
