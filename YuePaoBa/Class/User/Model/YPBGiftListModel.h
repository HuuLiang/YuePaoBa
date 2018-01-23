//
//  YPBGiftListModel.h
//  YuePaoBa
//
//  Created by Sean Yue on 16/2/20.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "YPBEncryptedURLRequest.h"

@interface YPBGiftListResponse : YPBURLResponse
@property (nonatomic,retain) NSArray<YPBGift *> *gifts;
@end

@interface YPBGiftListModel : YPBEncryptedURLRequest

@property (nonatomic,retain,readonly) NSArray<YPBGift *> *fetchedGifts;

- (BOOL)fetchGiftListWithCompletionHandler:(YPBCompletionHandler)handler;

@end
