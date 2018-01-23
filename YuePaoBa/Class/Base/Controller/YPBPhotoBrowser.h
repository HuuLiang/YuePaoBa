//
//  YPBPhotoBrowser.h
//  YuePaoBa
//
//  Created by Sean Yue on 15/12/28.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import "YPBBaseViewController.h"

typedef void (^YPBPhotoBrowserDisplayAction)(NSUInteger index);
typedef BOOL (^YPBPhotoBrowserShouldLockAction)(NSUInteger index);

@interface YPBPhotoBrowser : YPBBaseViewController

@property (nonatomic,retain,readonly) NSArray<YPBUserPhoto *> *photos;
@property (nonatomic) NSUInteger currentPhotoIndex;
@property (nonatomic,copy) YPBPhotoBrowserDisplayAction displayAction;
@property (nonatomic,copy) YPBPhotoBrowserShouldLockAction shouldLockAction;
@property (nonatomic,copy) YPBAction tapLockAction;
@property (nonatomic) BOOL hideOnTap;
@property (nonatomic,copy) YPBAction tapPhotoAction;

+ (instancetype)showPhotoBrowserInView:(UIView *)view withPhotos:(NSArray *)photos currentPhotoIndex:(NSUInteger)index;
+ (instancetype)showingPhotoBrowser;

- (instancetype)initWithUserPhotos:(NSArray *)userPhotos;

- (void)showInView:(UIView *)view;
- (void)hide;

@end
