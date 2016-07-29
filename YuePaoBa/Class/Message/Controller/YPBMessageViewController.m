//
//  YPBMessageViewController.m
//  YuePaoBa
//
//  Created by Sean Yue on 15/12/3.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import "YPBMessageViewController.h"
#import "YPBContact.h"
#import "YPBUserDetailViewController.h"
#import "YPBVIPPriviledgeViewController.h"
#import "YPBMessagePushModel.h"
#import "YPBAutoReplyMessagePool.h"
#import "YPBImageViewController.h"
#import "YPBActivityPayView.h"
#import "YPBEditMineDetailViewController.h"
#import "YPBMineAccessViewController.h"
#import "YPBMessageCenter.h"

static const void *kMessageCellBottomLabelAssociatedKey = &kMessageCellBottomLabelAssociatedKey;

static NSString *const kRobotPushWelcomeIdentifier = @"kRobotPushWelcomeIdentifier";
static NSString *const kRobotPushGreetIdentifier   = @"kRobotPushGreetIdentifier";
static NSString *const kNoUserInfoErrorMessage = @"无法获取用户详细信息，请刷新后重试";


@interface YPBMessageViewController ()
{
    
}
@property (nonatomic,readonly) NSString *userId;
@property (nonatomic,readonly) NSString *logoUrl;
@property (nonatomic,readonly) NSString *nickName;
@property (nonatomic,readonly) YPBUserType userType;
@property (nonatomic,retain) NSMutableArray<YPBChatMessage *> *chatMessages;
@property (nonatomic) YPBActivityPayView *payView;
@end

@implementation YPBMessageViewController

DefineLazyPropertyInitialization(NSMutableArray, chatMessages)

+ (instancetype)showMessageWithUser:(YPBUser *)user inViewController:(UIViewController *)viewController {
    YPBMessageViewController *messageVC = [[self alloc] initWithUser:user];
    [viewController.navigationController pushViewController:messageVC animated:YES];
    return messageVC;
}

+ (instancetype)showMessageForWeChatWithUser:(YPBUser *)user inViewController:(UIViewController *)viewController; {
    YPBMessageViewController *messageVC = [self showMessageWithUser:user inViewController:viewController];
    if (user.weixinNum.length > 0) {
        [messageVC sendMessage:[NSString stringWithFormat:@"我的微信号是%@，快联系我吧~~~", user.weixinNum] withSender:user.userId];
    } else {
        [messageVC sendMessage:@"亲，我俩很投缘，能要一下你的微信号吗？" withSender:[YPBUser currentUser].userId];
    }
    return messageVC;
}

+ (instancetype)showMessageWithContact:(YPBContact *)contact inViewController:(UIViewController *)viewController {
    YPBMessageViewController *messageVC = [[self alloc] initWithContact:contact];
    [viewController.navigationController pushViewController:messageVC animated:YES];
    return messageVC;
}

+ (void)sendGreetMessageWith:(YPBUser *)user inViewController:(UIViewController *)viewController {
    YPBMessageViewController *messageVC = [[self alloc] initWithUser:user];
    [viewController.navigationController pushViewController:messageVC animated:NO];
    [messageVC sendMessage:@"你好，我对你的眼缘不错，可以进一步聊聊吗" withSender:[YPBUser currentUser].userId];
    if (![NSStringFromClass(viewController.class) isEqualToString:@"YPBUserDetailViewController"]) {
        [messageVC.navigationController popToRootViewControllerAnimated:NO];
    } else {
        [messageVC.navigationController popViewControllerAnimated:NO];
    }
}

