//
//  UIViewController+YPBSideMenu.m
//  YuePaoBa
//
//  Created by Sean Yue on 15/12/3.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import "UIViewController+YPBSideMenu.h"
#import "YPBSideMenuViewController.h"

#define kDefaultSideMenuItemHeight (kScreenHeight * 0.1)

@implementation YPBSideMenuItem

//+ (instancetype)itemWithTitle:(NSString *)title
//                        image:(UIImage *)image {
//    return [self itemWithTitle:title image:image height:kDefaultSideMenuItemHeight delegate:nil];
//}
//
//+ (instancetype)itemWithTitle:(NSString *)title
//                        image:(UIImage *)image
//                       height:(CGFloat)height {
//    return [self itemWithTitle:title image:image height:height delegate:nil];
//}
//
//+ (instancetype)itemWithTitle:(NSString *)title
//                        image:(UIImage *)image
//                     delegate:(id<YPBSideMenuItemDelegate>)delegate {
//    return [self itemWithTitle:title image:image height:kDefaultSideMenuItemHeight delegate:delegate];
//}
//
//+ (instancetype)itemWithTitle:(NSString *)title
//                        image:(UIImage *)image
//                       height:(CGFloat)height
//                     delegate:(id<YPBSideMenuItemDelegate>)delegate {
//    YPBSideMenuItem *item = [[self alloc] init];
//    item.title = title;
//    item.image = image;
//    item.height = height;
//    item.delegate = delegate;
//    return item;
//}

+ (instancetype)itemWithTitle:(NSString *)title
                        image:(UIImage *)image
           rootViewController:(UIViewController *)rootViewController {
    return [self itemWithTitle:title image:image height:kDefaultSideMenuItemHeight rootViewController:rootViewController delegate:nil];
}

+ (instancetype)itemWithTitle:(NSString *)title
                        image:(UIImage *)image
           rootViewController:(UIViewController *)rootViewController
                     delegate:(id<YPBSideMenuItemDelegate>)delegate {
    return [self itemWithTitle:title image:image height:kDefaultSideMenuItemHeight rootViewController:rootViewController delegate:delegate];
}

+ (instancetype)itemWithTitle:(NSString *)title
                        image:(UIImage *)image
                       height:(CGFloat)height
           rootViewController:(UIViewController *)rootViewController
                     delegate:(id<YPBSideMenuItemDelegate>)delegate {
    YPBSideMenuItem *item = [[self alloc] init];
    item.title = title;
    item.image = image;
    item.height = height;
    item.delegate = delegate;
    item.rootViewController = rootViewController;
    return item;
}
@end

//static const void* kSideMenuItemAssociatedKey = &kSideMenuItemAssociatedKey;
static const void* kSideMenuVCAssociatedKey = &kSideMenuVCAssociatedKey;

@implementation UIViewController (YPBSideMenu)

//- (YPBSideMenuItem *)sideMenuItem {
//    YPBSideMenuItem *sideMenuItem = objc_getAssociatedObject(self, kSideMenuItemAssociatedKey);
//    if (sideMenuItem) {
//        return sideMenuItem;
//    }
//    return self.navigationController.sideMenuItem;
//}
//
//- (void)setSideMenuItem:(YPBSideMenuItem *)sideMenuItem {
//    sideMenuItem.viewController = self;
//    objc_setAssociatedObject(self, kSideMenuItemAssociatedKey, sideMenuItem, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//}

- (YPBSideMenuViewController *)sideMenuVC {
    return objc_getAssociatedObject(self, kSideMenuVCAssociatedKey);
}

- (void)setSideMenuVC:(YPBSideMenuViewController *)sideMenuVC {
    objc_setAssociatedObject(self, kSideMenuVCAssociatedKey, sideMenuVC, OBJC_ASSOCIATION_ASSIGN);
}
@end
