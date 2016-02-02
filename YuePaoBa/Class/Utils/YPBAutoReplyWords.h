//
//  YPBAutoReplyWords.h
//  YuePaoBa
//
//  Created by Sean Yue on 16/2/1.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YPBAutoReplyWords : NSObject

@property (nonatomic,retain) NSArray<NSString *> *words;

+ (instancetype)sharedInstance;
- (NSString *)randomWord;
- (NSString *)randomWordExcludeWords:(NSArray<NSString *> *)excludedWords;

@end
