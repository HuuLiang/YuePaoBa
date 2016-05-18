//
//  YPBUserListModel.m
//  YuePaoBa
//
//  Created by Sean Yue on 15/12/21.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import "YPBUserListModel.h"

@implementation YPBUserListResponse

- (Class)listElementClass {
    return [YPBUser class];
}

- (Class)usersElementClass {
    return [YPBUser class];
}

@end

@interface YPBUserListModel ()
@property (nonatomic) YPBUserGender requestedGender;
@property (nonatomic) YPBUserSpace requestedSpace;
@end

@implementation YPBUserListModel

+ (Class)responseClass {
    return [YPBUserListResponse class];
}

- (BOOL)fetchUserListWithGender:(YPBUserGender)gender
                          space:(YPBUserSpace)space
              completionHandler:(YPBCompletionHandler)handler {
    return [self fetchUserListWithGender:gender space:space page:1 completionHandler:handler];
}

- (BOOL)fetchUserListWithGender:(YPBUserGender)gender
                          space:(YPBUserSpace)space
                           page:(NSUInteger)page
              completionHandler:(YPBCompletionHandler)handler {
    if (gender == YPBUserGenderUnknown) {
        SafelyCallBlock2(handler, NO, @"当前用户未登录，请登录后再尝试刷新");
        return NO;
    }
    NSDictionary *params = nil;
    
    if (space != 3) {
        params = @{@"userId":[YPBUser currentUser].userId,
                   @"sex":[YPBUser stringOfGender:gender],
                   @"uPosition":space == YPBUserSpaceHome ? @1 : @2,
                   @"pageNum":@(page),
                   @"pageSize":space == YPBUserSpaceHome?@18:@10
                   };
    } else {
        params = @{@"userId":[YPBUser currentUser].userId,
                   @"sex":[YPBUser stringOfGender:gender],
                   @"uPosition":@3,
                   @"pageNum":@(page),
                   @"pageSize":space == YPBUserSpaceHome?@18:@10
                   };
    }
    
    _requestedGender = gender;
    _requestedSpace = space;
    
    
    BOOL success = [self requestURLPath:YPB_USER_LIST_URL
                             withParams:params
                        responseHandler:^(YPBURLResponseStatus respStatus, NSString *errorMessage)
                    {
                        YPBUserListResponse *resp = self.response;
                        if (respStatus == YPBURLResponseSuccess) {
                            _fetchedUsers = resp.list;
                            _paginator = resp.paginator;
                        }
                        
                        SafelyCallBlock2(handler, respStatus==YPBURLResponseSuccess, resp.list.count>0?resp.list:nil);
                    }];
    return success;
}

- (BOOL)fetchUserListInNextPageWithCompletionHandler:(YPBCompletionHandler)handler {
    if (self.requestedGender == YPBUserGenderUnknown
        || self.requestedSpace == YPBUserSpaceUnknown
        || [self hasNoMoreData]) {
        SafelyCallBlock2(handler, NO, nil);
        return NO;
    }
    
    NSUInteger currentPage = self.paginator.page.unsignedIntegerValue;
    return [self fetchUserListWithGender:self.requestedGender space:self.requestedSpace page:currentPage+1 completionHandler:handler];
}

- (BOOL)hasNoMoreData {
    return [self.paginator.page isEqualToNumber:self.paginator.pages];
}

- (BOOL)fetchUserRecommendUserListWithSex:(YPBUserGender)gender CompletionHandler:(YPBCompletionHandler)handler {
    DLog("%@",[YPBUser currentUser].userId);
    DLog("%@",[YPBUser stringOfGender:gender]);
    NSDictionary *params = @{@"sex":[YPBUser stringOfGender:gender],
                             @"channelNo":YPB_CHANNEL_NO,
                             @"userId":[YPBUser currentUser].userId
                             };
    BOOL success = [self requestURLPath:YPB_HOMEGREETUSERS_URL
                             withParams:params
                        responseHandler:^(YPBURLResponseStatus respStatus, NSString *errorMessage)
    {
        YPBUserListResponse *resp = self.response;
        if (respStatus == YPBURLResponseSuccess) {
            _fetchedUsers = resp.users;
        }
        handler(respStatus==YPBURLResponseSuccess,_fetchedUsers);
    }];
    return success;
    
}

@end
