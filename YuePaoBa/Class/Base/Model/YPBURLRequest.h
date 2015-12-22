//
//  YPBURLRequest.h
//  kuaibov
//
//  Created by Sean Yue on 15/9/3.
//  Copyright (c) 2015年 kuaibov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YPBURLResponse.h"

typedef NS_ENUM(NSUInteger, YPBURLResponseStatus) {
    YPBURLResponseSuccess,
    YPBURLResponseFailedByInterface,
    YPBURLResponseFailedByNetwork,
    YPBURLResponseFailedByParsing,
    YPBURLResponseFailedByParameter,
    YPBURLResponseNone
};

typedef NS_ENUM(NSUInteger, YPBURLRequestMethod) {
    YPBURLGetRequest,
    YPBURLPostRequest
};
typedef void (^YPBURLResponseHandler)(YPBURLResponseStatus respStatus, NSString *errorMessage);

@interface YPBURLRequest : NSObject

@property (nonatomic,retain) id response;

+ (Class)responseClass;  // override this method to provide a custom class to be used when instantiating instances of YPBURLResponse
+ (BOOL)shouldPersistURLResponse;
- (NSURL *)baseURL; // override this method to provide a custom base URL to be used
//- (NSURL *)standbyBaseURL; // override this method to provide a custom standby base URL to be used

- (BOOL)shouldPostErrorNotification;
- (YPBURLRequestMethod)requestMethod;

- (BOOL)requestURLPath:(NSString *)urlPath withParams:(NSDictionary *)params responseHandler:(YPBURLResponseHandler)responseHandler;

- (BOOL)requestURLPath:(NSString *)urlPath standbyURLPath:(NSString *)standbyUrlPath withParams:(NSDictionary *)params responseHandler:(YPBURLResponseHandler)responseHandler;

// For subclass pre/post processing response object
- (void)processResponseObject:(id)responseObject withResponseHandler:(YPBURLResponseHandler)responseHandler;

@end
