//
//  YPBMessageViewController.h
//  YuePaoBa
//
//  Created by Sean Yue on 15/12/3.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import "XHMessageTableViewController.h"
#import "YPBChatMessage.h"

@class YPBContact;

@interface YPBMessageViewController : XHMessageTableViewController

@property (nonatomic,retain,readonly) YPBUser *user;
@property (nonatomic,retain,readonly) YPBContact *contact;

+ (instancetype)showMessageWithUser:(YPBUser *)user inViewController:(UIViewController *)viewController;
+ (instancetype)showMessageForWeChatWithUser:(YPBUser *)user inViewController:(UIViewController *)viewController;
+ (instancetype)showMessageWithContact:(YPBContact *)contact inViewController:(UIViewController *)viewController;

+ (void)sendGreetMessageWith:(YPBUser *)user inViewController:(UIViewController *)viewController;;

- (void)sendMessage:(NSString *)message withSender:(NSString *)sender;

+ (void)sendSystemMessageWith:(YPBContact *)contact Type:(YPBRobotPushType)type count:(NSInteger)count inViewController:(UIViewController *)viewController;

@end
