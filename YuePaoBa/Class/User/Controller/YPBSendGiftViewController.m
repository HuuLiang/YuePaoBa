//
//  YPBSendGiftViewController.m
//  YuePaoBa
//
//  Created by Sean Yue on 16/2/20.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "YPBSendGiftViewController.h"
#import "YPBGiftButton.h"
#import "YPBGiftListModel.h"
#import "YPBSendGiftModel.h"
#import "YPBPaymentPopView.h"

static NSString *const kGiftCollectionViewCellReusableIdentifier = @"GiftCollectionViewCellReusableIdentifier";
static const void *kGiftButtonAssociatedKey = &kGiftButtonAssociatedKey;
static const NSUInteger kColumnNumber = 4;

@interface YPBSendGiftViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
{
    UIImageView *_avatarImageView;
    UILabel *_giftLabel;
    UICollectionView *_giftCollectionView;
}
@property (nonatomic,retain) YPBGiftListModel *giftListModel;
@property (nonatomic,retain) YPBSendGiftModel *sendGiftModel;
@property (nonatomic,retain) YPBPaymentPopView *paymentPopView;
@property (nonatomic,retain) YPBGift *sendingGift;
@property (nonatomic,retain) UIView *successView;
@end

@implementation YPBSendGiftViewController

DefineLazyPropertyInitialization(YPBGiftListModel, giftListModel)
DefineLazyPropertyInitialization(YPBSendGiftModel, sendGiftModel)

- (instancetype)initWithUser:(YPBUser *)user {
    self = [self init];
    if (self) {
        _user = user;
    }
    return self;
}

- (YPBPaymentPopView *)paymentPopView {
    if (_paymentPopView) {
        return _paymentPopView;
    }
    
    _paymentPopView = [[YPBPaymentPopView alloc] init];
    @weakify(self);
    [_paymentPopView addPaymentWithImage:[UIImage imageNamed:@"vip_alipay_icon"] title:@"支付宝支付" available:YES action:^(id obj) {
        @strongify(self);
        YPBPaymentInfo *paymentInfo = [YPBPaymentInfo paymentInfo];
        paymentInfo.orderPrice = self.sendingGift.fee;
        paymentInfo.payPointType = @(YPBPayPointTypeGift);
        paymentInfo.contentType = @(YPBPaymentContentTypeGift).stringValue;
        paymentInfo.paymentType = @(YPBPaymentTypeAlipay);
        
        [[YPBPaymentManager sharedManager] payWithPaymentInfo:paymentInfo
                                            completionHandler:^(BOOL success, id obj)
        {
            @strongify(self);
            [self onPaymentCompletionWithPaymentInfo:obj];
        }];
    }];
    [_paymentPopView addPaymentWithImage:[UIImage imageNamed:@"vip_wechat_icon"] title:@"微信客户端支付" available:YES action:^(id obj) {
        @strongify(self);
        YPBPaymentInfo *paymentInfo = [YPBPaymentInfo paymentInfo];
        paymentInfo.orderPrice = self.sendingGift.fee;
        paymentInfo.payPointType = @(YPBPayPointTypeGift);
        paymentInfo.contentType = @(YPBPaymentContentTypeGift).stringValue;
        paymentInfo.paymentType = @(YPBPaymentTypeWeChatPay);
        
        [[YPBPaymentManager sharedManager] payWithPaymentInfo:paymentInfo
                                            completionHandler:^(BOOL success, id obj)
         {
             @strongify(self);
             [self onPaymentCompletionWithPaymentInfo:obj];
         }];
    }];
    return _paymentPopView;
}

- (UIView *)successView {
    if (_successView) {
        return _successView;
    }
    
    _successView = [[UIView alloc] initWithFrame:self.view.bounds];
    _successView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
    @weakify(self);
    [_successView bk_whenTapped:^{
        @strongify(self);
        [UIView animateWithDuration:0.25 animations:^{
            self.successView.alpha = 0;
        } completion:^(BOOL finished) {
            [self.successView removeFromSuperview];
        }];
    }];
    
    UIImage *successImage;
    if ([YPBUser currentUser].gender == YPBUserGenderFemale) {
        successImage = [UIImage imageNamed:@"gift_sent_by_female_icon"];
    } else {
        successImage = [UIImage imageNamed:@"gift_sent_by_male_icon"];
    }
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:successImage];
    [_successView addSubview:imageView];
    {
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(_successView);
        }];
    }
    return _successView;
}

- (void)showSuccessView {
    self.successView.alpha = 0;
    [self.view addSubview:self.successView];
    [UIView animateWithDuration:0.25 animations:^{
        self.successView.alpha = 1;
    }];
}

