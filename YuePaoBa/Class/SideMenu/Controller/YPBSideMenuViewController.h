//
//  YPBSideMenuViewController.h
//  YuePaoBa
//
//  Created by Sean Yue on 15/12/2.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import "YPBBaseViewController.h"

@interface YPBSideMenuViewController : YPBBaseViewController <RESideMenuDelegate>

@property (nonatomic,retain,readonly) NSArray<UIViewController *> *viewControllers;
@property (nonatomic) NSUInteger selectedIndex;

- (instancetype)initWithViewControllers:(NSArray<UIViewController *> *)viewControllers;

@end
