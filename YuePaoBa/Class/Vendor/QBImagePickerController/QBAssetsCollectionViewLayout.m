//
//  QBAssetsCollectionViewLayout.m
//  QBImagePickerController
//
//  Created by Tanaka Katsuma on 2013/12/31.
//  Copyright (c) 2013年 Katsuma Tanaka. All rights reserved.
//

#import "QBAssetsCollectionViewLayout.h"

@implementation QBAssetsCollectionViewLayout

+ (instancetype)layout
{
    return [[self alloc] init];
}

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        self.minimumInteritemSpacing = 2.0;
        self.minimumLineSpacing = self.minimumInteritemSpacing;
    }
    
    return self;
}

@end
