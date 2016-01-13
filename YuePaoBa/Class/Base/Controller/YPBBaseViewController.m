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
        _rootVCHasSideMenu = YES;
        
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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (self.rootVCHasSideMenu) {
        if (self.navigationController.viewControllers[0] == self) {
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] bk_initWithImage:[UIImage imageNamed:@"side_menu_button"] style:UIBarButtonItemStylePlain handler:^(id sender) {
                [self.sideMenuViewController presentLeftMenuViewController];
            }];
        }
    }
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
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didRestoreUser:(YPBUser *)user {};

- (void)dealloc {
    DLog(@"%@ dealloc\n", [self class]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
