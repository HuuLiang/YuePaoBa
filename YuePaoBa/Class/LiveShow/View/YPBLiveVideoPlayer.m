//
//  YPBLiveVideoPlayer.m
//  YuePaoBa
//
//  Created by Sean Yue on 16/1/27.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "YPBLiveVideoPlayer.h"

@import AVFoundation;

@interface YPBLiveVideoPlayer ()
{
    UILabel *_loadingLabel;
}
@property (nonatomic,retain) AVPlayer *player;
@property (nonatomic,retain) id timeObserver;
@end

@implementation YPBLiveVideoPlayer

+ (Class)layerClass {
    return [AVPlayerLayer class];
}

- (AVPlayer *)player {
    return [(AVPlayerLayer *)[self layer] player];
}

- (void)setPlayer:(AVPlayer *)player {
    [(AVPlayerLayer *)[self layer] setPlayer:player];
}

- (instancetype)initWithVideoURL:(NSURL *)videoURL {
    self = [self init];
    if (self) {
        _videoURL = videoURL;
        
        _loadingLabel = [[UILabel alloc] init];
        _loadingLabel.textColor = [UIColor whiteColor];
        _loadingLabel.font = [UIFont systemFontOfSize:14.];
        [self addSubview:_loadingLabel];
        {
            [_loadingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(self);
            }];
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerDidEndPlaying) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
        self.player = [AVPlayer playerWithURL:videoURL];
        [self.player addObserver:self forKeyPath:@"status" options:0 context:nil];
    }
    return self;
}

- (void)setObservingTimestamps:(NSArray<NSNumber *> *)observingTimestamps {
    _observingTimestamps = observingTimestamps;
    
    if (self.player.status == AVPlayerStatusReadyToPlay) {
        [self playerSetObservingTimestamps:observingTimestamps];
    }
}

- (void)playerSetObservingTimestamps:(NSArray<NSNumber *> *)observingTimestamps {
    CMTime duration = self.player.currentItem.asset.duration;
    
    NSMutableArray *cmTimes = [NSMutableArray array];
    [observingTimestamps enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [cmTimes addObject:[NSValue valueWithCMTime:CMTimeMakeWithSeconds(obj.floatValue/1000, duration.timescale)]];
    }];
    
    if (cmTimes.count > 0) {
        if (self.timeObserver) {
            [self.player removeTimeObserver:self.timeObserver];
            self.timeObserver = nil;
        }
        
        @weakify(self);
        self.timeObserver = [self.player addBoundaryTimeObserverForTimes:cmTimes queue:nil usingBlock:^{
            @strongify(self);
            SafelyCallBlock1(self.observingAction, self.currentTimestamp);
        }];
    }
}

- (void)startToPlay {
    self.status = YPBVideoPlayerStatusUnknown;
    _loadingLabel.text = @"加载中...";
    [self.player play];
}

- (NSNumber *)currentTimestamp {
    Float64 seconds = CMTimeGetSeconds(self.player.currentItem.currentTime);
    return @((NSUInteger)(seconds*1000));
}

- (void)playerDidEndPlaying {
    self.status = YPBVideoPlayerStatusEnded;
    SafelyCallBlock1(self.playEndAction, self);
}

- (void)dealloc {
    [self.player removeObserver:self forKeyPath:@"status"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    DLog(@"YPBLiveVideoPlayer dealloc");
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if (object == self.player && [keyPath isEqualToString:@"status"]) {
        switch (self.player.status) {
            case AVPlayerStatusReadyToPlay:
                _loadingLabel.hidden = YES;
                
                if (!self.timeObserver && self.observingTimestamps.count > 0) {
                    [self playerSetObservingTimestamps:self.observingTimestamps];
                }
                self.status = YPBVideoPlayerStatusReady;
                SafelyCallBlock1(self.readyAction, self);
                break;
            default:
                _loadingLabel.hidden = NO;
                _loadingLabel.text = @"加载失败";
                self.status = YPBVideoPlayerStatusFail;
                break;
        }
    }
}
@end