+ (void)sendSystemMessageWith:(YPBContact *)contact Type:(YPBRobotPushType)type count:(NSInteger)count inViewController:(UIViewController *)viewController {
    YPBMessageViewController *messageVC = [[self alloc] initWithContact:contact];
    [viewController.navigationController pushViewController:messageVC animated:NO];
    if (type == YPBRobotPushTypeWelCome) {
        [messageVC addTextMessage:kRobotPushWelcomeIdentifier withSender:contact.userId receiver:[YPBUser currentUser].userId dateTime:[YPBUtil stringFromDate:[NSDate date]]];
    } else if (type == YPBRobotPushTypeGreet) {
        [messageVC addTextMessage:[NSString stringWithFormat:@"%@%@%ld",kRobotPushGreetIdentifier,YPBROBOTID,count] withSender:contact.userId receiver:[YPBUser currentUser].userId dateTime:[YPBUtil stringFromDate:[NSDate date]]];
    }
    [messageVC.navigationController popToRootViewControllerAnimated:NO];
}


- (instancetype)init {
    self = [super init];
    if (self) {
        self.allowsSendVoice = NO;
        self.allowsSendMultiMedia = NO;
        self.allowsSendFace = NO;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onMessagePushNotification:)
                                                     name:kMessagePushNotification
                                                   object:nil];
    }
    return self;
}

- (instancetype)initWithUser:(YPBUser *)user {
    self = [self init];
    if (self) {
        _user = user;
    }
    return self;
}

- (instancetype)initWithContact:(YPBContact *)contact {
    self = [self init];
    if (self) {
        _contact = contact;
    }
    return self;
}

- (void)sendMessage:(NSString *)message withSender:(NSString *)sender {
    if (self.userId.length == 0 || ![YPBUser currentUser].isRegistered) {
        return ;
    }
    
    NSString *receiver = [sender isEqualToString:self.userId] ? [YPBUser currentUser].userId : self.userId;
    [self addTextMessage:message withSender:sender receiver:receiver dateTime:[YPBUtil currentDateString]];
}

- (NSString *)userId {
    return _user ? _user.userId : _contact.userId;
}

- (NSString *)logoUrl {
    return _user ? _user.logoUrl : _contact.logoUrl;
}

- (NSString *)nickName {
    return _user ? _user.nickName : _contact.nickName;
}

- (YPBUserType)userType {
    return _user ? [_user.userType integerValue] : _contact.userType;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.messageTableView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
    self.title = self.user ? self.user.nickName : self.contact.nickName;
    self.messageSender = [YPBUser currentUser].userId;
    
//    if ([self.contact.nickName isEqualToString:@"红娘小助手"]) {
//        self.title = @"心动速配小红娘";
//        //测试用
//        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"测试"
//                                                                                     style:UIBarButtonItemStylePlain
//                                                                                   handler:^(id sender)
//                                                  {
////                                                      [self addTextMessage:kRobotPushWelcomeIdentifier withSender:self.contact.userId receiver:[YPBUser currentUser].userId dateTime:[YPBUtil stringFromDate:[NSDate date]]];
//                                                      
//                                                      [self addTextMessage:kRobotPushGreetIdentifier withSender:self.contact.userId receiver:[YPBUser currentUser].userId dateTime:[YPBUtil stringFromDate:[NSDate date]]];
//                                                  }];
//    }
//    


}

