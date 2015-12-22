//
//  YPBBaseViewController.h
//  YuePaoBa
//
//  Created by Sean Yue on 15/12/2.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YPBBaseViewController : UIViewController <YPBSideMenuItemDelegate>

@property (nonatomic) BOOL rootVCHasSideMenu;

- (instancetype)initWithTitle:(NSString *)title;

@end
