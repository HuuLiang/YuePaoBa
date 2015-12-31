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
    NSData *imageData;
    if ([name hasSuffix:@".png"]) {
        imageData = UIImagePNGRepresentation(image);
    } else {
        imageData = UIImageJPEGRepresentation(image, 0.5);
    }
    
    QiniuUploader *uploader = [[QiniuUploader alloc] init];
    [uploader addFile:[[QiniuFile alloc] initWithFileData:imageData withKey:name]];
    uploader.uploadOneFileSucceeded = ^(AFHTTPRequestOperation *operation, NSInteger index, NSString *key) {
        SafelyCallBlock2(handler, YES, key);
    };
    uploader.uploadOneFileFailed = ^(AFHTTPRequestOperation *operation, NSInteger index, NSDictionary *error) {
        SafelyCallBlock2(handler, NO, error);
    };
    uploader.uploadOneFileProgress = ^(AFHTTPRequestOperation *operation, NSInteger index, double percent) {
        SafelyCallBlock1(progressHandler, percent);
    };
    return [uploader startUpload];
}
@end
