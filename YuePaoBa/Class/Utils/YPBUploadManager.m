//
//  YPBUploadManager.m
//  YuePaoBa
//
//  Created by Sean Yue on 15/12/31.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import "YPBUploadManager.h"
#import "QiniuToken.h"
#import "QiniuUploader.h"

@implementation YPBUploadManager

+ (void)registerWithSecretKey:(NSString *)secretKey accessKey:(NSString *)accessKey scope:(NSString *)scope {
    [QiniuToken registerWithScope:scope SecretKey:secretKey Accesskey:accessKey];
}

+ (BOOL)uploadImage:(UIImage *)image
           withName:(NSString *)name
    progressHandler:(YPBProgressHandler)progressHandler
  completionHandler:(YPBCompletionHandler)handler
{
    return [self uploadImages:@[image] withNames:@[name] progressHandler:progressHandler completionHandler:^(NSArray *success, NSArray *failure) {
        BOOL ret = success.count == 1;
        SafelyCallBlock2(handler, ret, ret?name:nil);
    }];
//    QiniuUploader *uploader = [[QiniuUploader alloc] init];
//    uploader.uploadOneFileSucceeded = ^(AFHTTPRequestOperation *operation, NSInteger index, NSString *key) {
//        SafelyCallBlock2(handler, YES, key);
//    };
//    uploader.uploadOneFileFailed = ^(AFHTTPRequestOperation *operation, NSInteger index, NSDictionary *error) {
//        SafelyCallBlock2(handler, NO, error);
//    };
//    uploader.uploadOneFileProgress = ^(AFHTTPRequestOperation *operation, NSInteger index, double percent) {
//        SafelyCallBlock1(progressHandler, percent);
//    };
//    
//    [self uploader:uploader addImage:image withName:name];
//    return [uploader startUpload];
}

+ (void)uploader:(QiniuUploader *)uploader addImage:(UIImage *)image withName:(NSString *)name {
    const CGFloat widthMetrics = 736;
    const CGFloat heightMetrics = 414;
    const CGFloat compressionQuality = MIN(1, MAX(widthMetrics/image.size.width, heightMetrics/image.size.height));
    
    NSData *imageData;
    if ([name hasSuffix:@".png"]) {
        imageData = UIImagePNGRepresentation(image);
    } else {
        imageData = UIImageJPEGRepresentation(image, compressionQuality);
    }
    
    [uploader addFile:[[QiniuFile alloc] initWithFileData:imageData withKey:name]];
}

+ (BOOL)uploadImages:(NSArray<UIImage *> *)images
           withNames:(NSArray<NSString *> *)names
     progressHandler:(YPBProgressHandler)progressHandler
   completionHandler:(YPBUploadCompletionHandler)handler
{
    QiniuUploader *uploader = [[QiniuUploader alloc] init];
    [images enumerateObjectsUsingBlock:^(UIImage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *name = names.count > idx ? names[idx] : nil;
        [self uploader:uploader addImage:obj withName:name];
    }];
    
    const NSUInteger fileCount = uploader.files.count;
    const CGFloat progressPerFile = 1./fileCount;
    
    __block NSUInteger completedFiles = 0;
    uploader.uploadOneFileProgress = ^(AFHTTPRequestOperation *operation, NSInteger index, double percent) {
        SafelyCallBlock1(progressHandler, completedFiles*progressPerFile+progressPerFile*percent);
    };
    
    NSMutableArray<NSNumber *> *succeededIndices = [NSMutableArray array];
    NSMutableArray<NSNumber *> *failureIndices = [NSMutableArray array];
    uploader.uploadOneFileSucceeded =  ^(AFHTTPRequestOperation *operation, NSInteger index, NSString *key) {
        [succeededIndices addObject:@(index)];
        ++completedFiles;
    };
    
    uploader.uploadOneFileFailed = ^(AFHTTPRequestOperation *operation, NSInteger index, NSDictionary *error) {
        [failureIndices addObject:@(index)];
        ++completedFiles;
    };
    
    uploader.uploadAllFilesComplete = ^{
        SafelyCallBlock2(handler, succeededIndices, failureIndices);
    };
    return [uploader startUpload];
}
@end
