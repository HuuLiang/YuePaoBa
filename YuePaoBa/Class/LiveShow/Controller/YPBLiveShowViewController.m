//
//  YPBLiveShowViewController.m
//  YuePaoBa
//
//  Created by Sean Yue on 16/2/23.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "YPBLiveShowViewController.h"
#import "YPBLiveVideoPlayer.h"
#import "YPBLiveShowUserDetailPanel.h"
#import "YPBFetchBarrageModel.h"
#import "YPBSendBarrageModel.h"
#import "YPBVideoMessagePollingView.h"
#import "YPBTextField.h"
#import "YPBVideoTitleView.h"
#import "YPBLiveShowRoom.h"
#import "YPBGiftListModel.h"
#import "RNGridMenu.h"
#import "YPBRadioButton.h"
#import "YPBRadioButtonGroup.h"
#import "YPBUserAccessModel.h"
#import "YPBVideoGiftPollingView.h"
#import "YPBSendGiftModel.h"

@interface YPBLiveShowViewController () <RNGridMenuDelegate>
{
    YPBLiveVideoPlayer *_videoPlayer;
    UIButton *_closeButton;
    YPBTextField *_inputTextField;
    
    UIButton *_inputButton;
    YPBVideoTitleView *_titleView;
    UIButton *_giftButton;
}
@property (nonatomic,retain) YPBLiveShowUserDetailPanel *userDetailPanel;
@property (nonatomic,retain) YPBFetchBarrageModel *fetchBarrageModel;
@property (nonatomic,retain) NSArray<YPBBarrage *> *barrages;

@property (nonatomic,retain) YPBSendBarrageModel *sendBarrageModel;
@property (nonatomic,retain) YPBVideoMessagePollingView *messagePollingView;
@property (nonatomic,retain) YPBVideoGiftPollingView *giftPollingView;

@property (nonatomic,retain,readonly) YPBLiveShowRoom *room;
@property (nonatomic,retain) YPBGiftListModel *giftListModel;

@property (nonatomic,readonly) NSString *audienceTitle;
@property (nonatomic,retain) NSTimer *timer;
@property (nonatomic,retain,readonly) RNGridMenu *giftsMenu;

@property (nonatomic) YPBPaymentType paymentType;
@property (nonatomic,retain) YPBUserAccessModel *greetModel;
@property (nonatomic,retain) YPBSendGiftModel *sendGiftModel;
@end

@implementation YPBLiveShowViewController

DefineLazyPropertyInitialization(YPBFetchBarrageModel, fetchBarrageModel)
DefineLazyPropertyInitialization(YPBSendBarrageModel, sendBarrageModel)
DefineLazyPropertyInitialization(YPBGiftListModel, giftListModel)
DefineLazyPropertyInitialization(YPBUserAccessModel, greetModel)
DefineLazyPropertyInitialization(YPBSendGiftModel, sendGiftModel)

- (instancetype)init {
    self = [super init];
    if (self) {
        _paymentType = YPBPaymentTypeWeChatPay;
    }
    return self;
}

- (instancetype)initWithUser:(YPBUser *)user {
    self = [self init];
    if (self) {
        _user = user;
        
        if (user.userVideo.id) {
            _room = [YPBLiveShowRoom existingRoomWithId:user.userVideo.id.unsignedIntegerValue];
            if (!_room || _room.accumulatedAudiences.unsignedIntegerValue > 10000) {
                _room = [YPBLiveShowRoom roomWithId:user.userVideo.id.unsignedIntegerValue];
                [_room persist];
            }
        }
    }
    return self;
}

