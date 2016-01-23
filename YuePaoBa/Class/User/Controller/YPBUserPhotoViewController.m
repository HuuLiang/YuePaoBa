//
//  YPBUserPhotoViewController.m
//  YuePaoBa
//
//  Created by Sean Yue on 16/1/8.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "YPBUserPhotoViewController.h"
#import "YPBPhotoBarrageModel.h"
#import "YPBSendBarrageModel.h"

static const CGFloat kHeaderViewHeight = 60;
static const CGFloat kFooterViewHeight = 50;

@interface YPBUserPhotoViewController ()
{
    UIView *_headerView;
    UIView *_footerView;
    
    UITextField *_inputTextField;
    UIButton *_sendButton;
}
@property (nonatomic,retain) UIButton *barrageButton;
@property (nonatomic,retain) YPBPhotoBarrageModel *queryBarrageModel;
@property (nonatomic,retain) YPBSendBarrageModel *sendBarrageModel;

@property (nonatomic,retain) NSMutableArray<UILabel *> *barrageLabels;
@end

@implementation YPBUserPhotoViewController

DefineLazyPropertyInitialization(YPBPhotoBarrageModel, queryBarrageModel)
DefineLazyPropertyInitialization(YPBSendBarrageModel, sendBarrageModel)
DefineLazyPropertyInitialization(NSMutableArray, barrageLabels)

- (UIButton *)barrageButton {
    if (_barrageButton) {
        return _barrageButton;
    }
    
    _barrageButton = [[UIButton alloc] init];
    [_barrageButton aspect_hookSelector:@selector(setSelected:)
                            withOptions:AspectPositionAfter
                             usingBlock:^(id<AspectInfo> aspectInfo, BOOL selected)
     {
         UIButton *thisButton = [aspectInfo instance];
         if (selected) {
             thisButton.layer.borderColor = [UIColor redColor].CGColor;
             [thisButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
         } else {
             thisButton.layer.borderColor = [UIColor whiteColor].CGColor;
             [thisButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
         }
     } error:nil];
    _barrageButton.layer.cornerRadius = 4;
    _barrageButton.layer.masksToBounds = YES;
    _barrageButton.layer.borderWidth = 1;
    _barrageButton.selected = YES;
    _barrageButton.titleLabel.font = [UIFont systemFontOfSize:15.];
    //    [barrageButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    //    [barrageButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_barrageButton setTitle:@"弹幕" forState:UIControlStateNormal];
    
    @weakify(self);
    [_barrageButton bk_addEventHandler:^(id sender) {
        UIButton *thisButton = sender;
        thisButton.selected = !thisButton.selected;
        
        @strongify(self);
        if (thisButton.selected) {
            [thisButton beginLoading];
            [self loadBarragesAtIndex:self.currentPhotoIndex isByUser:YES];
        } else {
            [self stopBarrages];
        }
    } forControlEvents:UIControlEventTouchUpInside];
    return _barrageButton;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.hideOnTap = NO;
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    @weakify(self);
    self.displayAction = ^(NSUInteger index) {
        @strongify(self);
        if (self.barrageButton.selected) {
            [self loadBarragesAtIndex:index isByUser:NO];
        }
    };
    
    self.tapPhotoAction = ^(id sender) {
        @strongify(self);
        if (!self) {
            return ;
        }
        
        [self showHideHeaderFooterView];
    };
    
    _headerView = [[UIView alloc] init];
    _headerView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    _headerView.hidden = YES;
    [self.view addSubview:_headerView];
    {
        [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.height.mas_equalTo(kHeaderViewHeight);
            make.top.equalTo(self.view).offset(-kHeaderViewHeight);
        }];
    }
    
    UIButton *closeButton = [[UIButton alloc] init];
    [closeButton setTitle:@"关闭" forState:UIControlStateNormal];
    [closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [closeButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    closeButton.titleLabel.font = [UIFont systemFontOfSize:15.];
    [closeButton bk_addEventHandler:^(id sender) {
        @strongify(self);
        [self hide];
    } forControlEvents:UIControlEventTouchUpInside];
    [_headerView addSubview:closeButton];
    {
        [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_headerView).offset(15);
            make.bottom.equalTo(_headerView).offset(-10);
            make.height.equalTo(_headerView).multipliedBy(0.4);
            make.width.equalTo(closeButton.mas_height).multipliedBy(1.8);
        }];
    }
    
    [_headerView addSubview:self.barrageButton];
    {
        [self.barrageButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_headerView).offset(-15);
            make.bottom.equalTo(_headerView).offset(-10);
            make.height.equalTo(_headerView).multipliedBy(0.4);
            make.width.equalTo(self.barrageButton.mas_height).multipliedBy(1.8);
        }];
    }
    
    _footerView = [[UIView alloc] init];
    _footerView.backgroundColor = [UIColor whiteColor];
    _footerView.hidden = YES;
    [self.view addSubview:_footerView];
    {
        [_footerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.bottom.equalTo(self.view).offset(kFooterViewHeight);
            make.height.mas_equalTo(kFooterViewHeight);
        }];
    }
    
    _sendButton = [[UIButton alloc] init];
    [_sendButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#bd0010"]] forState:UIControlStateNormal];
    [_sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_sendButton setTitle:@"发射弹幕" forState:UIControlStateNormal];
    _sendButton.layer.cornerRadius = 4;
    _sendButton.layer.masksToBounds = YES;
    _sendButton.titleLabel.font = [UIFont systemFontOfSize:16.];
    [_footerView addSubview:_sendButton];
    {
        [_sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_footerView).offset(-5);
            make.centerY.equalTo(_footerView);
            make.height.equalTo(_footerView).multipliedBy(0.7);
            make.width.equalTo(_sendButton.mas_height).multipliedBy(2.5);
        }];
    }
    
    _inputTextField = [[UITextField alloc] init];
    _inputTextField.font = [UIFont systemFontOfSize:16.];
    _inputTextField.placeholder = @"输入弹幕信息";
    _inputTextField.returnKeyType = UIReturnKeySend;
    _inputTextField.bk_shouldReturnBlock = ^BOOL(UITextField *textField) {
        @strongify(self);
        [self sendBarrage:textField.text];
        return YES;
    };
    [_footerView addSubview:_inputTextField];
    {
        [_inputTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_footerView).offset(15);
            make.right.equalTo(_sendButton.mas_left).offset(-10);
            make.height.equalTo(_sendButton);
            make.centerY.equalTo(_footerView);
        }];
    }
    
    [_sendButton bk_addEventHandler:^(id sender) {
        @strongify(self);
        if (!self) {
            return ;
        }
        [self sendBarrage:self->_inputTextField.text];
    } forControlEvents:UIControlEventTouchUpInside];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(onKeyboardNotification:)
