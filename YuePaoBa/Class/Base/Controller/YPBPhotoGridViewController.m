//
//  YPBPhotoGridViewController.m
//  YuePaoBa
//
//  Created by Sean Yue on 15/12/28.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import "YPBPhotoGridViewController.h"
#import "YPBUser.h"
#import "YPBPhotoBrowser.h"

static NSString *const kPhotoGridCellReusableIdentifier = @"PhotoGridCellReusableIdentifier";
static const CGFloat kInterSpacing = 2;
static const NSUInteger kNumberOfPhotosInRow = 3;

@interface YPBPhotoGridViewController () <UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    UICollectionView *_layoutCollectionView;
}
@property (nonatomic,retain) YPBPhotoBrowser *photoBrowser;
@end

@implementation YPBPhotoGridViewController

- (instancetype)initWithPhotos:(NSArray *)photosArray {
    self = [super init];
    if (self) {
        _photos = photosArray;
        _photoBrowser = [[YPBPhotoBrowser alloc] initWithUserPhotos:photosArray];
    }
    return self;
}

- (NSString *)title {
    return self.photos.count > 0 ? [NSString stringWithFormat:@"个人相册(%ld张)", self.photos.count]: @"个人相册";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = kInterSpacing;
    layout.minimumLineSpacing = kInterSpacing;
    
    _layoutCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _layoutCollectionView.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
    _layoutCollectionView.delegate = self;
    _layoutCollectionView.dataSource = self;
    [_layoutCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kPhotoGridCellReusableIdentifier];
    [self.view addSubview:_layoutCollectionView];
    {
        [_layoutCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    
    @weakify(self);
    [_layoutCollectionView YPB_addPullToRefreshWithHandler:^{
        @strongify(self);
        if (self) {
            [self->_layoutCollectionView reloadData];
            [self->_layoutCollectionView YPB_endPullToRefresh];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDataSource,UICollectionViewDelegateFlowLayout

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kPhotoGridCellReusableIdentifier
                                                                           forIndexPath:indexPath];
    if (!cell.backgroundView) {
        cell.backgroundView = [[UIImageView alloc] init];
    }
    
    if (indexPath.row < self.photos.count) {
        YPBUserPhoto *photo = self.photos[indexPath.row];
        UIImageView *thumbImageView = (UIImageView *)cell.backgroundView;
        [thumbImageView sd_setImageWithURL:[NSURL URLWithString:photo.smallPhoto]];
    }
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.photos.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    const CGFloat width = (CGRectGetWidth(collectionView.bounds) - kInterSpacing * (kNumberOfPhotosInRow-1)) / kNumberOfPhotosInRow;
    return CGSizeMake(width, width);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.photoBrowser setCurrentPhotoIndex:indexPath.row];
    [self.photoBrowser showInView:self.view.window];
}

@end
