//
//  YPBVIPPayView.h
//  YuePaoBa
//
//  Created by Liang on 16/7/16.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^payWithInfo)(NSUInteger price ,NSUInteger months);

@interface YPBVIPPayView : UIView

@property (nonatomic) payWithInfo payWithInfoBlock;

@end
