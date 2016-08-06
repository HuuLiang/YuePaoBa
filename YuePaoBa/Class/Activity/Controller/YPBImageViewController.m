//
//  YPBImageViewController.m
//  YuePaoBa
//
//  Created by Liang on 16/7/28.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "YPBImageViewController.h"

@interface YPBImageViewController ()
{
    NSString *_imgUrl;
    UIImageView *_imageView;
    UIScrollView *_scrollView;
}

@end

@implementation YPBImageViewController

- (instancetype)initWithImageUrl:(NSString *)imgUrl
{
    self = [super init];
    if (self) {
        _imgUrl = imgUrl;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    {
        [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth * 1743/750.)];
    [_scrollView addSubview:_imageView];
    
    [_imageView sd_setImageWithURL:[NSURL URLWithString:_imgUrl]];
    
    _scrollView.contentSize = CGSizeMake(kScreenWidth, kScreenWidth * 1743/750.);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
