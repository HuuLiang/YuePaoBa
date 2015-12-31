//
//  YPBPhotoBrowser.h
//  YuePaoBa
//
//  Created by Sean Yue on 15/12/28.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import "YPBBaseViewController.h"

@interface YPBPhotoBrowser : YPBBaseViewController

+ (instancetype)showPhotoBrowserInView:(UIView *)view withPhotos:(NSArray *)photos currentPhotoIndex:(NSUInteger)index;

- (instancetype)initWithUserPhotos:(NSArray *)userPhotos;
- (void)setCurrentPhotoIndex:(NSUInteger)photoIndex;

- (void)showInView:(UIView *)view;
- (void)hide;

@end
