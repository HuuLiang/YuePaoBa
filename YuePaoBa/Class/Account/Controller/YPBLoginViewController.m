//
//  YPBLoginViewController.m
//  YuePaoBa
//
//  Created by Sean Yue on 16/1/28.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "YPBLoginViewController.h"
#import "YPBRegisterFirstViewController.h"
#import "YPBImageIndicatorView.h"

@interface YPBLoginViewController () <UIScrollViewDelegate>
{
    UIScrollView *_imageScrollView;
    YPBImageIndicatorView *_indicatorView;
}
@property (nonatomic,retain,readonly) NSArray<NSString *> *imageNames;
@property (nonatomic,retain) NSMutableArray<UIImageView *> *imageViews;
@end

@implementation YPBLoginViewController
@synthesize imageNames = _imageNames;

DefineLazyPropertyInitialization(NSMutableArray, imageViews)

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _imageScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _imageScrollView.pagingEnabled = YES;
    _imageScrollView.showsHorizontalScrollIndicator = NO;
    _imageScrollView.delegate = self;
    [self.view addSubview:_imageScrollView];
    
    CGRect imageFrame = _imageScrollView.bounds;
    [self.imageNames enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *imagePath = [[NSBundle mainBundle] pathForResource:obj ofType:@"jpg"];
        UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.frame = CGRectOffset(imageFrame, CGRectGetWidth(imageFrame)*idx, 0);
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [_imageScrollView addSubview:imageView];
        [self.imageViews addObject:imageView];
        
        if (idx == self.imageNames.count - 1) {
            UIButton *enterButton = [[UIButton alloc] init];
            [enterButton setTitle:@"点击进入" forState:UIControlStateNormal];
            [enterButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#3eb8b4"]] forState:UIControlStateNormal];
            enterButton.layer.cornerRadius = 22;
            enterButton.layer.masksToBounds = YES;
            [imageView addSubview:enterButton];
            {
                [enterButton mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(imageView);
                    make.width.mas_equalTo(150);
                    make.height.mas_equalTo(enterButton.layer.cornerRadius*2);
                    make.centerY.equalTo(imageView).multipliedBy(1.5);
                }];
            }
            
            imageView.userInteractionEnabled = YES;
            @weakify(self);
            [enterButton bk_addEventHandler:^(id sender) {
                @strongify(self);
                YPBRegisterFirstViewController *registerFirstVC = [[YPBRegisterFirstViewController alloc] init];
                UINavigationController *registerFirstNav = [[UINavigationController alloc] initWithRootViewController:registerFirstVC];
                [self presentViewController:registerFirstNav animated:YES completion:nil];
            } forControlEvents:UIControlEventTouchUpInside];
        }
    }];
    _imageScrollView.contentSize = CGSizeMake(imageFrame.size.width*self.imageViews.count, imageFrame.size.height);
    
    _indicatorView = [[YPBImageIndicatorView alloc] initWithNumberOfIndicators:self.imageNames.count];
    [self.view addSubview:_indicatorView];
    {
        [_indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.view).multipliedBy(1.8);
            make.centerX.equalTo(self.view);
        }];
    }
}

- (NSArray<NSString *> *)imageNames {
    if (_imageNames) {
        return _imageNames;
    }
    
    _imageNames = @[@"login1", @"login2", @"login3"];
    return _imageNames;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSUInteger page = scrollView.contentOffset.x / CGRectGetWidth(scrollView.bounds);
    _indicatorView.selectedIndicator = page;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
