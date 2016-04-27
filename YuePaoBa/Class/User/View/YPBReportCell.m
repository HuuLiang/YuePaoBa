//
//  YPBReportCell.m
//  YuePaoBa
//
//  Created by Liang on 16/4/25.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "YPBReportCell.h"

@interface YPBReportCell ()
@property (nonatomic,retain) UIImageView *tickImageView;
@end

@implementation YPBReportCell

- (instancetype)initWithTitle:(NSString *)title {
    self = [self init];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.textLabel.font = [UIFont systemFontOfSize:14.];
        
        self.title = title;
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.textLabel.text = title;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    if (selected) {
        self.tickImageView.hidden = NO;
    } else if (_tickImageView) {
        _tickImageView.hidden = YES;
    }
}

- (UIImageView *)tickImageView {
    if (_tickImageView) {
        return _tickImageView;
    }
    
    UIImage *tickImage = [UIImage imageNamed:@"tick_icon"];
    _tickImageView = [[UIImageView alloc] initWithImage:tickImage];
    [self addSubview:_tickImageView];
    {
        [_tickImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.right.equalTo(self).offset(-15);
            make.height.equalTo(self).dividedBy(4);
            make.width.equalTo(_tickImageView.mas_height).multipliedBy(tickImage.size.width/tickImage.size.height);
        }];
    }
    return _tickImageView;
}


@end