- (NSString *)audienceTitle {
    return [NSString stringWithFormat:@"%@人/目前%@人", _room.accumulatedAudiences, _room.currentAudiences];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onKeyboardNotification:)
                                                 name:UIKeyboardWillChangeFrameNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onApplicationDidBecomeActive)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    @weakify(self);
    _videoPlayer = [[YPBLiveVideoPlayer alloc] initWithVideoURL:[NSURL URLWithString:self.user.userVideo.videoUrl]];
    [_videoPlayer bk_whenTapped:^{
        @strongify(self);
        if (![self->_userDetailPanel isShown] && ![self->_inputTextField isFirstResponder]) {
            [self sendToy];
        }
        
        [self->_userDetailPanel hide];
        [self->_inputTextField resignFirstResponder];
        
        if (self->_videoPlayer.status == YPBVideoPlayerStatusFail) {
            [self->_videoPlayer startToPlay];
        }
    }];
    _videoPlayer.observingAction = ^(NSNumber *timestamp) {
        @strongify(self);
        NSMutableArray *messages = [NSMutableArray array];
        NSMutableArray *names = [NSMutableArray array];
        [self.barrages enumerateObjectsUsingBlock:^(YPBBarrage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (ABS(obj.barrageTime.unsignedIntegerValue-timestamp.unsignedIntegerValue) < 5) {
                if (obj.msg.length > 0 || obj.userName.length > 0) {
                    [messages addObject:obj.msg?:@""];
                    [names addObject:obj.userName?:@""];
                }
            }
        }];
        
        [self.messagePollingView insertMessages:messages forNames:names];
    };
    _videoPlayer.readyAction = ^(id obj) {
        @strongify(self);
        self.timer = [NSTimer bk_scheduledTimerWithTimeInterval:5 block:^(NSTimer *timer) {
            @strongify(self);
            if (!self) {
                return ;
            }
            
            [self.room beginUpdate];
            u_int32_t accumulation = arc4random_uniform(20);
            self.room.accumulatedAudiences = @(self.room.accumulatedAudiences.unsignedIntegerValue+accumulation);
            self.room.currentAudiences = @(self.room.currentAudiences.unsignedIntegerValue+arc4random_uniform(accumulation));
            [self.room endUpdate];
            
            self->_titleView.detail = self.audienceTitle;
        } repeats:YES];
    };
    _videoPlayer.playEndAction = ^(id obj) {
        @strongify(self);
        [self.timer invalidate];
    };
    [self.view addSubview:_videoPlayer];
    {
        [_videoPlayer mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    
    _titleView = [[YPBVideoTitleView alloc] initWithAvatarUrl:[NSURL URLWithString:self.user.logoUrl] detail:self.audienceTitle];
    [_titleView bk_whenTapped:^{
        @strongify(self);
        if (self.userDetailPanel.isShown) {
            [self.userDetailPanel hide];
        } else {
            [self.userDetailPanel showInView:self.view];
            [self->_inputTextField resignFirstResponder];
        }
    }];
    [self.view addSubview:_titleView];
    {
        [_titleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(15);
            make.top.equalTo(self.view).offset(30);
            make.size.mas_equalTo(CGSizeMake(MIN(kScreenWidth*0.6, 200), MIN(50,kScreenHeight*0.1)));
        }];
    }
    
    _closeButton = [[UIButton alloc] init];
    UIImage *closeImage = [UIImage imageNamed:@"video_close_icon"];
    [_closeButton setImage:closeImage forState:UIControlStateNormal];
    [self.view addSubview:_closeButton];
    {
        [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_titleView);
            make.right.equalTo(self.view).offset(-15);
            make.size.mas_equalTo(CGSizeMake(30, 30));
        }];
    }
    
    [_closeButton bk_addEventHandler:^(id sender) {
        @strongify(self);
        [self dismissViewControllerAnimated:YES completion:nil];
    } forControlEvents:UIControlEventTouchUpInside];
    
    const CGFloat defaultButtonSize = 44;
    _inputButton = [[UIButton alloc] init];
    _inputButton.layer.cornerRadius = defaultButtonSize/2;
    _inputButton.layer.masksToBounds = YES;
    [_inputButton setImage:[UIImage imageNamed:@"video_message_icon"] forState:UIControlStateNormal];
    [_inputButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithWhite:1 alpha:0.3]] forState:UIControlStateNormal];
    [_inputButton bk_addEventHandler:^(id sender) {
        @strongify(self);
        [self->_inputTextField becomeFirstResponder];
    } forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_inputButton];
    {
        [_inputButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(15);
            make.bottom.equalTo(self.view).offset(-15);
            make.size.mas_equalTo(CGSizeMake(defaultButtonSize, defaultButtonSize));
        }];
    }
    
    _inputTextField = [[YPBTextField alloc] init];
    _inputTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"对TA说些什么？" attributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
    _inputTextField.textColor = [UIColor colorWithWhite:0.9 alpha:1];
    _inputTextField.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.5];
    _inputTextField.font = [UIFont systemFontOfSize:16.];
    _inputTextField.layer.cornerRadius = 4;
    _inputTextField.layer.masksToBounds = YES;
    _inputTextField.returnKeyType = UIReturnKeySend;
    _inputTextField.tintColor = [UIColor whiteColor];
    _inputTextField.bk_shouldReturnBlock = ^BOOL(UITextField *textField) {
        @strongify(self);
        if ([textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0) {
            [self.view showMessageWithTitle:@"亲，你怎么什么话都不说呢~~~"];
            return NO;
        }
        
        [self sendBarrage:textField.text];
        return YES;
    };
    _inputTextField.hidden = YES;
    [self.view addSubview:_inputTextField];
    {
        [_inputTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(15);
            make.right.equalTo(self.view).offset(-15);
//            make.bottom.equalTo(self.view).offset(44);
            make.bottom.equalTo(self.view).offset(-15);
            make.height.mas_equalTo(44);
        }];
    }
    
    
    _giftButton = [[UIButton alloc] init];
    _giftButton.layer.cornerRadius = defaultButtonSize/2;
    _giftButton.layer.masksToBounds = YES;
    [_giftButton setImage:[UIImage imageNamed:@"video_gift_icon"] forState:UIControlStateNormal];
    [_giftButton setBackgroundImage:[_inputButton backgroundImageForState:UIControlStateNormal] forState:UIControlStateNormal];
    [_giftButton bk_addEventHandler:^(id sender) {
        @strongify(self);
        if (!self) {
            return ;
        }
        
        [sender beginLoading];
        if (self.giftListModel.fetchedGifts.count == 0) {
            [self.giftListModel fetchGiftListWithCompletionHandler:^(BOOL success, id obj) {
                @strongify(self);
                
                if (success) {
                    [self.giftsMenu showInViewController:self center:self.view.center];
                } else {
                    [sender endLoading];
                }
            }];
        } else {
            [self.giftsMenu showInViewController:self center:self.view.center];
        }
    } forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_giftButton];
    {
        [_giftButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.view).offset(-30);
            make.centerY.equalTo(_inputButton);
            make.size.equalTo(_inputButton);
        }];
    }
    
    _messagePollingView = [[YPBVideoMessagePollingView alloc] init];
    _messagePollingView.contentInset = UIEdgeInsetsMake(_messagePollingView.messageRowHeight*8, 0, 0, 0);
    [self.view insertSubview:_messagePollingView belowSubview:_titleView];
    {
        [_messagePollingView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view);
            make.bottom.equalTo(_inputTextField.mas_top).offset(-5);
            make.right.equalTo(self.view.mas_centerX).multipliedBy(1.5);
            make.height.mas_equalTo(_messagePollingView.contentInset.top);
        }];
    }
    
    _giftPollingView = [[YPBVideoGiftPollingView alloc] init];
    _giftPollingView.contentInset = UIEdgeInsetsMake(_giftPollingView.giftRowHeight*4, 0, 0, 0);
    [self.view insertSubview:_giftPollingView belowSubview:_titleView];
    {
        [_giftPollingView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(_messagePollingView);
            make.bottom.equalTo(_messagePollingView.mas_top).offset(-5);
            make.height.mas_equalTo(_giftPollingView.contentInset.top);
        }];
    }
    
    [self loadBarrages];
}

