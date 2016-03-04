//
//  YPBLiveShowUserDetailPanel.h
//  YuePaoBa
//
//  Created by Sean Yue on 16/2/25.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YPBLiveShowUserDetailPanel : UIView

@property (nonatomic,retain,readonly,nonnull) YPBUser *user;
@property (nonatomic,readonly) BOOL isShown;
@property (nonatomic,copy,nullable) YPBAction greetAction;

- (nonnull instancetype)init __attribute__((unavailable("Must use initWithUser: instead.")));
- (nonnull instancetype)initWithUser:(nonnull YPBUser *)user;

- (void)showInView:(nonnull UIView *)view;
- (void)hide;

@end
