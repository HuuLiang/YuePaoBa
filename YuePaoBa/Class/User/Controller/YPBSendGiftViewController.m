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

static NSString *const kGiftCollectionViewCellReusableIdentifier = @"GiftCollectionViewCellReusableIdentifier";
static const void *kGiftButtonAssociatedKey = &kGiftButtonAssociatedKey;
static const NSUInteger kColumnNumber = 4;

@interface YPBSendGiftViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
{
    UICollectionView *_giftCollectionView;
}
@property (nonatomic,retain) YPBGiftListModel *giftListModel;
@end

@implementation YPBSendGiftViewController

DefineLazyPropertyInitialization(YPBGiftListModel, giftListModel)

- (instancetype)initWithUser:(YPBUser *)user {
    self = [self init];
    if (self) {
        _user = user;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"赠送礼物";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    const CGFloat avatarSize = 66;
    UIImageView *avatarImageView = [[UIImageView alloc] init];
    avatarImageView.layer.cornerRadius = avatarSize/2;
    avatarImageView.layer.masksToBounds = YES;
    [avatarImageView sd_setImageWithURL:[NSURL URLWithString:self.user.logoUrl] placeholderImage:[UIImage imageNamed:@"avatar_placeholder"]];
    [self.view addSubview:avatarImageView];
    {
        [avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(30);
            make.left.equalTo(self.view).offset(15);
            make.size.mas_equalTo(CGSizeMake(avatarSize, avatarSize));
        }];
    }
    
    NSString *giftWord = [YPBGiftWords objectAtIndex:arc4random_uniform((u_int32_t)YPBGiftWords.count-1)];
    UILabel *label = [[UILabel alloc] init];
    label.numberOfLines = 2;
    label.text = [NSString stringWithFormat:@"\"%@\"", giftWord];
    label.textColor = [UIColor redColor];
    label.font = [UIFont systemFontOfSize:18.];
    [self.view addSubview:label];
    {
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(avatarImageView.mas_right).offset(15);
            make.centerY.equalTo(avatarImageView);
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
            make.left.equalTo(avatarImageView);
            make.top.equalTo(avatarImageView.mas_bottom).offset(30);
            make.right.equalTo(label);
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
    
    const CGFloat collectionViewHeight = itemSize.height * rowNumber + layout.minimumLineSpacing * (rowNumber-1) + layout.sectionInset.top + layout.sectionInset.bottom;
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
