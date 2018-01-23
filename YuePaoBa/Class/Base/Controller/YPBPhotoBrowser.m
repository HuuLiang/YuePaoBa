//
//  YPBPhotoBrowser.m
//  YuePaoBa
//
//  Created by Sean Yue on 15/12/28.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import "YPBPhotoBrowser.h"
#import "MWPhotoBrowser.h"

static const CGFloat kViewFadeAnimationDuration = 0.3;

static YPBPhotoBrowser *_sharedPhotoBrowser;

@interface YPBPhotoBrowser () <MWPhotoBrowserDelegate>
@property (nonatomic,retain) MWPhotoBrowser *photoBrowser;
@end

@implementation YPBPhotoBrowser

+ (instancetype)showPhotoBrowserInView:(UIView *)view withPhotos:(NSArray *)photos currentPhotoIndex:(NSUInteger)index {
    _sharedPhotoBrowser = [[self alloc] initWithUserPhotos:photos];
    [_sharedPhotoBrowser setCurrentPhotoIndex:index];
    [_sharedPhotoBrowser showInView:view];
    return _sharedPhotoBrowser;
}

+ (instancetype)showingPhotoBrowser {
    return _sharedPhotoBrowser;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _hideOnTap = YES;
    }
    return self;
}

- (instancetype)initWithUserPhotos:(NSArray *)userPhotos {
    self = [self init];
    if (self) {
        _photos = userPhotos;
        
        NSMutableArray *photos = [NSMutableArray array];
        [userPhotos enumerateObjectsUsingBlock:^(YPBUserPhoto * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            MWPhoto *photo = [MWPhoto photoWithURL:[NSURL URLWithString:obj.bigPhoto]];
            if (self.shouldLockAction && self.shouldLockAction(idx)) {
                photo.isLocked = YES;
                
                @weakify(self);
                photo.tapLockAction = ^(id sender) {
                    @strongify(self);
                    SafelyCallBlock1(self.tapLockAction, sender);
                };
            }
            [photos addObject:photo];
            
        }];
        _photoBrowser = [[MWPhotoBrowser alloc] initWithPhotos:photos];
        _photoBrowser.delegate = self;
//        _photoBrowser.displayActionButton = NO;
    }
    return self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addChildViewController:self.photoBrowser];
    self.photoBrowser.view.frame = self.view.bounds;
    [self.view addSubview:self.photoBrowser.view];
    {
        [self.photoBrowser.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    [self.photoBrowser didMoveToParentViewController:self];
    
    @weakify(self);
    [self.photoBrowser.view bk_whenTapped:^{
        @strongify(self);
        if (self.hideOnTap) {
            [self hide];
        }
        SafelyCallBlock1(self.tapPhotoAction, self);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.photoBrowser reloadData];
}

- (NSUInteger)currentPhotoIndex {
    return self.photoBrowser.currentIndex;
}

- (void)setCurrentPhotoIndex:(NSUInteger)currentPhotoIndex {
    [self.photoBrowser setCurrentPhotoIndex:currentPhotoIndex];
}

- (void)showInView:(UIView *)view {
    if ([view.subviews containsObject:self.view]) {
        return ;
    }
    
    self.view.frame = view.bounds;
    self.view.alpha = 0;
    [view addSubview:self.view];
    
    [UIView animateWithDuration:kViewFadeAnimationDuration animations:^{
        self.view.alpha = 1;
    }];
}

- (void)hide {
    if (self.view.superview) {
        [UIView animateWithDuration:kViewFadeAnimationDuration animations:^{
            self.view.alpha = 0;
        } completion:^(BOOL finished) {
            [self.view removeFromSuperview];
            
            if (self == _sharedPhotoBrowser) {
                _sharedPhotoBrowser = nil;
            }
        }];
    }
}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser didDisplayPhotoAtIndex:(NSUInteger)index {
    SafelyCallBlock1(self.displayAction, index);
}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser willDisplayPhoto:(id<MWPhoto>)photo atIndex:(NSUInteger)index inUnderlyingScrollView:(UIScrollView *)scrollView {
//    if (self.shouldLockAction && self.shouldLockAction(index)) {
//        photo.underlyingImage = [photo.underlyingImage blurredImageWithRadius:kDefaultPhotoBlurRadius];
//    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
