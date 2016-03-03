//
//  YPBMyGiftDetailViewController.m
//  YuePaoBa
//
//  Created by Sean Yue on 16/2/24.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "YPBMyGiftDetailViewController.h"
#import "YPBGiftButton.h"

static NSString *const kMyGiftDetailCellReusableIdentifier = @"MyGiftDetailCellReusableIdentifier";
static NSString *const kMyGiftDetailHeaderReusableIdentifier = @"MyGiftDetailHeaderReusableIdentifier";
static const void* kGiftButtonAssociatedKey = &kGiftButtonAssociatedKey;
static const void* kGiftSummaryLabelAssociatedKey = &kGiftSummaryLabelAssociatedKey;

@interface YPBMyGiftDetailViewController () <UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    UICollectionView *_giftsCollectionView;
}
@property (nonatomic,retain) NSArray<YPBGift *> *gifts;
@end

@implementation YPBMyGiftDetailViewController

- (instancetype)initWithDataSource:(id<YPBUserGiftsDataSource>)dataSource {
    self = [self init];
    if (self) {
        _dataSource = dataSource;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 5;
    layout.minimumInteritemSpacing = layout.minimumLineSpacing;
    layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    layout.headerReferenceSize = CGSizeMake(kScreenWidth, 30);
    
    _giftsCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _giftsCollectionView.backgroundColor = self.view.backgroundColor;
    _giftsCollectionView.delegate = self;
    _giftsCollectionView.dataSource = self;
    _giftsCollectionView.showsVerticalScrollIndicator = NO;
    [_giftsCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kMyGiftDetailCellReusableIdentifier];
    [_giftsCollectionView registerClass:[UICollectionReusableView class]
             forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                    withReuseIdentifier:kMyGiftDetailHeaderReusableIdentifier];
    [self.view addSubview:_giftsCollectionView];
    {
        [_giftsCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(5, 5, 5, 5));
        }];
    }
    
    @weakify(self);
    [_giftsCollectionView YPB_addPullToRefreshWithHandler:^{
        @strongify(self);
        [self loadGifts];
    }];
    [_giftsCollectionView YPB_triggerPullToRefresh];
}

- (void)loadGifts {
    @weakify(self);
    [self.dataSource fetchGiftsByUser:[YPBUser currentUser].userId withCompletionHandler:^(BOOL success, id obj) {
        @strongify(self);
        if (!self) {
            return ;
        }
        
        if (success) {
            self.gifts = obj;
            [self->_giftsCollectionView reloadData];
        }
        
        [self->_giftsCollectionView YPB_endPullToRefresh];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDataSource,UIBarPositioningDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.gifts.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kMyGiftDetailCellReusableIdentifier forIndexPath:indexPath];
    YPBGiftButton *giftButton = objc_getAssociatedObject(cell, kGiftButtonAssociatedKey);
    if (!giftButton) {
        giftButton = [[YPBGiftButton alloc] init];
        cell.backgroundView = giftButton;
        objc_setAssociatedObject(cell, kGiftButtonAssociatedKey, giftButton, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    if (indexPath.item < self.gifts.count) {
        YPBGift *gift = self.gifts[indexPath.item];
        [giftButton sd_setImageWithURL:[NSURL URLWithString:gift.imgUrl] forState:UIControlStateNormal];
        [giftButton setTitle:gift.userName forState:UIControlStateNormal];
    }
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                              withReuseIdentifier:kMyGiftDetailHeaderReusableIdentifier
                                                                                     forIndexPath:indexPath];
    UILabel *summaryLabel = objc_getAssociatedObject(headerView, kGiftSummaryLabelAssociatedKey);
    if (!summaryLabel) {
        summaryLabel = [[UILabel alloc] init];
        summaryLabel.font = [UIFont systemFontOfSize:14.];
        [headerView addSubview:summaryLabel];
        {
            [summaryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(headerView);
            }];
        }
        objc_setAssociatedObject(headerView, kGiftSummaryLabelAssociatedKey, summaryLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    NSString *summaryPrefix = self.summaryPrefix ?: @"共计";
    NSMutableAttributedString *summary = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@：%ld 件", summaryPrefix, (unsigned long)self.gifts.count]];
    [summary addAttribute:NSForegroundColorAttributeName value:kThemeColor range:NSMakeRange(summaryPrefix.length, summary.length-summaryPrefix.length)];
    summaryLabel.attributedText = summary;
    
    return headerView;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)collectionViewLayout;
    const NSUInteger columnNumber = 4;
    const CGFloat itemWidth = (_giftsCollectionView.bounds.size.width - (columnNumber - 1) * layout.minimumLineSpacing - layout.sectionInset.left - layout.sectionInset.right) / columnNumber;
    const CGFloat itemHeight = itemWidth + 20;
    return CGSizeMake(itemWidth, itemHeight);
}

@end
