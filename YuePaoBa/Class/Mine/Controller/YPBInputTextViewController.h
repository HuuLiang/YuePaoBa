//
//  YPBInputTextViewController.h
//  YuePaoBa
//
//  Created by Sean Yue on 15/12/24.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import "YPBBaseViewController.h"

typedef BOOL (^YPBInputTextCompletionHandler)(id sender, NSString *text);
typedef BOOL (^YPBInputTextChangeHandler)(id sender, NSString *text);

@interface YPBInputTextViewController : YPBBaseViewController

@property (nonatomic,readonly) BOOL isTextBlock;
@property (nonatomic) NSUInteger limitedTextLength;
@property (nonatomic) NSString *placeholder;
@property (nonatomic) NSString *text;
@property (nonatomic) NSString *note;
@property (nonatomic) NSString *completeButtonTitle;

@property (nonatomic,copy) YPBInputTextCompletionHandler completionHandler;
@property (nonatomic,copy) YPBInputTextChangeHandler changeHandler;

- (instancetype)initWithTextBlock:(BOOL)isTextBlock;

@end
