//
//  YPBSegmentViewController.m
//  YuePaoBa
//
//  Created by Liang on 16/5/4.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "YPBSegmentViewController.h"
#import "YPBHomeViewController.h"
#import "YPBCommonCityViewController.h"
#import "YPBActivityViewController.h"
#import "YPBStatistics.h"


@interface YPBSegmentViewController () <UIScrollViewDelegate> {
  
}
@property (nonatomic ) UISegmentedControl  *headerSegment;
@property (nonatomic ) UIScrollView        *contentScrollview;
@property (nonatomic,strong) YPBHomeViewController  * first;
@property (nonatomic,strong) YPBCommonCityViewController * second;

@end

@implementation YPBSegmentViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *array = [NSArray arrayWithObjects:@"今日推荐",@"同城交友", nil];
    _headerSegment = [[UISegmentedControl alloc] initWithItems:array];
    self.navigationItem.titleView = _headerSegment;
    
    _headerSegment.selectedSegmentIndex = 0;
    
    [self setUpScrollView];
    [self setUpChildViewControll];
    [_headerSegment addTarget:self action:@selector(segmentSelect:) forControlEvents:UIControlEventValueChanged];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"兑换"
                                                                                style:UIBarButtonItemStylePlain
                                                                              handler:^(id sender)
                                             {
                                                 YPBActivityViewController *acView = [[YPBActivityViewController alloc] init];
                                                 [self.navigationController pushViewController:acView animated:YES];
                                                 [YPBStatistics logEvent:kLogUserTabActivityButtomEvent withUser:[YPBUser currentUser].userId attributeKey:nil attributeValue:nil];

                                             }];
    
    
}


-(void)segmentSelect:(UISegmentedControl*)seg{
    NSInteger index = seg.selectedSegmentIndex;
    CGRect frame = _contentScrollview.frame;
    frame.origin.x = index * CGRectGetWidth(_contentScrollview.frame);
    frame.origin.y = 0;
    [_contentScrollview scrollRectToVisible:frame animated:YES];
}
-(void)setUpScrollView{
    _contentScrollview = [[UIScrollView alloc] init];
    [self.view addSubview:_contentScrollview];
    _contentScrollview.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64);
    _contentScrollview.pagingEnabled = YES;
    _contentScrollview.delegate = self;
    _contentScrollview.showsHorizontalScrollIndicator = NO;
    _contentScrollview.showsVerticalScrollIndicator = NO;
    _contentScrollview.bounces = NO;
    //方向锁
    _contentScrollview.directionalLockEnabled = YES;
    //取消自动布局
    self.automaticallyAdjustsScrollViewInsets = NO;
    _contentScrollview.contentSize = CGSizeMake(SCREEN_WIDTH * 2, SCREEN_HEIGHT - 64);
}
/**
 *  设置控制的每一个子控制器
 */
-(void)setUpChildViewControll{
    self.first = [[YPBHomeViewController alloc] initWithTitle:@"今日推荐"];
    self.second = [[YPBCommonCityViewController alloc] initWithTitle:@"同城交友"];
    //指定该控制器为其子控制器
    [self addChildViewController:_first];
    [self addChildViewController:_second];
    //将视图view加入到scrollview上
    [_contentScrollview addSubview:_first.view];
    [_contentScrollview addSubview:_second.view];
    //设置两个控制器的  位置
    CGRect secondRect = _second.view.frame;
    secondRect.origin.x = SCREEN_WIDTH;
    secondRect.size.height = CGRectGetHeight(_contentScrollview.frame);
    _second.view.frame = secondRect;
}

#pragma mark - Scrollview delegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat offSetX = scrollView.contentOffset.x;
    NSInteger ratio = round(offSetX / SCREEN_WIDTH);
    _headerSegment.selectedSegmentIndex = ratio;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
