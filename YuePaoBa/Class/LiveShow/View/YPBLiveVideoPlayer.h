//
//  YPBLiveVideoPlayer.h
//  YuePaoBa
//
//  Created by Sean Yue on 16/1/27.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^YPPBLiveVideoObservingAction)(NSNumber *timestamp);

typedef NS_ENUM(NSUInteger, YPBVideoPlayerStatus) {
    YPBVideoPlayerStatusUnknown,
    YPBVideoPlayerStatusReady,
    YPBVideoPlayerStatusFail,
    YPBVideoPlayerStatusEnded
};
@interface YPBLiveVideoPlayer : UIView

@property (nonatomic) YPBVideoPlayerStatus status;
@property (nonatomic) NSURL *videoURL;
@property (nonatomic,retain) NSArray<NSNumber *> *observingTimestamps;
@property (nonatomic,copy) YPPBLiveVideoObservingAction observingAction;
@property (nonatomic,retain,readonly) NSNumber *currentTimestamp;
@property (nonatomic,copy) YPBAction readyAction;
@property (nonatomic,copy) YPBAction playEndAction;

- (instancetype)initWithVideoURL:(NSURL *)videoURL;
- (void)startToPlay;

@end
