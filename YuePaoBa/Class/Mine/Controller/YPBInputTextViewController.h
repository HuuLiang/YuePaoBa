//
//  YPBInputTextViewController.h
//  YuePaoBa
//
//  Created by Sean Yue on 15/12/24.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import "YPBBaseViewController.h"

typedef BOOL (^YPBInputTextCompletionHandler)(NSString *text);
typedef BOOL (^YPBInputTextChangeHandler)(NSString *text);

@interface YPBInputTextViewController : YPBBaseViewController

@property (nonatomic,readonly) BOOL isTextBlock;
@property (nonatomic) NSUInteger limitedTextLength;
@property (nonatomic) NSString *placeholder;
@property (nonatomic) NSString *text;
@property (nonatomic) NSString *note;

@property (nonatomic,copy) YPBInputTextCompletionHandler completionHandler;
@property (nonatomic,copy) YPBInputTextChangeHandler changeHandler;

- (instancetype)initWithTextBlock:(BOOL)isTextBlock;

@end
