//
//  UIViewController+YPBSideMenu.h
//  YuePaoBa
//
//  Created by Sean Yue on 15/12/3.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YPBSideMenuItem;
@class YPBSideMenuViewController;

@protocol YPBSideMenuItemDelegate <NSObject>

@optional
- (void)sideMenuController:(UIViewController *)viewController willAddToSideMenuCell:(UITableViewCell *)cell;
- (BOOL)sideMenuController:(UIViewController *)sideMenuVC shouldPresentContentViewController:(UIViewController *)contentVC;
- (CGFloat)sideMenuItemHeight;
- (NSString *)badgeValueOfSideMenuItem:(YPBSideMenuItem *)sideMenuItem;

@end

@interface YPBSideMenuItem : NSObject
@property (nonatomic) NSString *title;
@property (nonatomic) UIImage *image;
@property (nonatomic) CGFloat height; // menu cell height
@property (nonatomic,assign) id<YPBSideMenuItemDelegate> delegate;
@property (nonatomic,weak) UIViewController *viewController;

+ (instancetype)itemWithTitle:(NSString *)title
                        image:(UIImage *)image;

+ (instancetype)itemWithTitle:(NSString *)title
                        image:(UIImage *)image
                       height:(CGFloat)height;

+ (instancetype)itemWithTitle:(NSString *)title
                        image:(UIImage *)image
                     delegate:(id<YPBSideMenuItemDelegate>)delegate;

+ (instancetype)itemWithTitle:(NSString *)title
                        image:(UIImage *)image
                       height:(CGFloat)height
                     delegate:(id<YPBSideMenuItemDelegate>)delegate;

@end

@interface UIViewController (YPBSideMenu)

@property (nonatomic,retain) YPBSideMenuItem *sideMenuItem;
@property (nonatomic,weak) YPBSideMenuViewController *sideMenuVC;

@end
