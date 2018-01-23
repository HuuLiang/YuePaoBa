//
//  YPBVideoTitleView.h
//  YuePaoBa
//
//  Created by Sean Yue on 16/2/27.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YPBVideoTitleView : UIView

@property (nonatomic) NSURL *avatarUrl;
@property (nonatomic) NSString *detail;

- (instancetype)initWithAvatarUrl:(NSURL *)avatarUrl detail:(NSString *)detail;

@end
