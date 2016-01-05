//
//  YPBChatMessage.m
//  YuePaoBa
//
//  Created by Sean Yue on 16/1/4.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "YPBChatMessage.h"

@implementation YPBChatMessage

- (NSString *)namespace {
    return [NSString stringWithFormat:@"%@_%@_chat", self.sendUserId, self.receiveUserId];
}
@end
