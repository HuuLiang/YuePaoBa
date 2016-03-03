//
//  YPBBaseViewController.m
//  YuePaoBa
//
//  Created by Sean Yue on 15/12/2.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import "YPBBaseViewController.h"

@interface YPBBaseViewController ()

@end

@implementation YPBBaseViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        if (![YPBUser currentUser].isRegistered) {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(baseOnUserRestoreNotification:) name:kUserRestoreSuccessNotification object:nil];
        }
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title {
    self = [self init];
    if (self) {
        self.title = title;
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    DLog(@"%@ dealloc\n", [self class]);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[YPBMessageCenter defaultCenter] dismissMessageWithCompletion:nil];
}

- (BOOL)isVisibleViewController {
    UIViewController *contentVC = self.sideMenuViewController.contentViewController;
    if (contentVC == self.navigationController) {
        return ((UINavigationController *)contentVC).visibleViewController == self;
    }
    return contentVC == self;
}


- (void)baseOnUserRestoreNotification:(NSNotification *)notification {
    if ([self isVisibleViewController]) {
        [self didRestoreUser:notification.object];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kUserRestoreSuccessNotification object:nil];
}

- (void)didRestoreUser:(YPBUser *)user {};

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
