//
//  YPBLiveShowUserDetailPanel.m
//  YuePaoBa
//
//  Created by Sean Yue on 16/2/25.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "YPBLiveShowUserDetailPanel.h"
#import "YPBLikeButton.h"

@interface YPBLiveShowUserDetailPanel ()
{
    UIImageView *_avatarImageView;
    UILabel *_detailLabel;
    YPBLikeButton *_likeButton;
}
@end

@implementation YPBLiveShowUserDetailPanel

- (instancetype)initWithUser:(YPBUser *)user {
    self = [super init];
    if (self) {
        _user = user;
        
        [_user addObserver:self forKeyPath:NSStringFromSelector(@selector(isGreet)) options:NSKeyValueObservingOptionNew context:nil];
        [_user addObserver:self forKeyPath:NSStringFromSelector(@selector(receiveGreetCount)) options:NSKeyValueObservingOptionNew context:nil];
        self.backgroundColor = [UIColor colorWithWhite:0.96 alpha:1];
    }
    return self;
}

- (void)dealloc {
    [_user removeObserver:self forKeyPath:NSStringFromSelector(@selector(isGreet))];
    [_user removeObserver:self forKeyPath:NSStringFromSelector(@selector(receiveGreetCount))];
}

- (void)showInView:(UIView *)view {
    if ([view.subviews containsObject:self]) {
        return ;
    }
    
    [self prepareForUIContents];
    self.frame = CGRectMake(view.bounds.origin.x, CGRectGetMaxY(view.bounds), view.bounds.size.width, 150);
    self.alpha = 0;
    [view addSubview:self];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectOffset(self.frame, 0, -CGRectGetHeight(self.frame));
        self.alpha = 1;
    } completion:^(BOOL finished) {
        _isShown = YES;
    }];
}

- (void)prepareForUIContents {
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc] init];
        _avatarImageView.layer.masksToBounds = YES;
        [self addSubview:_avatarImageView];
        {
            [_avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self);
                make.left.equalTo(self).offset(30);
                make.height.equalTo(self).dividedBy(2);
                make.width.equalTo(_avatarImageView.mas_height);
            }];
        }
    }
    [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:self.user.logoUrl]
                        placeholderImage:[UIImage imageNamed:@"avatar_placeholder"]];
    
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _detailLabel.font = [UIFont systemFontOfSize:14.];
        [self addSubview:_detailLabel];
        {
            [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_avatarImageView.mas_right).offset(30);
                make.centerY.equalTo(self);
                make.right.equalTo(self).offset(-15);
            }];
        }
    }
    
    NSUInteger numberOfLines = 1;
    NSMutableAttributedString *details = [[NSMutableAttributedString alloc] init];
    [details appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", self.user.nickName]
                                                                    attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.]}]];
    
    NSMutableString *detailsExceptNickName = [NSMutableString string];
    if (self.user.ageDescription.length > 0) {
        ++numberOfLines;
        [detailsExceptNickName appendFormat:@"\n年龄：%@", self.user.ageDescription];
    }
    if (self.user.heightDescription.length > 0) {
        ++numberOfLines;
        [detailsExceptNickName appendFormat:@"\n身高：%@", self.user.heightDescription];
    }
    if (self.user.cupDescription.length > 0) {
        ++numberOfLines;
        [detailsExceptNickName appendFormat:@"\n罩杯：%@", self.user.cupDescription];
    }
    if (self.user.purpose.length > 0) {
        numberOfLines += 2;
        [detailsExceptNickName appendFormat:@"\n交友目的：%@", self.user.purpose];
    }
    
    if (detailsExceptNickName.length > 0) {
        [details appendAttributedString:[[NSAttributedString alloc] initWithString:detailsExceptNickName attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.],
                                                                                                                      NSForegroundColorAttributeName:[UIColor grayColor]}]];
        
        NSMutableParagraphStyle *nickNameParaStyle = [[NSMutableParagraphStyle alloc] init];;
        nickNameParaStyle.paragraphSpacing = 5;
        [details addAttribute:NSParagraphStyleAttributeName value:nickNameParaStyle range:NSMakeRange(0, details.length-detailsExceptNickName.length+1)];
        
        NSMutableParagraphStyle *infoParaStyle = [[NSMutableParagraphStyle alloc] init];;
        infoParaStyle.paragraphSpacing = 2;
        [details addAttribute:NSParagraphStyleAttributeName value:infoParaStyle range:NSMakeRange(details.length-detailsExceptNickName.length, detailsExceptNickName.length)];
    }
    
    _detailLabel.attributedText = details;
    _detailLabel.numberOfLines = numberOfLines;
    
    if (!_likeButton) {
        @weakify(self);
        _likeButton = [[YPBLikeButton alloc] initWithUserInteractionEnabled:YES];
        _likeButton.layer.cornerRadius = 5;
        _likeButton.layer.masksToBounds = YES;
        [_likeButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_likeButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [_likeButton bk_addEventHandler:^(id sender) {
            @strongify(self);
            [sender beginLoading];
            if (self.greetAction) {
                self.greetAction(sender);
            } else {
                [sender endLoading];
            }
        } forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_likeButton];
        {
            [_likeButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self).offset(-15);
                make.top.equalTo(self).offset(15);
                make.width.equalTo(self).multipliedBy(0.1);
                make.height.equalTo(_likeButton.mas_width).multipliedBy(1.2);
            }];
        }
    }
    _likeButton.selected = self.user.isGreet;
    _likeButton.numberOfLikes = self.user.receiveGreetCount.unsignedIntegerValue;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _avatarImageView.layer.cornerRadius = CGRectGetHeight(_avatarImageView.frame) / 2;
}

- (void)hide {
    if (self.superview) {
        [UIView animateWithDuration:0.3 animations:^{
            self.alpha = 0;
            self.frame = CGRectOffset(self.frame, 0, CGRectGetHeight(self.frame));
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
            _isShown = NO;
        }];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"isGreet"]) {
        NSNumber *newValue = [change objectForKey:NSKeyValueChangeNewKey];
        _likeButton.selected = newValue.boolValue;
    } else if ([keyPath isEqualToString:@"receiveGreetCount"]) {
        NSNumber *newValue = [change objectForKey:NSKeyValueChangeNewKey];
        _likeButton.numberOfLikes = newValue.unsignedIntegerValue;
    }
}
@end
