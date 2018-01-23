//
//  YPBWeChatURLRequest.h
//  YuePaoBa
//
//  Created by Liang on 16/5/26.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

typedef void (^YPBWeChatURLResponseHandler)(id, NSError *);

@interface YPBWeChatURLRequest : NSObject

- (BOOL)requestWeChatAccessTokenWithInfo:(NSString *)code responseHandler:(YPBWeChatURLResponseHandler)handler;

- (BOOL)requesWeChatUserInfoWithTokenDic:(NSDictionary *)dic responseHandler:(YPBWeChatURLResponseHandler)handler;

@end
