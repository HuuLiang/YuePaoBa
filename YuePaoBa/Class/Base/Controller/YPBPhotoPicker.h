//
//  YPBPhotoPicker.h
//  YuePaoBa
//
//  Created by Sean Yue on 16/1/5.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, YPBPhotoPickingSourceType) {
    YPBPhotoPickingSourceLibrary,
    YPBPhotoPickingSourceCamera
};

typedef NS_ENUM(NSUInteger, YPBPhotoPickingCameraDevice) {
    YPBPhotoPickingCameraDeviceRear,
    YPBPhotoPickingCameraDeviceFront
};

typedef void (^YPBPhotoPickingCompletionHandler)(BOOL success, NSArray<UIImage *> *originalImages, NSArray<UIImage *> *thumbImages);

@interface YPBPhotoPicker : NSObject

@property (nonatomic) BOOL multiplePicking;
@property (nonatomic) NSUInteger maximumNumberOfMultiplePicking;
@property (nonatomic) BOOL allowsEditing;
@property (nonatomic) YPBPhotoPickingCameraDevice cameraDevice;

- (void)showPickingSheetInViewController:(UIViewController *)viewController
                               withTitle:(NSString *)title
                       completionHandler:(YPBPhotoPickingCompletionHandler)handler;

- (void)pickingInViewController:(UIViewController *)viewController
                 withSourceType:(YPBPhotoPickingSourceType)sourceType
              completionHandler:(YPBPhotoPickingCompletionHandler)handler;

@end
