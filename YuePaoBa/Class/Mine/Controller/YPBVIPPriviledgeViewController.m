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
#import "YPBApplePay.h"

@interface YPBVIPPriviledgeViewController () <UITableViewDelegate,UITableViewDataSource>
{
    UIImageView *_backgroundImageView;
    UIButton *_feedbackButton;
    YPBPayIntroduceView *_introduceView;
    NSMutableArray *_dataSource;
    UITableView *_payTableView;
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
    
    _dataSource = [[NSMutableArray alloc] init];
    NSString *oneMonth = @"one";
    NSString *threeMonth = @"three";
    [_dataSource addObject:threeMonth];
    [_dataSource addObject:oneMonth];

    
    _backgroundImageView = [[UIImageView alloc] init];
    _backgroundImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [_backgroundImageView sd_setImageWithURL:[NSURL URLWithString:[YPBSystemConfig sharedConfig].payImgUrl]
                            placeholderImage:[UIImage imageNamed:@"vip_page"]];
    _backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:_backgroundImageView];
    
    //购买选项
    _payTableView = [[UITableView alloc] init];
    _payTableView.scrollEnabled = NO;
    _payTableView.delegate = self;
    _payTableView.dataSource = self;
    [_payTableView registerClass:[YPBPayCell class] forCellReuseIdentifier:@"cellID"];
    [self.view addSubview:_payTableView];
    
    //会员特权说明
    _introduceView = [[YPBPayIntroduceView alloc] init];
    [self.view addSubview:_introduceView];
    
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
        [_backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self.view);
            make.height.equalTo(@(SCREEN_WIDTH/4));
        }];
        
        [_payTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.top.equalTo(_backgroundImageView.mas_bottom);
            make.height.equalTo(@(SCREEN_HEIGHT*3/11));
        }];
        
        [_introduceView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.top.equalTo(_payTableView.mas_bottom);
        }];
        
        [_feedbackButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.bottom.equalTo(self.view).offset(-5);
        }];
    }
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
//    YPBSystemConfig *systemConfig = [YPBSystemConfig sharedConfig];
//    NSUInteger price1Month = ((NSString *)systemConfig.vipPointDictionary[@"1"]).integerValue;
//    NSUInteger price3Month = ((NSString *)systemConfig.vipPointDictionary[@"3"]).integerValue;
    //@weakify(self);
    if ([info isEqualToString:@"one"]) {
        //@strongify(self);
        //[self popPaymentViewWithPrice:price1Month forMonths:1];
        //购买1个月
        DLog(@"-------one");
        [YPBApplePay applePay];
        [YPBApplePay getProductionInfos];
        //[[YPBApplePay applePay] payWithProductionId:@"YPB_VIP_30"];
    } else if ([info isEqualToString:@"three"]) {
        //@strongify(self);
        //[self popPaymentViewWithPrice:price3Month forMonths:3];
        //购买3个月
        DLog(@"-------three");
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
    return SCREEN_HEIGHT*3/22;
}

- (void)onVIPUpgradeSuccessNotification {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
