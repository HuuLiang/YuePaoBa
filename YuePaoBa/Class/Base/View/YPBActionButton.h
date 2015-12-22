//
//  YPBActionButton.h
//  YuePaoBa
//
//  Created by Sean Yue on 15/12/12.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^YPBButtonAction)(id sender);

@interface YPBActionButton : UIButton

- (instancetype)initWithTitle:(NSString *)title action:(YPBButtonAction)action;

@end
