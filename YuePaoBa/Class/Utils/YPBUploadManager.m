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

+ (NSString *)imageURLWithName:(NSString *)name {
    NSString *baseURL = [YPBSystemConfig defaultConfig].imgUrl;
    if (![baseURL hasSuffix:@"/"]) {
        baseURL = [baseURL stringByAppendingString:@"/"];
    }
    
    return [baseURL stringByAppendingString:name];
}

+ (BOOL)uploadImage:(UIImage *)image
           withName:(NSString *)name
    progressHandler:(YPBProgressHandler)progressHandler
  completionHandler:(YPBCompletionHandler)handler
{
    QiniuUploader *uploader = [[QiniuUploader alloc] init];
    uploader.uploadOneFileSucceeded = ^(AFHTTPRequestOperation *operation, NSInteger index, NSString *key) {
        SafelyCallBlock2(handler, YES, [YPBUploadManager imageURLWithName:key]);
    };
    uploader.uploadOneFileFailed = ^(AFHTTPRequestOperation *operation, NSInteger index, NSDictionary *error) {
        SafelyCallBlock2(handler, NO, error);
    };
    uploader.uploadOneFileProgress = ^(AFHTTPRequestOperation *operation, NSInteger index, double percent) {
        SafelyCallBlock1(progressHandler, percent);
    };
    
    [self uploader:uploader addImage:image withName:name];
    return [uploader startUpload];
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

+ (BOOL)uploadOriginalImages:(NSArray<UIImage *> *)originalImages
                 thumbImages:(NSArray<UIImage *> *)thumbImages
              withFilePrefix:(NSString *)prefix
             progressHandler:(YPBProgressHandler)progressHandler
           completionHandler:(YPBUploadCompletionHandler)completionHandler {
    if (originalImages.count != thumbImages.count) {
        return NO;
    }
    
    NSMutableArray *names = [NSMutableArray array];
    for (NSUInteger i = 0; i < originalImages.count; ++i) {
        [names addObject:[prefix stringByAppendingString:[NSString stringWithFormat:@"_%@", [NSUUID UUID].UUIDString.md5]]];
    }
    return [self uploadOriginalImages:originalImages thumbImages:thumbImages withNames:names progressHandler:progressHandler completionHandler:completionHandler];
}

+ (BOOL)uploadOriginalImages:(NSArray<UIImage *> *)originalImages
                 thumbImages:(NSArray<UIImage *> *)thumbImages
                   withNames:(NSArray<NSString *> *)names
             progressHandler:(YPBProgressHandler)progressHandler
           completionHandler:(YPBUploadCompletionHandler)completionHandler {
    if (originalImages.count != thumbImages.count
        || originalImages.count != names.count) {
        return NO;
    }
    NSString *const originalSuffix = @"_original.jpg";
    NSString *const thumbSuffix = @"_thumbnail.jpg";
    
    QiniuUploader *uploader = [[QiniuUploader alloc] init];
    [originalImages enumerateObjectsUsingBlock:^(UIImage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIImage *thumbImage = thumbImages[idx];
        NSString *name = names[idx];
        
        [self uploader:uploader addImage:obj withName:[name stringByAppendingString:originalSuffix]];
        [self uploader:uploader addImage:thumbImage withName:[name stringByAppendingString:thumbSuffix]];
    }];
    
    const NSUInteger fileCount = uploader.files.count;
    const CGFloat progressPerFile = 1./fileCount;
    
    __block NSUInteger completedFiles = 0;
    uploader.uploadOneFileProgress = ^(AFHTTPRequestOperation *operation, NSInteger index, double percent) {
        SafelyCallBlock1(progressHandler, completedFiles*progressPerFile+progressPerFile*percent);
    };
    
    NSMutableDictionary<NSNumber *, NSString *> *succeededOriginals = [NSMutableDictionary dictionary];
    NSMutableDictionary<NSNumber *, NSString *> *succeededThumbs = [NSMutableDictionary dictionary];
    //NSMutableArray<NSNumber *> *failureIndices = [NSMutableArray array];
    uploader.uploadOneFileSucceeded =  ^(AFHTTPRequestOperation *operation, NSInteger index, NSString *key) {
        if ([key hasSuffix:originalSuffix]) {
            [succeededOriginals setObject:key forKey:@(index)];
        } else if ([key hasSuffix:thumbSuffix]) {
            [succeededThumbs setObject:key forKey:@(index-1)];
        }
        ++completedFiles;
    };
    
    uploader.uploadOneFileFailed = ^(AFHTTPRequestOperation *operation, NSInteger index, NSDictionary *error) {
        //[failureIndices addObject:@(index)];
        ++completedFiles;
    };
    
    
    uploader.uploadAllFilesComplete = ^{
        NSMutableArray<NSString *> *uploadedOriginalImages = [NSMutableArray array];
        NSMutableArray<NSString *> *uploadedThumbImages = [NSMutableArray array];
        
        [succeededOriginals enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
            NSString *thumb = succeededThumbs[key];
            if (thumb) {
                [uploadedOriginalImages addObject:[YPBUploadManager imageURLWithName:obj]];
                [uploadedThumbImages addObject:[YPBUploadManager imageURLWithName:thumb]];
            }
        }];
        
        SafelyCallBlock2(completionHandler, uploadedOriginalImages, uploadedThumbImages);
    };
    return [uploader startUpload];
}
@end
