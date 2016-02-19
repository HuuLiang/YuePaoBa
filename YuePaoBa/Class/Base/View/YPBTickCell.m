//
//  YPBTickCell.m
//  YuePaoBa
//
//  Created by Sean Yue on 16/2/19.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "YPBTickCell.h"

@interface YPBTickCell ()
@property (nonatomic,retain) UIImageView *tickImageView;
@end

@implementation YPBTickCell

- (instancetype)init {
    self = [super init];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.textLabel.font = [UIFont systemFontOfSize:14.];
    }
    return self;
}

- (UIImageView *)tickImageView {
    if (_tickImageView) {
        return _tickImageView;
    }
    
    UIImage *image = [UIImage imageNamed:@"tick_icon"];
    _tickImageView = [[UIImageView alloc] initWithImage:image];
    [self addSubview:_tickImageView];
    {
        [_tickImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.right.equalTo(self).offset(-15);
            make.height.equalTo(self).dividedBy(4);
            make.width.equalTo(_tickImageView.mas_height).multipliedBy(image.size.width/image.size.height);
        }];
    }
    return _tickImageView;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.textLabel.text = title;
}

- (void)setTicked:(BOOL)ticked {
    _ticked = ticked;
    
    if (ticked) {
        self.tickImageView.hidden = NO;
    } else {
        if (_tickImageView) {
            _tickImageView.hidden = YES;
        }
    }
}
@end