- (void)reloadChatMessages {
    self.chatMessages = [YPBChatMessage allMessagesForUser:self.userId].mutableCopy;
    
    NSMutableArray<XHMessage *> *messages = [NSMutableArray array];
    [self.chatMessages enumerateObjectsUsingBlock:^(YPBChatMessage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        XHMessage *message = [[XHMessage alloc] initWithText:obj.msg type:@(obj.msgType) sender:obj.sendUserId timestamp:[YPBUtil dateFromString:obj.msgTime]];
        if ([obj.sendUserId isEqualToString:[YPBUser currentUser].userId]) {
            message.bubbleMessageType = XHBubbleMessageTypeSending;
        } else {
            message.bubbleMessageType = XHBubbleMessageTypeReceiving;
        }
        [messages addObject:message];
    }];
    self.messages = messages;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self reloadChatMessages];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    YPBChatMessage *lastMessage = self.chatMessages.lastObject;
    if (lastMessage.msgType == YPBChatMessageTypeOption) {
        @weakify(self);
        [self showOptionsWithChatMessage:lastMessage completion:^(NSUInteger idx, NSString *selection) {
            @strongify(self);
            if (selection.length > 0) {
                [self addTextMessage:selection
                          withSender:[YPBUser currentUser].userId
                            receiver:self.userId
                            dateTime:[YPBUtil stringFromDate:[NSDate date]]];
            }
            [self.messageInputView.inputTextView becomeFirstResponder];
        }];
    } else {
        [self.messageInputView.inputTextView becomeFirstResponder];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (self.chatMessages.count == 0) {
        return ;
    }
    
    YPBChatMessage *recentChatMessage = self.chatMessages.lastObject;
    YPBContact *contact = [YPBContact existingContactWithUserId:self.userId];
    [contact saveOrUpdate];
    
    if (![contact.recentTime isEqualToString:recentChatMessage.msgTime]
        || ![contact.recentMessage isEqualToString:recentChatMessage.msg]) {
        contact.recentTime = recentChatMessage.msgTime;
        contact.recentMessage = recentChatMessage.msg;
        if ([contact.userId isEqualToString:YPBROBOTID]) {
            if ([contact.recentMessage isEqualToString:kRobotPushWelcomeIdentifier]) {
                contact.recentMessage = @"欢迎来到红娘小助手";
            } else if ([[contact.recentMessage componentsSeparatedByString:YPBROBOTID][0] isEqualToString:kRobotPushGreetIdentifier]) {
                contact.recentMessage = [NSString stringWithFormat:@"有%@人给您打了招呼快来看看吧！",[contact.recentMessage componentsSeparatedByString:YPBROBOTID][1]];
            }
        }
    }
    
    contact.unreadMessages = 0;
    [contact saveOrUpdate];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kUnreadMessageChangeNotification object:nil];
}

- (void)showOptionsWithChatMessage:(YPBChatMessage *)chatMessage
                        completion:(void (^)(NSUInteger idx, NSString *selection))completion
{
    UIActionSheet *actionSheet = [UIActionSheet bk_actionSheetWithTitle:chatMessage.msg];
    
    NSArray<NSString *> *options = [chatMessage.options componentsSeparatedByString:@";"];
    [options enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [actionSheet bk_addButtonWithTitle:obj handler:^{
            SafelyCallBlock2(completion, idx, obj);
        }];
    }];
    
    [actionSheet bk_setDestructiveButtonWithTitle:@"不想回答" handler:^{
        SafelyCallBlock2(completion, NSNotFound, nil);
    }];
    [actionSheet showInView:self.view];
}

- (void)onMessagePushNotification:(NSNotification *)notification {
    NSArray<YPBChatMessage *> *messages = notification.object;
    NSArray<YPBChatMessage *> *filteredMessages = [messages bk_select:^BOOL(YPBChatMessage *msg) {
        return [msg.receiveUserId isEqualToString:self.userId] || [msg.sendUserId isEqualToString:self.userId];
    }];
    
    NSArray<YPBChatMessage *> *sortedMessages = [filteredMessages sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        YPBChatMessage *message1 = obj1;
        YPBChatMessage *message2 = obj2;
        return [message1.msgTime compare:message2.msgTime];
    }];
    
    [sortedMessages enumerateObjectsUsingBlock:^(YPBChatMessage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self addChatMessage:obj];
    }];
}

- (void)addTextMessage:(NSString *)message
            withSender:(NSString *)sender
              receiver:(NSString *)receiver
              dateTime:(NSString *)dateTime
{
    YPBChatMessage *chatMessage = [YPBChatMessage chatMessage];
    chatMessage.sendUserId = sender;
    chatMessage.receiveUserId = receiver;
    chatMessage.msgType = YPBChatMessageTypeWord;
    chatMessage.msg = message;
    chatMessage.msgTime = dateTime;
    if ([chatMessage.sendUserId isEqualToString:YPBROBOTID]) {
        chatMessage.msgType = YPBChatMessageTypeRobotPush;
    }

    [self addChatMessage:chatMessage];
    
    if ([sender isEqualToString:[YPBUser currentUser].userId] && self.userType != YPBUserTypeReal) {
        [[YPBAutoReplyMessagePool sharedPool] addChatMessageForReply:chatMessage];
    }
}

