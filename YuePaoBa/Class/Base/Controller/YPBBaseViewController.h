//
//  YPBBaseViewController.h
//  YuePaoBa
//
//  Created by Sean Yue on 15/12/2.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YPBBaseViewController : UIViewController

- (instancetype)initWithTitle:(NSString *)title;
- (BOOL)isVisibleViewController;
- (void)didRestoreUser:(YPBUser *)user;

@end
