//
//  YPBPhotoGridViewController.h
//  YuePaoBa
//
//  Created by Sean Yue on 15/12/28.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import "YPBBaseViewController.h"

@interface YPBPhotoGridViewController : YPBBaseViewController

@property (nonatomic) NSArray<YPBUserPhoto *> *photos;

- (instancetype)initWithPhotos:(NSArray *)photosArray;

@end
