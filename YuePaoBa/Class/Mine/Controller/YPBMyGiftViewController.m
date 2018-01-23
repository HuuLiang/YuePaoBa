//
//  YPBMyGiftViewController.m
//  YuePaoBa
//
//  Created by Sean Yue on 16/2/23.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "YPBMyGiftViewController.h"
#import <HMSegmentedControl.h>
#import "YPBMyGiftDetailViewController.h"
#import "YPBUserSentGiftsModel.h"
#import "YPBUserReceivedGiftsModel.h"

@interface YPBMyGiftViewController () <UIPageViewControllerDataSource,UIPageViewControllerDelegate>
{
    HMSegmentedControl *_segmentControl;
}
@property (nonatomic,retain) NSMutableArray<UIViewController *> *viewControllers;
@property (nonatomic,retain) YPBUserSentGiftsModel *sentGiftModel;
@property (nonatomic,retain) YPBUserReceivedGiftsModel *receivedGiftModel;
@end

@implementation YPBMyGiftViewController

DefineLazyPropertyInitialization(NSMutableArray, viewControllers)
DefineLazyPropertyInitialization(YPBUserSentGiftsModel, sentGiftModel)
DefineLazyPropertyInitialization(YPBUserReceivedGiftsModel, receivedGiftModel)

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的礼物";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    _segmentControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"收到的礼物",@"送出的礼物"]];
    _segmentControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    _segmentControl.borderType = HMSegmentedControlBorderTypeBottom;
    _segmentControl.borderWidth = 0.5;
    _segmentControl.borderColor = [UIColor grayColor];
    _segmentControl.selectionIndicatorColor = kThemeColor;
    _segmentControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    _segmentControl.selectionIndicatorHeight = 3;
    _segmentControl.titleFormatter = ^NSAttributedString *(HMSegmentedControl *segmentedControl, NSString *title, NSUInteger index, BOOL selected) {
        NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:title attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.]}];
        if (selected) {
            [attributeString addAttribute:NSForegroundColorAttributeName value:kThemeColor range:NSMakeRange(0, attributeString.length)];
        } else {
            [attributeString addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0, attributeString.length)];
        }
        return attributeString;
    };
    [self.view addSubview:_segmentControl];
    {
        [_segmentControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self.view);
            make.height.mas_equalTo(50);
        }];
    }
    
    YPBMyGiftDetailViewController *receivedGiftVC = [[YPBMyGiftDetailViewController alloc] initWithDataSource:self.receivedGiftModel];
    receivedGiftVC.summaryPrefix = @"共计收到的礼物";
    [self.viewControllers addObject:receivedGiftVC];
    
    YPBMyGiftDetailViewController *sentGiftVC = [[YPBMyGiftDetailViewController alloc] initWithDataSource:self.sentGiftModel];
    sentGiftVC.summaryPrefix = @"共计送出的礼物";
    [self.viewControllers addObject:sentGiftVC];
    
    UIPageViewController *pageVC = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    pageVC.delegate = self;
    pageVC.dataSource = self;
    [pageVC setViewControllers:@[self.viewControllers.firstObject] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    [self addChildViewController:pageVC];
    [self.view addSubview:pageVC.view];
    {
        [pageVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_segmentControl.mas_bottom);
            make.left.bottom.right.equalTo(self.view);
        }];
    }
    [pageVC didMoveToParentViewController:self];
    
    @weakify(self);
    _segmentControl.indexChangeBlock = ^(NSInteger index) {
        @strongify(self);
        NSUInteger previousIndex = [self.viewControllers indexOfObject:pageVC.viewControllers.lastObject];
        if (previousIndex == NSNotFound) {
            return ;
        }
        
        UIViewController *currentVC = [self.viewControllers objectAtIndex:index];
        if (currentVC) {
            [pageVC setViewControllers:@[currentVC] direction:previousIndex<index?UIPageViewControllerNavigationDirectionForward:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
        }
        
    };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIPageViewControllerDataSource,UIPageViewControllerDelegate

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSUInteger index = [self.viewControllers indexOfObject:viewController];
    if (index == self.viewControllers.count - 1) {
        return nil;
    } else {
        return [self.viewControllers objectAtIndex:index+1];
    }
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSUInteger index = [self.viewControllers indexOfObject:viewController];
    if (index == 0) {
        return nil;
    } else {
        return [self.viewControllers objectAtIndex:index-1];
    }
    return nil;
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    if (completed) {
        NSUInteger index = [self.viewControllers indexOfObject:pageViewController.viewControllers.lastObject];
        if (index != NSNotFound) {
            [_segmentControl setSelectedSegmentIndex:index animated:YES];
        }
    }
}
@end
