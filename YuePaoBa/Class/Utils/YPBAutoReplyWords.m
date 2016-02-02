//
//  YPBAutoReplyWords.m
//  YuePaoBa
//
//  Created by Sean Yue on 16/2/1.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "YPBAutoReplyWords.h"

@implementation YPBAutoReplyWords

+ (instancetype)sharedInstance {
    static YPBAutoReplyWords *_sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[YPBAutoReplyWords alloc] init];
        
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"AutoReplyWords" ofType:@"plist"];
        _sharedInstance.words = [NSArray arrayWithContentsOfFile:plistPath];
    });
    return _sharedInstance;
}

- (NSString *)randomWord {
    if (self.words.count == 0) {
        return nil;
    }
    
    return [self.words objectAtIndex:arc4random_uniform((uint32_t)(self.words.count-1))];
}

- (NSString *)randomWordExcludeWords:(NSArray<NSString *> *)excludedWords {
    NSMutableArray *replyWords = [self.words mutableCopy];
    [replyWords removeObjectsInArray:excludedWords];
    if (replyWords.count == 0) {
        return nil;
    }
    
    return [replyWords objectAtIndex:arc4random_uniform((uint32_t)(replyWords.count-1))];
}
@end
