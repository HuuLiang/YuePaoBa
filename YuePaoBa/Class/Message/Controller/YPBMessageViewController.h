//
//  YPBMessageViewController.h
//  YuePaoBa
//
//  Created by Sean Yue on 15/12/3.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import "XHMessageTableViewController.h"

@class YPBContact;

@interface YPBMessageViewController : XHMessageTableViewController

@property (nonatomic,retain,readonly) YPBUser *user;
@property (nonatomic,retain,readonly) YPBContact *contact;

+ (instancetype)showMessageWithUser:(YPBUser *)user inViewController:(UIViewController *)viewController;
+ (instancetype)showMessageForWeChatWithUser:(YPBUser *)user inViewController:(UIViewController *)viewController;
+ (instancetype)showMessageWithContact:(YPBContact *)contact inViewController:(UIViewController *)viewController;

- (void)sendMessage:(NSString *)message withSender:(NSString *)sender;

@end
