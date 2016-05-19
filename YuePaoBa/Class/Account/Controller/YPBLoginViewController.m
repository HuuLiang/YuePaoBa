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
            UIButton *registerButton = [[UIButton alloc] init];
            [registerButton setTitle:@"注册" forState:UIControlStateNormal];
            registerButton.titleLabel.font = [UIFont systemFontOfSize:20.];
            [registerButton setTitleColor:[UIColor colorWithHexString:@"#95358e"] forState:UIControlStateNormal];
            registerButton.backgroundColor = [UIColor whiteColor];
            registerButton.layer.cornerRadius = 5;
            registerButton.layer.masksToBounds = YES;
            [imageView addSubview:registerButton];
            {
                [registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(imageView);
                    make.width.mas_equalTo(180);
                    make.height.mas_equalTo(registerButton.layer.cornerRadius*10);
                    make.centerY.equalTo(imageView).multipliedBy(1.4);
                }];
            }
            
            UILabel *notiLabel = [[UILabel alloc] init];
            notiLabel.backgroundColor = [UIColor clearColor];
            notiLabel.font = [UIFont systemFontOfSize:13.];
            notiLabel.textAlignment = NSTextAlignmentCenter;
            notiLabel.textColor = [UIColor colorWithHexString:@"#a58c9a"];
            notiLabel.text = @"已经有同城速配的帐户了?";
            [imageView addSubview:notiLabel];
            {
                [notiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(imageView);
                    make.width.mas_equalTo(180);
                    make.height.mas_equalTo(20);
                    make.top.equalTo(registerButton.mas_bottom).offset(15);
                }];
            }
            
            UIButton *loginButton = [[UIButton alloc] init];
            [loginButton setTitle:@"登录" forState:UIControlStateNormal];
            loginButton.titleLabel.font = [UIFont systemFontOfSize:20.];
            [loginButton setTitleColor:[UIColor colorWithHexString:@"#a58c9a"] forState:UIControlStateNormal];
            loginButton.backgroundColor = [UIColor clearColor];
            loginButton.layer.cornerRadius = 5;
            [loginButton.layer setBorderColor:[UIColor lightGrayColor].CGColor];
            [loginButton.layer setBorderWidth:1];
            loginButton.layer.masksToBounds = YES;
            [imageView addSubview:loginButton];
            {
                [loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(imageView);
                    make.width.mas_equalTo(180);
                    make.height.mas_equalTo(loginButton.layer.cornerRadius*10);
                    make.top.equalTo(notiLabel.mas_bottom).offset(7);
                }];
            }
            
            imageView.userInteractionEnabled = YES;
            @weakify(self);
            [registerButton bk_addEventHandler:^(id sender) {
                @strongify(self);
                YPBRegisterFirstViewController *registerFirstVC = [[YPBRegisterFirstViewController alloc] init];
                UINavigationController *registerFirstNav = [[UINavigationController alloc] initWithRootViewController:registerFirstVC];
                [self presentViewController:registerFirstNav animated:YES completion:nil];
            } forControlEvents:UIControlEventTouchUpInside];
            
            [loginButton bk_addEventHandler:^(id sender) {
                //                @strongify(self);
                //弹出登录页面
            } forControlEvents:UIControlEventTouchUpInside];
        }
    }];
    _imageScrollView.contentSize = CGSizeMake(imageFrame.size.width*self.imageViews.count, imageFrame.size.height);
    
    //    _indicatorView = [[YPBImageIndicatorView alloc] initWithNumberOfIndicators:self.imageNames.count];
    //    [self.view addSubview:_indicatorView];
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
    
    _imageNames = @[/*@"login1", @"login2",*/ @"login"];
    return _imageNames;
}

//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//    NSUInteger page = scrollView.contentOffset.x / CGRectGetWidth(scrollView.bounds);
//    _indicatorView.selectedIndicator = page;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