- (YPBRadioButton *)paymentSelectionButtonWithTitle:(NSString *)title {
    YPBRadioButton *button = [[YPBRadioButton alloc] init];
    button.titleLabel.font = [UIFont systemFontOfSize:14.];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    [button setTitle:title forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithWhite:0.5 alpha:0.8]] forState:UIControlStateSelected];
    [button setTitleColor:[UIColor colorWithWhite:0.3 alpha:1] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    return button;
}

- (RNGridMenu *)giftsMenu {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 44)];
    
    YPBRadioButton *weChatPayButton = [self paymentSelectionButtonWithTitle:@"微信客户端支付"];
    weChatPayButton.frame = CGRectMake(0, 0,
                                       footerView.bounds.size.width/2,
                                       footerView.bounds.size.height);
    weChatPayButton.selected = self.paymentType == YPBPaymentTypeWeChatPay;
    [footerView addSubview:weChatPayButton];
    
    YPBRadioButton *alipayButton = [self paymentSelectionButtonWithTitle:@"支付宝支付"];
    alipayButton.frame = CGRectMake(CGRectGetMaxX(weChatPayButton.frame), 0,
                                    footerView.bounds.size.width/2,
                                    footerView.bounds.size.height);
    alipayButton.selected = self.paymentType == YPBPaymentTypeAlipay;
    [footerView addSubview:alipayButton];
    
    YPBRadioButtonGroup *radioButtonGroup = [YPBRadioButtonGroup groupWithRadioButtons:@[weChatPayButton,alipayButton]];
    objc_setAssociatedObject(footerView, &radioButtonGroup, radioButtonGroup, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    @weakify(self);
    radioButtonGroup.selectionChangeAction = ^(id sender) {
        @strongify(self);
        self.paymentType = sender==alipayButton?YPBPaymentTypeAlipay:YPBPaymentTypeWeChatPay;
    };
    
    NSMutableArray *gridItems = [NSMutableArray array];
    [self.giftListModel.fetchedGifts enumerateObjectsUsingBlock:^(YPBGift * _Nonnull gift, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *title = [NSString stringWithFormat:@"%@%@元", gift.name, [YPBUtil priceStringWithValue:gift.fee.unsignedIntegerValue]];
        RNGridMenuItem *item = [[RNGridMenuItem alloc] initWithImageUrl:[NSURL URLWithString:gift.imgUrl] title:title];
        [gridItems addObject:item];
    }];
    
    RNGridMenu *giftsMenu = [[RNGridMenu alloc] initWithItems:gridItems];
    giftsMenu.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.8];
    giftsMenu.highlightColor = [UIColor colorWithWhite:0.5 alpha:0.8];
    giftsMenu.footerView = footerView;
    giftsMenu.delegate = self;
    return giftsMenu;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.timer invalidate];
    self.timer = nil;
}

