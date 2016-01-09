//
//  YPBPushedMessage.h
//  YuePaoBa
//
//  Created by Sean Yue on 16/1/7.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YPBPushedMessage : NSObject

@property (nonatomic) NSNumber *id;
@property (nonatomic) NSString *userId;
@property (nonatomic) NSString *logoUrl;
@property (nonatomic) NSString *nickName;
@property (nonatomic) NSString *proDesc;
@property (nonatomic) NSString *options;

@property (nonatomic) NSString *msgTime;

@end
