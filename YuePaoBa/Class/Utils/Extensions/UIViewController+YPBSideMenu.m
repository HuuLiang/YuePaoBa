//
//  UIViewController+YPBSideMenu.m
//  YuePaoBa
//
//  Created by Sean Yue on 15/12/3.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import "UIViewController+YPBSideMenu.h"

#define kDefaultSideMenuItemHeight (kScreenHeight * 0.1)

@implementation YPBSideMenuItem

+ (instancetype)itemWithTitle:(NSString *)title
                        image:(UIImage *)image {
    return [self itemWithTitle:title image:image height:kDefaultSideMenuItemHeight delegate:nil];
}

+ (instancetype)itemWithTitle:(NSString *)title
                        image:(UIImage *)image
                       height:(CGFloat)height {
    return [self itemWithTitle:title image:image height:height delegate:nil];
}

+ (instancetype)itemWithTitle:(NSString *)title
                        image:(UIImage *)image
                     delegate:(id<YPBSideMenuItemDelegate>)delegate {
    return [self itemWithTitle:title image:image height:kDefaultSideMenuItemHeight delegate:delegate];
}

+ (instancetype)itemWithTitle:(NSString *)title
                        image:(UIImage *)image
                       height:(CGFloat)height
                     delegate:(id<YPBSideMenuItemDelegate>)delegate {
    YPBSideMenuItem *item = [[self alloc] init];
    item.title = title;
    item.image = image;
    item.height = height;
    item.delegate = delegate;
    return item;
}

@end

static const void* kSideMenuItemAssociatedKey = &kSideMenuItemAssociatedKey;

@implementation UIViewController (YPBSideMenu)

- (YPBSideMenuItem *)sideMenuItem {
    return objc_getAssociatedObject(self, kSideMenuItemAssociatedKey);
}

- (void)setSideMenuItem:(YPBSideMenuItem *)sideMenuItem {
    objc_setAssociatedObject(self, kSideMenuItemAssociatedKey, sideMenuItem, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