- (void)loadBarrages {
    @weakify(self);
    [self.fetchBarrageModel fetchBarragesById:self.user.userVideo.id
                                  barrageType:YPBBarrageTypeVideo
                            completionHandler:^(BOOL success, id obj)
    {
        @strongify(self);
        if (!self) {
            return ;
        }
        
        if (success) {
            NSArray<YPBBarrage *> *fetchedBarrages = obj;
            self.barrages = [fetchedBarrages sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                return [((YPBBarrage *)obj1).barrageTime compare:((YPBBarrage *)obj2).barrageTime];
            }];
        }
    }];
}

- (void)setBarrages:(NSArray<YPBBarrage *> *)barrages {
    _barrages = barrages;
    
    if (barrages.count > 0) {
        NSMutableArray<NSNumber *> *timestamps = [NSMutableArray array];
        [barrages enumerateObjectsUsingBlock:^(YPBBarrage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [timestamps addObject:obj.barrageTime];
        }];
        _videoPlayer.observingTimestamps = timestamps;
    }
}

- (void)sendBarrage:(NSString *)barrage {
    @weakify(self);
    [self.sendBarrageModel sendBarrage:barrage
                           forObjectId:self.user.userVideo.id
                           barrageType:YPBBarrageTypeVideo
                      barrageTimestamp:_videoPlayer.currentTimestamp
                 withCompletionHandler:^(BOOL success, id obj)
    {
        @strongify(self);
        if (!self) {
            return ;
        }
        
        if (success) {
            self->_inputTextField.text = nil;
            [self->_inputTextField resignFirstResponder];
            [self.messagePollingView insertMessages:@[barrage] forNames:@[[YPBUser currentUser].nickName?:@""]];
        } else {
            [self.view showMessageWithTitle:@"Sorry，您想说的话发送失败了~~~"];
        }
    }];
}

