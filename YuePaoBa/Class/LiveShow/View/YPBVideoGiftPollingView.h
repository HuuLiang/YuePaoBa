//
//  YPBVideoGiftPollingView.h
//  YuePaoBa
//
//  Created by Sean Yue on 16/3/4.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YPBVideoGiftPollingView : UITableView

@property (nonatomic) CGFloat giftRowHeight;

- (void)pollGiftWithImageUrl:(NSURL *)imageUrl name:(NSString *)name sender:(NSString *)sender;

@end
