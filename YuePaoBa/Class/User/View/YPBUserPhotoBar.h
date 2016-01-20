//
//  YPBUserPhotoBar.h
//  YuePaoBa
//
//  Created by Sean Yue on 15/12/24.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^YPBPhotoBarAction)(NSUInteger index);

@interface YPBUserPhotoBar : UIScrollView

@property (nonatomic) BOOL usePhotoAddItem;
@property (nonatomic,retain) NSArray<NSString *> *imageURLStrings;
@property (nonatomic,copy) YPBPhotoBarAction selectAction;
@property (nonatomic,copy) YPBPhotoBarAction holdAction;
@property (nonatomic,copy) YPBAction photoAddAction;

- (instancetype)initWithUsePhotoAddItem:(BOOL)usePhotoAddItem;

@end
