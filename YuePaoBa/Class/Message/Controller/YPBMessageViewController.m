//
//  YPBMessageViewController.m
//  YuePaoBa
//
//  Created by Sean Yue on 15/12/3.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import "YPBMessageViewController.h"
#import "YPBContact.h"
#import "YPBChatMessage.h"
#import "YPBUserDetailViewController.h"
#import "YPBVIPEntranceView.h"
#import "YPBVIPPriviledgeViewController.h"
#import "YPBMessagePushModel.h"
#import "YPBAutoReplyMessagePool.h"
#import "YPBBlacklist.h"


static const void *kMessageCellBottomLabelAssociatedKey = &kMessageCellBottomLabelAssociatedKey;

@interface YPBMessageViewController ()
{
    
}
@property (nonatomic,readonly) NSString *userId;
@property (nonatomic,readonly) NSString *logoUrl;
@property (nonatomic,readonly) NSString *nickName;
@property (nonatomic,readonly) YPBUserType userType;

@property (nonatomic,retain) NSMutableArray<YPBChatMessage *> *chatMessages;
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
    return _user ? _user.userType.unsignedIntegerValue : _contact.userType.unsignedIntegerValue;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.messageTableView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
    self.title = self.user ? self.user.nickName : self.contact.nickName;
    self.messageSender = [YPBUser currentUser].userId;
    
    [self reloadChatMessagesWithComletion:^{
        YPBChatMessage *lastMessage = self.chatMessages.lastObject;
        if (lastMessage.msgType.unsignedIntegerValue == YPBChatMessageTypeOption && [[YPBUser currentUser].sex isEqualToString:@"M"]) {
            DLog(@"问题列表出现，%@----%@",lastMessage,[YPBUser currentUser].sex);
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
            DLog(@"----becomeFirstResponder-----");
            [self.messageInputView.inputTextView becomeFirstResponder];
        }
        
        [self updateUnreadMessageInContact];
    }];
}

- (void)reloadChatMessagesWithComletion:(void (^)(void))completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSArray<YPBChatMessage *> *chatMessages = [YPBChatMessage allMessagesForUser:self.userId];
        
        NSMutableArray<YPBChatMessage *> *copiedChatMessages = [NSMutableArray array];
        NSMutableArray<XHMessage *> *messages = [NSMutableArray array];
        [chatMessages enumerateObjectsUsingBlock:^(YPBChatMessage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [copiedChatMessages addObject:obj.copy];
            
            XHMessage *message = [[XHMessage alloc] initWithText:obj.msg type:obj.msgType sender:obj.sendUserId timestamp:[YPBUtil dateFromString:obj.msgTime]];
            if ([obj.sendUserId isEqualToString:[YPBUser currentUser].userId]) {
                message.bubbleMessageType = XHBubbleMessageTypeSending;
            } else {
                message.bubbleMessageType = XHBubbleMessageTypeReceiving;
            }
            [messages addObject:message];
        }];
        
        self.chatMessages = copiedChatMessages;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.messages = messages;
            [self.messageTableView reloadData];
            
            if (completion) {
                completion();
            }
        });
    });
}

- (void)updateUnreadMessageInContact {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        if (self.chatMessages.count == 0) {
            return ;
        }
        
        YPBChatMessage *recentChatMessage = self.chatMessages.lastObject;
        YPBContact *contact = [YPBContact existingContactWithUserId:self.userId];
        [contact beginUpdate];
        
        if (![contact.recentTime isEqualToString:recentChatMessage.msgTime]
            || ![contact.recentMessage isEqualToString:recentChatMessage.msg]) {
            contact.recentTime = recentChatMessage.msgTime;
            contact.recentMessage = recentChatMessage.msg;
        }
        
        contact.unreadMessages = @(0);
        [contact endUpdate];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:kUnreadMessageChangeNotification object:nil];
        });
    });
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
    chatMessage.msgType = @(YPBChatMessageTypeWord);
    chatMessage.msg = message;
    chatMessage.msgTime = dateTime;
    [self addChatMessage:chatMessage];
    
    if ([sender isEqualToString:[YPBUser currentUser].userId] && self.userType != YPBUserTypeReal) {
        [[YPBAutoReplyMessagePool sharedPool] addChatMessageForReply:chatMessage];
    }
}

