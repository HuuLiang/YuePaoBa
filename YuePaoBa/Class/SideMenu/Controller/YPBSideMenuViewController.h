//
//  YPBSideMenuViewController.h
//  YuePaoBa
//
//  Created by Sean Yue on 15/12/2.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import "YPBLayoutViewController.h"

@interface YPBSideMenuViewController : YPBLayoutViewController <RESideMenuDelegate>

@property (nonatomic,retain,readonly) NSArray<YPBSideMenuItem *> *sideMenuItems;
@property (nonatomic,readonly) NSString *badgeValue;
//@property (nonatomic,retain,readonly) NSArray<UIViewController *> *viewControllers;
//@property (nonatomic) NSUInteger selectedIndex;

//- (instancetype)initWithViewControllers:(NSArray<UIViewController *> *)viewControllers;
- (instancetype)initWithSideMenuItems:(NSArray<YPBSideMenuItem *> *)sideMenuItems;

@end
