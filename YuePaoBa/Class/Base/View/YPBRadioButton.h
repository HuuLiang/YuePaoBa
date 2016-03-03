//
//  YPBRadioButton.h
//  YuePaoBa
//
//  Created by Sean Yue on 15/12/12.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YPBRadioButtonGroup;

typedef CGRect (^YPBButtonLayoutBlock)(CGRect contentRect);

@interface YPBRadioButton : UIButton

@property (nonatomic) NSString *title;
@property (nonatomic,weak) YPBRadioButtonGroup *group;
@property (nonatomic,copy) YPBButtonLayoutBlock imageRectBlock;
@property (nonatomic,copy) YPBButtonLayoutBlock titleRectBlock;

@end
