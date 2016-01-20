//
//  YPBLoginViewController.m
//  YuePaoBa
//
//  Created by Sean Yue on 15/12/12.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import "YPBLoginViewController.h"
#import "YPBRegisterFirstViewController.h"
#import "YPBActionButton.h"

static NSString *const kLayoutCellReusableIdentifier = @"LayoutCellReusableIdentifier";
static const CGFloat kSpacing = 1;

@interface YPBLoginViewController () <UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    UICollectionView *_layoutCollectionView;
}
@property (nonatomic,retain) NSMutableArray<UIView *> *maskViews;
@property (nonatomic,retain) NSTimer *timer;
@end

@implementation YPBLoginViewController

DefineLazyPropertyInitialization(NSMutableArray, maskViews)

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = kSpacing;
    layout.minimumLineSpacing = kSpacing;
    
    _layoutCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _layoutCollectionView.backgroundColor = [UIColor whiteColor];
    _layoutCollectionView.delegate = self;
    _layoutCollectionView.dataSource = self;
    [_layoutCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kLayoutCellReusableIdentifier];
    [self.view addSubview:_layoutCollectionView];
    {
        [_layoutCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, kScreenHeight*0.1, 0));
        }];
    }
    
    @weakify(self);
    YPBActionButton *loginButton = [[YPBActionButton alloc] initWithTitle:@"进   入" action:^(id sender) {
        @strongify(self);
        
        YPBRegisterFirstViewController *registerFirstVC = [[YPBRegisterFirstViewController alloc] init];
        registerFirstVC.rootVCHasSideMenu = NO;
        
        UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:registerFirstVC];
        [self presentViewController:navVC animated:YES completion:nil];
    }];
    [self.view addSubview:loginButton];
    {
        [loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.height.mas_equalTo(kScreenHeight*0.1);
        }];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    @weakify(self);
    self.timer = [NSTimer bk_scheduledTimerWithTimeInterval:1 block:^(NSTimer *timer) {
        @strongify(self);
        static NSUInteger currentIndex = 0;
        
        const NSUInteger indices[] = {4,5,8,7};
        const NSUInteger showIndex = indices[currentIndex];
        [self.maskViews enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx == showIndex) {
                obj.hidden = YES;
            } else {
                obj.hidden = NO;
            }
        }];
        ++currentIndex;
        if (currentIndex == sizeof(indices) / sizeof(indices[0])) {
            currentIndex = 0;
        }
    } repeats:YES];
    [self.timer fire];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDataSource,UICollectionViewDelegateFlowLayout

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kLayoutCellReusableIdentifier forIndexPath:indexPath];
    
    if (!cell.backgroundView) {
        NSString *imageName = [NSString stringWithFormat:@"login_background%ld", indexPath.row+1];
        UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
        backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
        backgroundImageView.clipsToBounds = YES;
        cell.backgroundView = backgroundImageView;
        
        if (indexPath.row == 4) {
            UIImageView *foreground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_foreground"]];
            [cell addSubview:foreground];
            {
                [foreground mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.center.equalTo(cell);
                    make.size.mas_equalTo(CGSizeMake(77.5, 77.5));
                }];
            }
        }
        
        UIView *maskView = [[UIView alloc] init];
        [self.maskViews addObject:maskView];
        maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        [cell addSubview:maskView];
        {
            [maskView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(cell);
            }];
        }
    }
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 12;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    const CGFloat itemWidth = (collectionView.bounds.size.width - kSpacing * 2) / 3;
    const CGFloat itemHeight = (collectionView.bounds.size.height - kSpacing * 3) / 4;
    return CGSizeMake(itemWidth, itemHeight);
}
@end
