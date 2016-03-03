//
//  YPBPhotoBarItemView.h
//  YuePaoBa
//
//  Created by Sean Yue on 16/2/23.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YPBPhotoBarItemView : UIView

@property (nonatomic,retain) UIImage *image;
@property (nonatomic) NSString *imageUrlString;
@property (nonatomic) NSString *title;
@property (nonatomic) BOOL isLocked;

@property (nonatomic,retain,readonly) UIImageView *imageView;
@property (nonatomic,retain,readonly) UILabel *titleLabel;

- (instancetype)initWithImage:(UIImage *)image title:(NSString *)title;
- (instancetype)initWithImageUrlString:(NSString *)imageUrlString title:(NSString *)title;
- (CGFloat)viewWidthRelativeToViewHeight:(CGFloat)height;

@end