- (void)addChatMessage:(YPBChatMessage *)chatMessage {
    //先检查发送者是否是本人 若是本人 则检查接收者是否在黑名单中
    if ([chatMessage.sendUserId isEqualToString:[YPBUser currentUser].userId]) {
        if ([[YPBBlacklist sharedInstance] checkUserIdIsTure:chatMessage.receiveUserId]) {
            chatMessage.msg = @"";
            chatMessage.msgType = @(YPBChatMessageTypeSystemInfo);
        }
    }
    //再检查接受者是否是本人 若是本人  则检查发送者是否在黑名单中
    if ([chatMessage.receiveUserId isEqualToString:[YPBUser currentUser].userId]) {
        if ([[YPBBlacklist sharedInstance] checkUserIdIsTure:chatMessage.sendUserId]) {
            chatMessage.msg = @"";
            chatMessage.msgType = @(YPBChatMessageTypeSystemInfo);
        }
    }
    if (_chatMessages.count > 1) {
        YPBChatMessage *lastMessage = _chatMessages[_chatMessages.count-1];
        if (!([lastMessage.msgType isEqual: @(YPBChatMessageTypeSystemInfo)] && [chatMessage.msgType isEqual:@(YPBChatMessageTypeSystemInfo)])) {
            [chatMessage persist];
        }
    } else if (_chatMessages.count == 1) {
        [chatMessage persist];
    }
    
    [self.chatMessages addObject:chatMessage];
    
    if (self.isViewLoaded) {
        XHMessage *xhMsg = [[XHMessage alloc] initWithText:chatMessage.msg
                                                      type:chatMessage.msgType
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
    if ([YPBUtil isVIP]) {
        [self addTextMessage:text withSender:sender receiver:self.userId dateTime:[YPBUtil stringFromDate:date]];
        [[YPBMessagePushModel sharedModel] sendMsgToSeviceWithUserid:sender ReciverId:self.userId Message:text];
        [self finishSendMessageWithBubbleMessageType:XHBubbleMessageMediaTypeText];
    } else {
        YPBVIPPriviledgeViewController *vipVC = [[YPBVIPPriviledgeViewController alloc] initWithContentType:YPBPaymentContentTypeMessage];
        [self.navigationController pushViewController:vipVC animated:YES];
        [self.messageInputView.inputTextView resignFirstResponder];
    }
    
    [YPBStatistics logEvent:kLogUserChatEvent fromUser:[YPBUser currentUser].userId toUser:self.userId];
}

- (void)configBlacklistCell:(YPBBlacklistSystemInfoCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    YPBChatMessage *message = self.chatMessages[indexPath.row];
    if ([message.msgType isEqual:@(YPBChatMessageTypeSystemInfo)]) {
        UILabel *systemInfo = [[UILabel alloc] init];
        systemInfo.backgroundColor = [UIColor lightGrayColor];
        systemInfo.layer.masksToBounds = YES;
        systemInfo.font = [UIFont systemFontOfSize:14];
        systemInfo.textAlignment = NSTextAlignmentCenter;
        systemInfo.layer.cornerRadius = 5;
        systemInfo.numberOfLines = 0;
        systemInfo.text = [NSString stringWithFormat:@"%@已经被您拉黑,无法发起对话\n可在\"我--设置--黑名单\"中解除",self.nickName];
        [cell addSubview:systemInfo];
        {
            [systemInfo mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(cell.mas_left).offset(20);
                make.right.equalTo(cell.mas_right).offset(-20);
                make.top.equalTo(cell.mas_top).offset(5);
                make.bottom.equalTo(cell.mas_bottom).offset(-5);
                make.height.equalTo(@(20));
            }];
        }
    }
}


- (void)configureCell:(XHMessageTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    YPBChatMessage *message = self.chatMessages[indexPath.row];
    XHMessage *messagea = self.messages[indexPath.row];
    
    BOOL isCurrentUser = [messagea.sender isEqualToString:[YPBUser currentUser].userId];
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
        [cell.avatarButton bk_removeEventHandlersForControlEvents:UIControlEventTouchUpInside];
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
@end