- (void)onPaymentCompletionWithPaymentInfo:(YPBPaymentInfo *)paymentInfo {
    PAYRESULT payresult = paymentInfo.paymentResult.unsignedIntegerValue;
    if (payresult == PAYRESULT_SUCCESS) {
        [self.paymentPopView hide];
        [self showSuccessView];
        
        [self.sendGiftModel sendGift:self.sendingGift.id
                              toUser:self.user.userId
                        withNickName:self.user.nickName
                   completionHandler:nil];
    
        NSMutableArray *gifts = self.user.gifts.mutableCopy;
        if (!gifts) {
            gifts = [NSMutableArray array];
        }
        
        self.sendingGift.userName = [YPBUser currentUser].nickName;
        [gifts insertObject:self.sendingGift atIndex:0];
        self.user.gifts = gifts;
    } else if (payresult == PAYRESULT_ABANDON) {
        [[YPBMessageCenter defaultCenter] showErrorWithTitle:@"支付取消" inViewController:nil];
    } else {
        [[YPBMessageCenter defaultCenter] showErrorWithTitle:@"支付失败" inViewController:nil];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"赠送礼物";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    const CGFloat avatarSize = 66;
    _avatarImageView = [[UIImageView alloc] init];
    _avatarImageView.layer.cornerRadius = avatarSize/2;
    _avatarImageView.layer.masksToBounds = YES;
    [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:self.user.logoUrl] placeholderImage:[UIImage imageNamed:@"avatar_placeholder"]];
    [self.view addSubview:_avatarImageView];
    {
        [_avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(30);
            make.left.equalTo(self.view).offset(15);
            make.size.mas_equalTo(CGSizeMake(avatarSize, avatarSize));
        }];
    }
    
    NSString *giftWord = [YPBGiftWords objectAtIndex:arc4random_uniform((u_int32_t)YPBGiftWords.count-1)];
    _giftLabel = [[UILabel alloc] init];
    _giftLabel.numberOfLines = 2;
    _giftLabel.text = [NSString stringWithFormat:@"\"%@\"", giftWord];
    _giftLabel.textColor = [UIColor redColor];
    _giftLabel.font = [UIFont systemFontOfSize:18.];
    [self.view addSubview:_giftLabel];
    {
        [_giftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_avatarImageView.mas_right).offset(15);
            make.centerY.equalTo(_avatarImageView);
            make.right.equalTo(self.view).offset(-15);
        }];
    }
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = layout.minimumLineSpacing;
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    
    _giftCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _giftCollectionView.layer.borderWidth = 0.5;
    _giftCollectionView.layer.borderColor = [UIColor grayColor].CGColor;
    _giftCollectionView.backgroundColor = self.view.backgroundColor;
    _giftCollectionView.layer.cornerRadius = 5;
    _giftCollectionView.layer.masksToBounds = YES;
    _giftCollectionView.delegate = self;
    _giftCollectionView.dataSource = self;
    [_giftCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kGiftCollectionViewCellReusableIdentifier];
    [self.view addSubview:_giftCollectionView];
    {
        [_giftCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_avatarImageView);
            make.top.equalTo(_avatarImageView.mas_bottom).offset(30);
            make.right.equalTo(_giftLabel);
            //make.bottom.equalTo(self.view);
        }];
    }
    [self loadGifts];
}

- (void)loadGifts {
    @weakify(self);
    [self.giftListModel fetchGiftListWithCompletionHandler:^(BOOL success, id obj) {
        @strongify(self);
        if (!self) {
            return ;
        }
        
        if (success) {
            [self updateHeightOfCollectionViewForGifts:obj];
            [self->_giftCollectionView reloadData];
        }
    }];
}

- (void)updateHeightOfCollectionViewForGifts:(NSArray<YPBGift *> *)gifts {
    const NSUInteger items = gifts.count;
    const NSUInteger rowNumber = (items + kColumnNumber - 1) / kColumnNumber;
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)_giftCollectionView.collectionViewLayout;
    CGSize itemSize = [self itemSizeOfLayout:layout];
    
    CGFloat collectionViewHeight = itemSize.height * rowNumber + layout.minimumLineSpacing * (rowNumber-1) + layout.sectionInset.top + layout.sectionInset.bottom;
    const CGFloat maxCollectionViewHeight = CGRectGetHeight(self.view.bounds) - CGRectGetMinX(_giftCollectionView.frame) - 15;
    if (collectionViewHeight > maxCollectionViewHeight) {
        collectionViewHeight = maxCollectionViewHeight;
    }
    
    [_giftCollectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(collectionViewHeight);
    }];
}

- (CGSize)itemSizeOfLayout:(UICollectionViewFlowLayout *)layout {
    const CGFloat itemWidth = (_giftCollectionView.bounds.size.width - (kColumnNumber - 1) * layout.minimumLineSpacing - layout.sectionInset.left - layout.sectionInset.right) / kColumnNumber;
    const CGFloat itemHeight = itemWidth + 20;
    return CGSizeMake(itemWidth, itemHeight);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDataSource, UICollectionViewDelegateFlowLayout

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kGiftCollectionViewCellReusableIdentifier forIndexPath:indexPath];
    YPBGiftButton *giftButton = objc_getAssociatedObject(cell, kGiftButtonAssociatedKey);
    if (!giftButton) {
        giftButton = [[YPBGiftButton alloc] init];
        objc_setAssociatedObject(cell, kGiftButtonAssociatedKey, giftButton, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        cell.backgroundView = giftButton;
    }
    
    if (indexPath.item < self.giftListModel.fetchedGifts.count) {
        YPBGift *gift = [self.giftListModel.fetchedGifts objectAtIndex:indexPath.item];
        [giftButton setTitle:[NSString stringWithFormat:@"%@%@元", gift.name, [YPBUtil priceStringWithValue:gift.fee.unsignedIntegerValue]] forState:UIControlStateNormal];
        [giftButton sd_setImageWithURL:[NSURL URLWithString:gift.imgUrl] forState:UIControlStateNormal];
    }
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.giftListModel.fetchedGifts.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self itemSizeOfLayout:(UICollectionViewFlowLayout *)collectionViewLayout];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    YPBGift *gift = [self.giftListModel.fetchedGifts objectAtIndex:indexPath.item];
    
    self.sendingGift = gift;
    [self.paymentPopView showInView:self.view];
    
}
@end