//                                                 name:UIKeyboardDidHideNotification
//                                               object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self showHideHeaderFooterView];
}

- (void)showHideHeaderFooterView {
    BOOL toShow = _headerView.hidden && _footerView.hidden;
    
    if (toShow) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onKeyboardNotification:)
                                                     name:UIKeyboardWillChangeFrameNotification
                                                   object:nil];
        
        _headerView.hidden = NO;
        [_headerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view);
        }];
        
        _footerView.hidden = NO;
        [_footerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view);
        }];
        
        [UIView animateWithDuration:0.3 animations:^{
            [self.view layoutIfNeeded];
        }];
    } else { //toHide
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:UIKeyboardWillChangeFrameNotification
                                                      object:nil];
        
        [_headerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(-kHeaderViewHeight);
        }];
        [_footerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view).offset(kFooterViewHeight);
        }];
        
        [UIView animateWithDuration:0.3 animations:^{
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            _headerView.hidden = YES;
            _footerView.hidden = YES;
        }];
        [self->_inputTextField resignFirstResponder];
    }
}

- (void)loadBarragesAtIndex:(NSUInteger)index isByUser:(BOOL)isByUser {
    [self.barrageLabels enumerateObjectsUsingBlock:^(UILabel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    [self.barrageLabels removeAllObjects];
    
    if (self.photos.count == 0 || index >= self.photos.count) {
        [self.barrageButton endLoading];
        return ;
    }
    
    @weakify(self);
    YPBUserPhoto *photo = self.photos[index];
    [self.queryBarrageModel fetchBarrageWithPhotoId:photo.id completionHandler:^(BOOL success, id obj) {
        @strongify(self);
        
        [self.barrageButton endLoading];
        
        if (success) {
            [self fireBarrages:obj];
            
            if (isByUser) {
                [self.view.window showMessageWithTitle:@"已开启弹幕"];
            }
        } else {
            [self.view.window showMessageWithTitle:@"弹幕加载失败"];
            self.barrageButton.selected = NO;
        }
    }];
}

- (void)fireBarrages:(NSArray<NSString *> *)barrages {
    [barrages enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self fireBarrage:obj withDelay:idx];
    }];
}

- (void)fireBarrage:(NSString *)barrage withDelay:(NSTimeInterval)delay {
    const CGFloat insets = 30;
    const CGFloat availableHeight = CGRectGetHeight(self.view.bounds)-kHeaderViewHeight-kFooterViewHeight-insets*2;
    const CGFloat y = arc4random_uniform(availableHeight)+kHeaderViewHeight+insets;
    
    UILabel *label = [[UILabel alloc] init];
    label.text = barrage;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:16.];
    [self.view insertSubview:label belowSubview:_footerView];
    {
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_right);
            make.top.equalTo(self.view).offset(y);
        }];
        [self.view layoutIfNeeded];
    }
    
    [UIView animateWithDuration:5+arc4random_uniform(5) delay:delay options:UIViewAnimationOptionCurveLinear animations:^{
        [label mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.view.mas_left);
            make.top.equalTo(self.view).offset(y);
        }];
        
        [self.view layoutIfNeeded];
    } completion:nil];
    
    [self.barrageLabels addObject:label];
}

- (void)stopBarrages {
    [self.barrageLabels enumerateObjectsUsingBlock:^(UILabel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    
    [self.barrageLabels removeAllObjects];
    
    [self.view.window showMessageWithTitle:@"已关闭弹幕"];
}

- (void)sendBarrage:(NSString *)barrage {
    if (self.currentPhotoIndex >= self.photos.count) {
        return ;
    }
    
    [_footerView beginLoading];
    @weakify(self);
    YPBUserPhoto *currentPhoto = self.photos[self.currentPhotoIndex];
    [self.sendBarrageModel sendBarrage:barrage
                              forPhoto:currentPhoto.id
                 withCompletionHandler:^(BOOL success, id obj)
    {
        @strongify(self);
        if (!self) {
            return ;
        }
        
        [self->_footerView endLoading];
        
        if (success) {
            self->_inputTextField.text = nil;
            [self->_inputTextField resignFirstResponder];
            [self fireBarrage:barrage withDelay:0];
            
            [self.view.window showMessageWithTitle:@"成功发射弹幕"];
        } else {
            [self.view.window showMessageWithTitle:@"发射弹幕失败"];
        }
    }];
}

- (void)onKeyboardNotification:(NSNotification *)notification {
    CGRect keyboardFrame = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    if (keyboardFrame.size.height == 0 || keyboardFrame.size.width == 0) {
        return ;
    }
    
    CGRect frameInView = [self.view convertRect:keyboardFrame fromView:nil];
    [_footerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(frameInView.origin.y-self.view.bounds.size.height);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
