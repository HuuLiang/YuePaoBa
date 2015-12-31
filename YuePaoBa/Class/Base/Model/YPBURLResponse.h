//
//  YPBURLResponse.h
//  kuaibov
//
//  Created by Sean Yue on 15/9/3.
//  Copyright (c) 2015年 kuaibov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YPBPaginator.h"

extern const NSUInteger kSuccessResponseCode;

@interface YPBURLResponseCode : NSObject
@property (nonatomic) NSNumber *value;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *message;
@end

@interface YPBURLResponse : NSObject

@property (nonatomic) YPBURLResponseCode *code;
@property (nonatomic,retain) YPBPaginator *paginator;

- (void)parseResponseWithDictionary:(NSDictionary *)dic;
- (BOOL)success;
- (NSString *)message;

- (NSUInteger)nextPage;

@end
