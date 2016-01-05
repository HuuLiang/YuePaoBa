//
//  YPBUploadManager.h
//  YuePaoBa
//
//  Created by Sean Yue on 15/12/31.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^YPBUploadCompletionHandler)(NSArray *success, NSArray *failure);

@interface YPBUploadManager : NSObject

+ (void)registerWithSecretKey:(NSString *)secretKey accessKey:(NSString *)accessKey scope:(NSString *)scope;
+ (BOOL)uploadImage:(UIImage *)image
           withName:(NSString *)name
    progressHandler:(YPBProgressHandler)progressHandler
  completionHandler:(YPBCompletionHandler)handler;

+ (BOOL)uploadImages:(NSArray<UIImage *> *)images
           withNames:(NSArray<NSString *> *)names
     progressHandler:(YPBProgressHandler)progressHandler
   completionHandler:(YPBUploadCompletionHandler)handler;
@end
