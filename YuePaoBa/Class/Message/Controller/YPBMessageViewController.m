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

static const void *kMessageCellBottomLabelAssociatedKey = &kMessageCellBottomLabelAssociatedKey;

@interface YPBMessageViewController ()
{

}
@property (nonatomic,readonly) NSString *userId;
@property (nonatomic,readonly) NSString *logoUrl;
@property (nonatomic,readonly) NSString *nickName;

@property (nonatomic,retain) NSMutableArray<YPBChatMessage *> *chatMessages;
@end

@implementation YPBMessageViewController

DefineLazyPropertyInitialization(NSMutableArray, chatMessages)

+ (instancetype)showMessageWithUser:(YPBUser *)user inViewController:(UIViewController *)viewController {
    YPBMessageViewController *messageVC = [[self alloc] initWithUser:user];
    [viewController.navigationController pushViewController:messageVC animated:YES];
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

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.messageTableView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
    self.title = self.user ? self.user.nickName : self.contact.nickName;
    self.messageSender = [YPBUser currentUser].userId;

}

- (void)reloadChatMessages {
    self.chatMessages = [YPBChatMessage allMessagesForUser:self.userId].mutableCopy;
    
    NSMutableArray<XHMessage *> *messages = [NSMutableArray array];
    [self.chatMessages enumerateObjectsUsingBlock:^(YPBChatMessage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        XHMessage *message = [[XHMessage alloc] initWithText:obj.msg sender:obj.sendUserId timestamp:[YPBUtil dateFromString:obj.msgTime]];
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
    
    YPBContact *contact = [YPBContact existingContactWithUserId:self.userId];
    [contact beginUpdate];
    contact.unreadMessages = @(0);
    [contact endUpdate];
    
    if ([YPBVIPEntranceView VIPEntranceInView:self.view]) {
        return ;
    }
    
    YPBChatMessage *lastMessage = self.chatMessages.lastObject;
    if (lastMessage.msgType.unsignedIntegerValue == YPBChatMessageTypeOption) {
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
    if ([contact.recentTime isEqualToString:recentChatMessage.msgTime]
        && [contact.recentMessage isEqualToString:recentChatMessage.msg]) {
        return ;
    }
    
    [contact beginUpdate];
    contact.recentTime = recentChatMessage.msgTime;
    contact.recentMessage = recentChatMessage.msg;
    [contact endUpdate];
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
        return [msg.receiveUserId isEqualToString:self.userId];
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
}

- (void)addChatMessage:(YPBChatMessage *)chatMessage {
    [chatMessage persist];
    [self.chatMessages addObject:chatMessage];
    
    if (self.isViewLoaded) {
        XHMessage *xhMsg = [[XHMessage alloc] initWithText:chatMessage.msg
                                                    sender:chatMessage.sendUserId
                                                 timestamp:[YPBUtil dateFromString:chatMessage.msgTime]];
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
        [self finishSendMessageWithBubbleMessageType:XHBubbleMessageMediaTypeText];
    } else {
        [YPBVIPEntranceView showVIPEntranceInView:self.view canClose:YES withEnterAction:^(id obj) {
            YPBVIPPriviledgeViewController *vipVC = [[YPBVIPPriviledgeViewController alloc] init];
            [self.navigationController pushViewController:vipVC animated:YES];
        }];
        
        [self.messageInputView.inputTextView resignFirstResponder];
    }
}

- (void)configureCell:(XHMessageTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    XHMessage *message = self.messages[indexPath.row];
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
