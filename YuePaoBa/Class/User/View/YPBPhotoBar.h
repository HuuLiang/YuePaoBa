//
//  YPBPhotoBar.h
//  YuePaoBa
//
//  Created by Sean Yue on 15/12/24.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^YPBPhotoBarAction)(NSUInteger index, id sender);
typedef BOOL (^YPBLockAction)(NSUInteger index);

@interface YPBPhotoBar : UIScrollView

@property (nonatomic) BOOL usePhotoAddItem;
@property (nonatomic) NSString *placeholder;
@property (nonatomic,retain,readonly) NSArray<NSString *> *imageURLStrings;
@property (nonatomic,retain,readonly) NSArray<NSString *> *titleStrings;
@property (nonatomic,copy) YPBPhotoBarAction selectAction;
@property (nonatomic,copy) YPBPhotoBarAction holdAction;
@property (nonatomic,copy) YPBAction photoAddAction;
@property (nonatomic,copy) YPBLockAction shouldLockAction;

- (instancetype)initWithUsePhotoAddItem:(BOOL)usePhotoAddItem;
- (BOOL)photoIsLocked:(NSUInteger)index;
- (void)setImageURLStrings:(NSArray<NSString *> *)imageURLStrings titleStrings:(NSArray<NSString *> *)titleStrings;

@end
