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


@interface YPBSegmentViewController () <UIPageViewControllerDelegate,UIPageViewControllerDataSource>
{
    UISegmentedControl *_segmentedControl;
    UIPageViewController *_pageViewController;
}
@property (nonatomic,retain) NSMutableArray <UIViewController *> *viewControllers;
@end

@implementation YPBSegmentViewController

DefineLazyPropertyInitialization(NSMutableArray, viewControllers)

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    YPBHomeViewController *homeVC = [[YPBHomeViewController alloc] init];
    [self.viewControllers addObject:homeVC];
    
    YPBCommonCityViewController *commonVC = [[YPBCommonCityViewController alloc] init];
    [self.viewControllers addObject:commonVC];
    
    _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    _pageViewController.delegate = self;
    _pageViewController.dataSource = self;
    [_pageViewController setViewControllers:@[self.viewControllers.firstObject] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [_pageViewController didMoveToParentViewController:self];
    
    NSArray *segmentItems = @[@"推 荐",@"同 城"];
    _segmentedControl = [[UISegmentedControl alloc] initWithItems:segmentItems];
    for (NSUInteger i = 0; i < segmentItems.count; ++i) {
        [_segmentedControl setWidth:66 forSegmentAtIndex:i];
    }
    _segmentedControl.selectedSegmentIndex = 0;
    [_segmentedControl addObserver:self
                        forKeyPath:NSStringFromSelector(@selector(selectedSegmentIndex))
                           options:NSKeyValueObservingOptionNew
                           context:nil];
    self.navigationItem.titleView = _segmentedControl;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"兑换"
                                                                                style:UIBarButtonItemStylePlain
                                                                              handler:^(id sender)
                                             {
                                                 YPBActivityViewController *acView = [[YPBActivityViewController alloc] init];
                                                 [self.navigationController pushViewController:acView animated:YES];
                                                 [YPBStatistics logEvent:kLogUserTabActivityButtomEvent withUser:[YPBUser currentUser].userId attributeKey:nil attributeValue:nil];

                                             }];
}

- (NSUInteger)currentIndex {
    return _segmentedControl.selectedSegmentIndex;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(selectedSegmentIndex))]) {
        NSNumber *oldValue = change[NSKeyValueChangeOldKey];
        NSNumber *newValue = change[NSKeyValueChangeNewKey];
        
        [_pageViewController setViewControllers:@[self.viewControllers[newValue.unsignedIntegerValue]]
                                      direction:newValue.unsignedIntegerValue>oldValue.unsignedIntegerValue?UIPageViewControllerNavigationDirectionForward:UIPageViewControllerNavigationDirectionReverse
                                       animated:YES completion:nil];
    }
}

#pragma mark - UIPageViewControllerDelegate,UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSUInteger viewControllerIndex = [self.viewControllers indexOfObject:viewController];
    if (viewControllerIndex != self.viewControllers.count-1) {
        return self.viewControllers[viewControllerIndex+1];
    }
    return nil;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSUInteger viewControllerIndex = [self.viewControllers indexOfObject:viewController];
    if (viewControllerIndex != 0) {
        return self.viewControllers[viewControllerIndex-1];
    }
    return nil;
}

- (void)pageViewController:(UIPageViewController *)pageViewController
        didFinishAnimating:(BOOL)finished
   previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers
       transitionCompleted:(BOOL)completed
{
    if (completed) {
        _segmentedControl.selectedSegmentIndex = [self.viewControllers indexOfObject:pageViewController.viewControllers.firstObject];
    }
}


@end
