//
//  YPBWeChatURLRequest.m
//  YuePaoBa
//
//  Created by Liang on 16/5/26.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "YPBWeChatURLRequest.h"

@implementation YPBWeChatURLRequest

- (BOOL)requestWeChatAccessTokenWithInfo:(NSString *)code responseHandler:(YPBWeChatURLResponseHandler)handler {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@appid=%@&secret=%@&code=%@&grant_type=authorization_code",YPB_WECHAT_TOKEN,[YPBSystemConfig sharedConfig].weixinInfo.appId,YPB_WECHAT_SECRET,code];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:urlStr
      parameters:nil
         success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
             NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
             handler(dic,nil);
         }
         failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
             handler(nil,error);
         }];
    return YES;
}

- (BOOL)requesWeChatUserInfoWithTokenDic:(NSDictionary *)dic responseHandler:(YPBWeChatURLResponseHandler)handler{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@access_token=%@&openid=%@&lang=%@",YPB_WECHAT_USERINFO,dic[@"access_token"],dic[@"openid"],@"zh_CN"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:urlStr
      parameters:nil
         success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
             NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
             handler(dic,nil);
         }
         failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
             handler(nil,error);
         }];
    return YES;
}

@end
