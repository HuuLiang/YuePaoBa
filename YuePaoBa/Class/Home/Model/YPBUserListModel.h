//
//  YPBUserListModel.h
//  YuePaoBa
//
//  Created by Sean Yue on 15/12/21.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import "YPBEncryptedURLRequest.h"

typedef NS_ENUM(NSUInteger, YPBUserSpace) {
    YPBUserSpaceUnknown,
    YPBUserSpaceHome,
    YPBUserSpaceVIP
};

@interface YPBUserListResponse : YPBURLResponse
@property (nonatomic,retain) NSArray<YPBUser *> *list;
@end

@interface YPBUserListModel : YPBEncryptedURLRequest

@property (nonatomic,retain,readonly) NSArray<YPBUser *> *fetchedUsers;
@property (nonatomic,retain,readonly) YPBPaginator *paginator;

- (BOOL)fetchUserListWithGender:(YPBUserGender)gender
                          space:(YPBUserSpace)space
              completionHandler:(YPBCompletionHandler)handler;

- (BOOL)fetchUserListInNextPageWithCompletionHandler:(YPBCompletionHandler)handler;
- (BOOL)hasNoMoreData;

@end
