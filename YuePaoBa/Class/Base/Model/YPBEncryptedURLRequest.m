//
//  YPBEncryptedURLRequest.m
//  kuaibov
//
//  Created by Sean Yue on 15/9/14.
//  Copyright (c) 2015年 kuaibov. All rights reserved.
//

#import "YPBEncryptedURLRequest.h"
#import "NSDictionary+YPBSign.h"
#import "NSString+crypt.h"

static NSString *const kSignKey = @"qdge^%$#@(sdwHs^&";
static NSString *const kEncryptionPassword = @"wdnxs&*@#!*qb)*&qiang";

@implementation YPBEncryptedURLRequest

+ (NSDictionary *)commonParams {
    return @{@"appId":YPB_REST_APPID,
             kEncryptionKeyName:kSignKey,
             @"imsi":@"999999999999999",
             @"channelNo":YPB_CHANNEL_NO,
             @"pV":@(1)
             };
}

+ (NSArray *)keyOrdersOfCommonParams {
    return @[@"appId",kEncryptionKeyName,@"imsi",@"channelNo",@"pV"];
}

- (YPBURLRequestMethod)requestMethod {
    return YPBURLPostRequest;
}

- (NSDictionary *)encryptWithParams:(NSDictionary *)params {
    NSDictionary *signParams = @{  @"appId":YPB_REST_APPID,
                                   @"key":kSignKey,
                                   @"imsi":@"999999999999999",
                                   @"channelNo":YPB_CHANNEL_NO,
                                   @"pV":YPB_REST_PV};
    
    NSString *sign = [signParams signWithDictionary:[self class].commonParams keyOrders:[self class].keyOrdersOfCommonParams];
    if (!params) {
        params = [NSDictionary dictionary];
    }
    NSString *encryptedDataString = [params encryptedStringWithSign:sign password:kEncryptionPassword excludeKeys:@[@"key"]];
    return @{@"data":encryptedDataString, @"appId":YPB_REST_APPID};
}
//- (NSDictionary *)encryptWithParams:(NSDictionary *)params {
//    NSMutableDictionary *mergedParams = params ? params.mutableCopy : [NSMutableDictionary dictionary];
//    NSDictionary *commonParams = [[self class] commonParams];
//    if (commonParams) {
//        [mergedParams addEntriesFromDictionary:commonParams];
//    }
//    
//    return [mergedParams encryptedDictionarySignedTogetherWithDictionary:commonParams keyOrders:[[self class] keyOrdersOfCommonParams] passwordKeyName:kEncryptionKeyName];
//}

- (BOOL)requestURLPath:(NSString *)urlPath withParams:(NSDictionary *)params responseHandler:(YPBURLResponseHandler)responseHandler {
    return [self requestURLPath:urlPath standbyURLPath:nil withParams:params responseHandler:responseHandler];
}

- (BOOL)requestURLPath:(NSString *)urlPath standbyURLPath:(NSString *)standbyUrlPath withParams:(NSDictionary *)params responseHandler:(YPBURLResponseHandler)responseHandler {
    return [super requestURLPath:urlPath standbyURLPath:standbyUrlPath withParams:[self encryptWithParams:params] responseHandler:responseHandler];
}

- (id)decryptResponse:(id)encryptedResponse {
    if (![encryptedResponse isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    NSDictionary *originalResponse = (NSDictionary *)encryptedResponse;
    NSArray *keys = [originalResponse objectForKey:kEncryptionKeyName];
    NSString *dataString = [originalResponse objectForKey:kEncryptionDataName];
    if (!keys || !dataString) {
        return nil;
    }
    
    NSString *decryptedString = [dataString decryptedStringWithKeys:keys];
    id jsonObject = [NSJSONSerialization JSONObjectWithData:[decryptedString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
    if (jsonObject == nil) {
        jsonObject = decryptedString;
    }
    return jsonObject;
}

- (void)processResponseObject:(id)responseObject withResponseHandler:(YPBURLResponseHandler)responseHandler {

    if (![responseObject isKindOfClass:[NSDictionary class]]) {
        [super processResponseObject:nil withResponseHandler:responseHandler];
        return ;
    }
    
    id decryptedResponse = [self decryptResponse:responseObject];
    DLog(@"Decrypted response: %@", decryptedResponse);
    [super processResponseObject:decryptedResponse withResponseHandler:responseHandler];
}
@end
