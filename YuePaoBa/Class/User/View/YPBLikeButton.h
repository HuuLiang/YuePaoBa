//
//  YPBLikeButton.h
//  YuePaoBa
//
//  Created by Sean Yue on 16/1/5.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YPBLikeButton : UIButton

@property (nonatomic) NSUInteger numberOfLikes;

- (instancetype)initWithUserInteractionEnabled:(BOOL)enabled;

@end
