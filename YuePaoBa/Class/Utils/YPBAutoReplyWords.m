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
        if ([[YPBUser currentUser].sex isEqualToString:@"F"]) {
            _sharedInstance.words = [NSDictionary dictionaryWithContentsOfFile:plistPath][@"man"];
        } else {
            _sharedInstance.words = [NSDictionary dictionaryWithContentsOfFile:plistPath][[self isBetweenFromHour:7 toHour:23] ? @"day":@"night"];
        }
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

+ (BOOL)isBetweenFromHour:(NSInteger)fromHour toHour:(NSInteger)toHour
{
    NSDate *date8 = [self getCustomDateWithHour:8];
    NSDate *date23 = [self getCustomDateWithHour:23];
    
    NSDate *currentDate = [NSDate date];
    
    if ([currentDate compare:date8]==NSOrderedDescending && [currentDate compare:date23]==NSOrderedAscending)
    {
        NSLog(@"该时间在 %ld:00-%ld:00 之间！",fromHour,toHour);
        return YES;
    }
    return NO;
}

+ (NSDate *)getCustomDateWithHour:(NSInteger)hour
{
    //获取当前时间
    NSDate *currentDate = [NSDate date];
    NSCalendar *currentCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *currentComps = [[NSDateComponents alloc] init];
    
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    
    currentComps = [currentCalendar components:unitFlags fromDate:currentDate];
    
    //设置当天的某个点
    NSDateComponents *resultComps = [[NSDateComponents alloc] init];
    [resultComps setYear:[currentComps year]];
    [resultComps setMonth:[currentComps month]];
    [resultComps setDay:[currentComps day]];
    [resultComps setHour:hour];
    
    NSCalendar *resultCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    return [resultCalendar dateFromComponents:resultComps];
}

@end