- (void)addChatMessage:(YPBChatMessage *)chatMessage {
    [chatMessage saveOrUpdate];
    [self.chatMessages addObject:chatMessage];
    
    if (self.isViewLoaded) {
        XHMessage *xhMsg = [[XHMessage alloc] initWithText:chatMessage.msg
                                                      type:@(chatMessage.msgType)
                                                    sender:chatMessage.sendUserId
                                                 timestamp:[YPBUtil dateFromString:chatMessage.msgTime]];
        if ([chatMessage.sendUserId isEqualToString:[YPBUser currentUser].userId]) {
            xhMsg.bubbleMessageType = XHBubbleMessageTypeSending;
        } else {
            xhMsg.bubbleMessageType = XHBubbleMessageTypeReceiving;
        }
        [self addMessage:xhMsg];
        
        if (self.chatMessages.count > 1) {
            [self.messageTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.chatMessages.count-2 inSection:0]]
                                         withRowAnimation:UITableViewRowAnimationNone];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - XHMessageTableViewControllerDelegate

- (void)didSendText:(NSString *)text fromSender:(NSString *)sender onDate:(NSDate *)date {
    
    if ([YPBUtil isVIP] || [self.contact.userId isEqualToString:YPBROBOTID]) {
        [self addTextMessage:text withSender:sender receiver:self.userId dateTime:[YPBUtil stringFromDate:date]];
        [self finishSendMessageWithBubbleMessageType:XHBubbleMessageMediaTypeText];
    } else {
        [self popPayView];
        
        [self.messageInputView.inputTextView resignFirstResponder];
    }
    
    [YPBStatistics logEvent:kLogUserChatEvent fromUser:[YPBUser currentUser].userId toUser:self.userId];
}

- (void)configureCell:(XHMessageTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    XHMessage *message = self.messages[indexPath.row];
//    YPBChatMessage *chatMessage = self.chatMessages[indexPath.row];
    BOOL isCurrentUser = [message.sender isEqualToString:[YPBUser currentUser].userId];
    if (isCurrentUser) {
        [cell.avatarButton sd_setImageWithURL:[NSURL URLWithString:[YPBUser currentUser].logoUrl]
                                     forState:UIControlStateNormal
                             placeholderImage:[UIImage imageNamed:@"avatar_placeholder"]];
        [cell.avatarButton bk_removeEventHandlersForControlEvents:UIControlEventTouchUpInside];
        cell.userNameLabel.text = [YPBUser currentUser].nickName;
    } else {
        [cell.avatarButton sd_setImageWithURL:[NSURL URLWithString:self.logoUrl]
                                     forState:UIControlStateNormal
                             placeholderImage:[UIImage imageNamed:@"avatar_placeholder"]];
        @weakify(self);
        [cell.avatarButton bk_addEventHandler:^(id sender) {
            @strongify(self);
            YPBUserDetailViewController *detailVC = [[YPBUserDetailViewController alloc] initWithUserId:self.userId];
            [self.navigationController pushViewController:detailVC animated:YES];
        } forControlEvents:UIControlEventTouchUpInside];
        cell.userNameLabel.text = self.nickName;
    }
    
    cell.avatarButton.layer.cornerRadius = CGRectGetWidth(cell.avatarButton.frame) / 2;
    cell.avatarButton.layer.masksToBounds = YES;
    
    UILabel *bottomLabel = objc_getAssociatedObject(cell, kMessageCellBottomLabelAssociatedKey);
    if (indexPath.row == self.chatMessages.count - 1 && isCurrentUser) {
        if (!bottomLabel) {
            bottomLabel = [[UILabel alloc] init];
            objc_setAssociatedObject(cell, kMessageCellBottomLabelAssociatedKey, bottomLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            
            bottomLabel.font = [UIFont systemFontOfSize:12.];
            [cell addSubview:bottomLabel];
            {
                [bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(cell.messageBubbleView.bubbleImageView);
                    make.top.equalTo(cell.messageBubbleView.bubbleImageView.mas_bottom);
                }];
            }
        }
        bottomLabel.text = @"请等待ta的回复...";
    } else {
        bottomLabel.text = nil;
    }
}

- (void)configRobotCell:(YPBRobotTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    YPBChatMessage *message = self.chatMessages[indexPath.row];
    [cell.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    cell.userInteractionEnabled = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.robotPushAction = ^(id obj) {
        YPBImageViewController *imgVC = [[YPBImageViewController alloc] initWithImageUrl:YPB_ROBOT_URL];
        imgVC.title = @"红娘助手";
        [self.navigationController pushViewController:imgVC animated:YES];
    };

    if (message.msgType == YPBChatMessageTypeRobotPush) {
        if ([message.msg isEqualToString:kRobotPushWelcomeIdentifier]) {
            [cell layoutWelcomeSubviewsWithInfo:self.contact.logoUrl];
            cell.editCell.userInteractionEnabled = YES;
            [cell.editCell bk_whenTapped:^{
                if ([YPBUser currentUser].isRegistered) {
                    YPBEditMineDetailViewController *editView = [[YPBEditMineDetailViewController alloc] initWithUser:[YPBUser currentUser]];
                    [self.navigationController pushViewController:editView animated:YES];
                } else {
                    [[YPBMessageCenter defaultCenter] showErrorWithTitle:kNoUserInfoErrorMessage inViewController:self];
                }
            }];
        } else if ([[message.msg componentsSeparatedByString:YPBROBOTID][0] isEqualToString:kRobotPushGreetIdentifier]) {
            [cell layoutGreetSubviewsWithInfo:self.contact.logoUrl count:[message.msg componentsSeparatedByString:YPBROBOTID][1]];
            [cell.greetCell bk_whenTapped:^{
                if ([YPBUser currentUser].isRegistered) {
                    YPBMineAccessViewController *recvVC = [[YPBMineAccessViewController alloc] initWithAccessType:YPBMineAccessTypeGreetingReceived];
                    [self.navigationController pushViewController:recvVC animated:YES];
                } else {
                    [[YPBMessageCenter defaultCenter] showErrorWithTitle:kNoUserInfoErrorMessage inViewController:self];
                }
            }];
        }
    }
}

- (BOOL)shouldDisplayTimestampForRowAtIndexPath:(NSIndexPath *)indexPath {
    XHMessage *previousMessage = indexPath.row > 0 ? self.messages[indexPath.row-1] : nil;
    if (previousMessage) {
        XHMessage *currentMessage = self.messages[indexPath.row];
        if ([currentMessage.timestamp isEqualToDateIgnoringSecond:previousMessage.timestamp]) {
            return NO;
        }
    }
    return YES;
}

//- (BOOL)shouldLoadMoreMessagesScrollToTop {
//    return YES;
//}
//
//- (void)loadMoreMessagesScrollTotop {
//    self.loadingMoreMessage = YES;
//}

- (void)popPayView {
    [self.view beginLoading];
    
    _payView = [[YPBActivityPayView alloc] init];
    [self.view addSubview:_payView];
    @weakify(self);
    _payView.closeBlock = ^(void) {
        @strongify(self);
        [self.view endLoading];
        [self.payView removeFromSuperview];
    };
    
    {
        [_payView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.centerY.equalTo(self.view).offset(0);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH*0.8, SCREEN_HEIGHT*0.6));
        }];
    }
}
@end
