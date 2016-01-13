//
//  YPBPhotoPicker.m
//  YuePaoBa
//
//  Created by Sean Yue on 16/1/5.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "YPBPhotoPicker.h"
#import "QBImagePickerController.h"

@interface YPBPhotoPicker () <UIImagePickerControllerDelegate,UINavigationControllerDelegate,QBImagePickerControllerDelegate>
@property (nonatomic,retain) UIImagePickerController *imagePicker;
@property (nonatomic,retain) QBImagePickerController *qbImagePicker;

@property (nonatomic,copy) YPBPhotoPickingCompletionHandler completionHandler;
@end

@implementation YPBPhotoPicker

- (UIImagePickerController *)imagePicker {
    if (_imagePicker) {
        return _imagePicker;
    }
    
    _imagePicker = [[UIImagePickerController alloc] init];
    _imagePicker.view.backgroundColor = [UIColor whiteColor];
    _imagePicker.delegate = self;
    return _imagePicker;
}

- (QBImagePickerController *)qbImagePicker {
    if (_qbImagePicker) {
        return _qbImagePicker;
    }
    
    _qbImagePicker = [[QBImagePickerController alloc] init];
    _qbImagePicker.delegate = self;
    _qbImagePicker.filterType = QBImagePickerControllerFilterTypePhotos;
    return _qbImagePicker;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)dealloc {
    DLog(@"YPBPhotoPicker dealloc");
}

- (YPBPhotoPickingSourceType)sourceTypeFromRawType:(UIImagePickerControllerSourceType)rawType {
    if (rawType == UIImagePickerControllerSourceTypeCamera) {
        return YPBPhotoPickingSourceCamera;
    } else {
        return YPBPhotoPickingSourceLibrary;
    }
}

- (UIImagePickerControllerSourceType)rawTypeFromSourceType:(YPBPhotoPickingSourceType)sourceType {
    if (sourceType == YPBPhotoPickingSourceCamera) {
        return UIImagePickerControllerSourceTypeCamera;
    } else {
        return UIImagePickerControllerSourceTypePhotoLibrary;
    }
}

- (void)showPickingSheetInViewController:(UIViewController *)viewController
                               withTitle:(NSString *)title
                   completionHandler:(YPBPhotoPickingCompletionHandler)handler
{
    self.completionHandler = handler;
    
    @weakify(self);
    UIActionSheet *actionSheet = [[UIActionSheet alloc] bk_initWithTitle:title];
    [actionSheet bk_addButtonWithTitle:@"从相册中选取" handler:^{
        @strongify(self);
        [self pickingInViewController:viewController withSourceType:YPBPhotoPickingSourceLibrary completionHandler:handler];
    }];
    
    [actionSheet bk_addButtonWithTitle:@"拍照" handler:^{
        @strongify(self);
        [self pickingInViewController:viewController withSourceType:YPBPhotoPickingSourceCamera completionHandler:handler];
    }];
    [actionSheet bk_setDestructiveButtonWithTitle:@"取消" handler:^{
        SafelyCallBlock3(self.completionHandler, NO, nil, nil);
        self.completionHandler = nil;
    }];
    [actionSheet showInView:viewController.view];
}

- (void)pickingInViewController:(UIViewController *)viewController
                 withSourceType:(YPBPhotoPickingSourceType)sourceType
              completionHandler:(YPBPhotoPickingCompletionHandler)handler
{
    
    if (sourceType == YPBPhotoPickingSourceCamera) {
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            DLog(@"Image Picker Source Type: Camera is unavailable!");
            return ;
        }
        
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        self.imagePicker.cameraDevice = self.cameraDevice==YPBPhotoPickingCameraDeviceFront?UIImagePickerControllerCameraDeviceFront:UIImagePickerControllerCameraDeviceRear;
        self.imagePicker.cameraFlashMode = UIImagePickerControllerCameraFlashModeOff;
        self.imagePicker.allowsEditing = self.allowsEditing;
        
        [viewController presentViewController:self.imagePicker animated:YES completion:nil];
    } else if (sourceType == YPBPhotoPickingSourceLibrary) {
        self.qbImagePicker.allowsMultipleSelection = self.multiplePicking;
        self.qbImagePicker.maximumNumberOfSelection = self.maximumNumberOfMultiplePicking;

        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:self.qbImagePicker];
        [viewController presentViewController:nav animated:YES completion:nil];
    }
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    @weakify(self);
    UIImage *pickedImage;
    if (picker.allowsEditing) {
        pickedImage = [info objectForKey:UIImagePickerControllerEditedImage];
    } else {
        pickedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
    [assetsLibrary writeImageToSavedPhotosAlbum:[pickedImage CGImage]
                                    orientation:(ALAssetOrientation)pickedImage.imageOrientation
                                completionBlock:^(NSURL *assetURL, NSError *error)
    {
        [assetsLibrary assetForURL:assetURL resultBlock:^(ALAsset *asset) {
            @strongify(self);
            UIImage *originalImage = [UIImage imageWithCGImage:asset.defaultRepresentation.fullResolutionImage
                                                         scale:asset.defaultRepresentation.scale
                                                   orientation:pickedImage.imageOrientation];
            UIImage *thumbImage = [UIImage imageWithCGImage:asset.thumbnail];
            SafelyCallBlock3(self.completionHandler, YES, @[originalImage], @[thumbImage]);
            self.completionHandler = nil;
        } failureBlock:^(NSError *error) {
            @strongify(self);
            SafelyCallBlock3(self.completionHandler, NO, nil, nil);
            self.completionHandler = nil;
        }];
    }];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    SafelyCallBlock3(self.completionHandler, NO, nil, nil);
    self.completionHandler = nil;
}

#pragma mark - QBImagePickerControllerDelegate

- (void)qb_imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController {
    [imagePickerController dismissViewControllerAnimated:YES completion:nil];
    
    SafelyCallBlock3(self.completionHandler, NO, nil, nil);
    self.completionHandler = nil;
}

- (void)qb_imagePickerController:(QBImagePickerController *)imagePickerController didSelectAssets:(NSArray *)assets {
    [imagePickerController dismissViewControllerAnimated:YES completion:nil];
    
    NSMutableArray<UIImage *> *originalImages = [NSMutableArray array];
    NSMutableArray<UIImage *> *thumbImages = [NSMutableArray array];
    [assets enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ALAsset *asset = obj;
        UIImage *originalImage = [UIImage imageWithCGImage:asset.defaultRepresentation.fullResolutionImage];
        UIImage *thumbImage = [UIImage imageWithCGImage:asset.thumbnail];
        [originalImages addObject:originalImage];
        [thumbImages addObject:thumbImage];
    }];
    
    if (originalImages.count == 0 || thumbImages.count == 0 || originalImages.count != thumbImages.count) {
        SafelyCallBlock3(self.completionHandler, NO, nil, nil);
    } else {
        SafelyCallBlock3(self.completionHandler, YES, originalImages, thumbImages);
    }
    
    self.completionHandler = nil;
}

- (void)qb_imagePickerController:(QBImagePickerController *)imagePickerController didSelectAsset:(ALAsset *)asset {
    [imagePickerController dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *originalImage = [UIImage imageWithCGImage:asset.defaultRepresentation.fullResolutionImage];
    UIImage *thumbImage = [UIImage imageWithCGImage:asset.thumbnail];
    if (originalImage && thumbImage) {
        SafelyCallBlock3(self.completionHandler, YES, @[originalImage], @[thumbImage]);
    } else {
        SafelyCallBlock3(self.completionHandler, NO, nil, nil);
    }
    self.completionHandler = nil;
}
@end
