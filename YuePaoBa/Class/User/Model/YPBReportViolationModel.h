//
//  YPBReportViolationModel.h
//  YuePaoBa
//
//  Created by Sean Yue on 16/2/18.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "YPBEncryptedURLRequest.h"

@interface YPBReportViolationModel : YPBEncryptedURLRequest

- (BOOL)reportViolationWithContent:(NSString *)content
                            userId:(NSString *)userId
                 completionHandler:(YPBCompletionHandler)handler;

@end
