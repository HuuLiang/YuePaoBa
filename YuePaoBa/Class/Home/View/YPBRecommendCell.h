//
//  YPBRecommendCell.h
//  YuePaoBa
//
//  Created by Liang on 16/5/13.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YPBRecommendCell : UICollectionViewCell

@property (nonatomic,retain) YPBUser *user;
@property (nonatomic)UIButton *btn;
- (void)setBtnState;

@end
