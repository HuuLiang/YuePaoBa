//
//  YPBWeChatPayQueryOrderRequest.m
//  kuaibov
//
//  Created by Sean Yue on 15/11/23.
//  Copyright © 2015年 kuaibov. All rights reserved.
//

#import "YPBWeChatPayQueryOrderRequest.h"
#import "payRequsestHandler.h"
#import "WXUtil.h"
#import "YPBSystemConfig.h"

static NSString *const kWeChatPayQueryOrderUrlString = @"https://api.mch.weixin.qq.com/pay/orderquery";
static NSString *const kSuccessString = @"SUCCESS";

@implementation YPBWeChatPayQueryOrderRequest

- (BOOL)queryOrderWithNo:(NSString *)orderNo completionHandler:(YPBWeChatPayQueryOrderCompletionHandler)handler {
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        srand( (unsigned)time(0) );
        NSString *noncestr  = [NSString stringWithFormat:@"%d", rand()];
        
        NSMutableDictionary *params = @{@"appid":[YPBSystemConfig sharedConfig].weixinInfo.appId,
                                        @"mch_id":[YPBSystemConfig sharedConfig].weixinInfo.mchId,
                                        @"out_trade_no":orderNo,
                                        @"nonce_str":noncestr}.mutableCopy;
        //创建支付签名对象
        payRequsestHandler *req = [[payRequsestHandler alloc] init];

        NSString *package = [req genPackage:params];
        NSData *data =[WXUtil httpSend:kWeChatPayQueryOrderUrlString method:@"POST" data:package];
        
        XMLHelper *xml  = [[XMLHelper alloc] init];
        
        //开始解析
        [xml startParse:data];
        
        NSMutableDictionary *resParams = [xml getDict];
        self.return_code = resParams[@"return_code"];
        self.result_code = resParams[@"result_code"];
        self.trade_state = resParams[@"trade_state"];
        self.total_fee = ((NSString *)resParams[@"total_fee"]).integerValue / 100;
        
        if (handler) {
            dispatch_async(dispatch_get_main_queue(), ^{
                handler([self.return_code isEqualToString:kSuccessString] && [self.result_code isEqualToString:kSuccessString], self.trade_state, self.total_fee);
            });
        }
    });
    
    return YES;
}
@end
