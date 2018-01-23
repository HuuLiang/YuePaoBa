//
//  YPBUploadManager.h
//  YuePaoBa
//
//  Created by Sean Yue on 15/12/31.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^YPBUploadCompletionHandler)(NSArray *uploadedOriginalImages,
                                           NSArray *uploadedThumbImages);

@interface YPBUploadManager : NSObject

+ (void)registerWithSecretKey:(NSString *)secretKey accessKey:(NSString *)accessKey scope:(NSString *)scope;
+ (BOOL)uploadImage:(UIImage *)image
           withName:(NSString *)name
    progressHandler:(YPBProgressHandler)progressHandler
  completionHandler:(YPBCompletionHandler)handler;

+ (BOOL)uploadOriginalImages:(NSArray<UIImage *> *)originalImages
                 thumbImages:(NSArray<UIImage *> *)thumbImages
              withFilePrefix:(NSString *)prefix
             progressHandler:(YPBProgressHandler)progressHandler
           completionHandler:(YPBUploadCompletionHandler)completionHandler;

+ (BOOL)uploadOriginalImages:(NSArray<UIImage *> *)originalImages
                 thumbImages:(NSArray<UIImage *> *)thumbImages
                   withNames:(NSArray<NSString *> *)names
             progressHandler:(YPBProgressHandler)progressHandler
           completionHandler:(YPBUploadCompletionHandler)completionHandler;
@end
