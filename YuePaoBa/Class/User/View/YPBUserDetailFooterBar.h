//
//  YPBUserDetailFooterBar.h
//  YuePaoBa
//
//  Created by Sean Yue on 16/3/10.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YPBUserDetailFooterBar : UIView

@property (nonatomic) BOOL isGreet;
@property (nonatomic) NSUInteger numberOfGreets;

@property (nonatomic,copy) YPBAction greetAction;
@property (nonatomic,copy) YPBAction giftAction;
@property (nonatomic,copy) YPBAction dateAction;

@end
