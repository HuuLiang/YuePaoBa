//
//  YPBProfileActionButton.h
//  YuePaoBa
//
//  Created by Sean Yue on 15/12/17.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^YPBProfileButtonAction)(id sender);

@interface YPBProfileActionButton : UIButton

@property (nonatomic,copy) YPBProfileButtonAction action;

- (instancetype)initWithImage:(UIImage *)image title:(NSString *)title action:(YPBProfileButtonAction)action;

@end
