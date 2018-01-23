//
//  YPBUserGiftsDataSource.h
//  YuePaoBa
//
//  Created by Sean Yue on 16/2/24.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#ifndef YPBUserGiftsDataSource_h
#define YPBUserGiftsDataSource_h

@protocol YPBUserGiftsDataSource <NSObject>

@required
- (BOOL)fetchGiftsByUser:(NSString *)userId withCompletionHandler:(YPBCompletionHandler)handler;

@end

#endif /* YPBUserGiftsDataSource_h */