- (void)sendToy {
    UIImage *toyImage;
    if (arc4random_uniform(100) % 5 == 0) {
        toyImage = arc4random_uniform(2) == 0 ? [UIImage imageNamed:@"cat_icon"] : [UIImage imageNamed:@"rabbit_icon"];
    } else {
        toyImage = [UIImage imageNamed:[NSString stringWithFormat:@"video_like_icon%d", arc4random_uniform(5)+1]];
    }
    
    if (toyImage == nil) {
        return ;
    }
    
    CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    positionAnimation.duration = 5;
    
    const CGFloat imageWidth = toyImage.size.width;
    const CGFloat imageHeight = toyImage.size.height;
    CGPoint startPosition = CGPointMake(_giftButton.frame.origin.x+imageWidth-arc4random_uniform(imageWidth), _giftButton.frame.origin.y-imageHeight/2);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, startPosition.x, startPosition.y);
    CGPathAddCurveToPoint(path, nil,
                          startPosition.x+imageWidth/2-arc4random_uniform(imageWidth),
                          startPosition.y,
                          startPosition.x+imageWidth/2-arc4random_uniform(imageWidth),
                          startPosition.y-kScreenHeight/3-arc4random_uniform(kScreenHeight*1/3),
                          startPosition.x+imageWidth/2-arc4random_uniform(imageWidth),
                          startPosition.y-kScreenHeight/2);
    positionAnimation.path = path;
    CGPathRelease(path);
    
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.duration = positionAnimation.duration/2;
    opacityAnimation.toValue = @0;
    opacityAnimation.beginTime = positionAnimation.duration/2;
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.animations = @[positionAnimation, opacityAnimation];
    animationGroup.duration = positionAnimation.duration;
    animationGroup.delegate = self;
    animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CALayer *layer = [CALayer layer];
    layer.contents = (__bridge id)toyImage.CGImage;
    layer.bounds = CGRectMake(0, 0, imageWidth, imageHeight);
    layer.position = CGPointMake(0, kScreenHeight+imageHeight/2);
    [animationGroup setValue:layer forKey:@"AnimationLayer"];
    [layer addAnimation:animationGroup forKey:nil];
    [self.view.layer addSublayer:layer];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    CALayer *layer = [anim valueForKey:@"AnimationLayer"];
    [layer removeAllAnimations];
    [layer removeFromSuperlayer];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    //[_messagePollingView startPolling];
    if (_videoPlayer.status != YPBVideoPlayerStatusEnded) {
        [_videoPlayer startToPlay];
    }
}

- (YPBLiveShowUserDetailPanel *)userDetailPanel {
    if (_userDetailPanel) {
        return _userDetailPanel;
    }
    
    @weakify(self);
    _userDetailPanel = [[YPBLiveShowUserDetailPanel alloc] initWithUser:self.user];
    _userDetailPanel.greetAction = ^(id sender) {
        @strongify(self);
        if (self.user.isGreet) {
            [sender endLoading];
            return ;
        }
        
        [self.greetModel accessUserWithUserId:self.user.userId
                                   accessType:YPBUserAccessTypeGreet
                            completionHandler:^(BOOL success, id obj)
        {
            @strongify(self);
            [sender endLoading];
            
            if (!self) {
                return ;
            }
            
            if (success) {
                self.user.isGreet = YES;
                self.user.receiveGreetCount = @(self.user.receiveGreetCount.unsignedIntegerValue+1);
            }
        }];
    };
    return _userDetailPanel;
}

- (void)onKeyboardNotification:(NSNotification *)notification {
    CGRect keyboardFrame = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    if (keyboardFrame.size.height == 0 || keyboardFrame.size.width == 0) {
        return ;
    }
    
    CGRect frameInView = [self.view convertRect:keyboardFrame fromView:nil];
    const CGFloat offset = frameInView.origin.y-self.view.bounds.size.height;

    _inputTextField.hidden = offset == 0;
    [_inputTextField mas_updateConstraints:^(MASConstraintMaker *make) {
        if (offset == 0) {
            make.bottom.equalTo(self.view).offset(-15);
        } else {
            make.bottom.equalTo(self.view).offset(offset-15);
        }
    }];
    
    [UIView animateWithDuration:0.3 animations:^{
        [_messagePollingView layoutIfNeeded];
        [_giftPollingView layoutIfNeeded];
        [_inputTextField layoutIfNeeded];
    }];
}

- (void)onApplicationDidBecomeActive {
    [_videoPlayer startToPlay];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - RNGridMenuDelegate

- (void)gridMenu:(RNGridMenu *)gridMenu willDismissWithSelectedItem:(RNGridMenuItem *)item atIndex:(NSInteger)itemIndex {
    NSArray<YPBGift *> *gifts = self.giftListModel.fetchedGifts;
    if (itemIndex < gifts.count) {
        YPBGift *gift = gifts[itemIndex];
        
        @weakify(self);
        YPBPaymentInfo *paymentInfo = [YPBPaymentInfo paymentInfo];
        paymentInfo.orderPrice = gift.fee;
        paymentInfo.paymentType = @(self.paymentType);
        paymentInfo.paymentResult = @(PAYRESULT_UNKNOWN);
        paymentInfo.paymentStatus = @(YPBPaymentStatusPaying);
        paymentInfo.payPointType = @(YPBPayPointTypeGift);
        paymentInfo.contentType = @(YPBPaymentContentTypeGift).stringValue;

        [[YPBPaymentManager sharedManager] payWithPaymentInfo:paymentInfo completionHandler:^(BOOL success, id obj) {
            @strongify(self);
            PAYRESULT result = paymentInfo.paymentResult.unsignedIntegerValue;
            if (result == PAYRESULT_SUCCESS) {
                [self.giftPollingView pollGiftWithImageUrl:[NSURL URLWithString:gift.imgUrl]
                                                      name:gift.name
                                                    sender:[YPBUser currentUser].nickName];
                
                NSMutableArray *gifts = self.user.gifts.mutableCopy;
                if (!gifts) {
                    gifts = [NSMutableArray array];
                }
                
                gift.userName = [YPBUser currentUser].nickName;
                [gifts insertObject:gift atIndex:0];
                self.user.gifts = gifts;
                
                [self.sendGiftModel sendGift:gift.id
                                      toUser:self.user.userId
                                withNickName:self.user.nickName
                           completionHandler:nil];
            } else if (result == PAYRESULT_ABANDON) {
                [self.view.window showMessageWithTitle:@"支付取消"];
            } else {
                [self.view.window showMessageWithTitle:@"支付失败"];
            }
        }];
    }
    [_giftButton endLoading];
}

- (void)gridMenuWillDismiss:(RNGridMenu *)gridMenu {
    [_giftButton endLoading];
}
@end
