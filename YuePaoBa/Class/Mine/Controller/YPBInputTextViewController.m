//
//  YPBInputTextViewController.m
//  YuePaoBa
//
//  Created by Sean Yue on 15/12/24.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import "YPBInputTextViewController.h"
#import <UITextView+Placeholder.h>
#import "YPBTextField.h"

@interface YPBInputTextViewController () <UITextViewDelegate,UITextFieldDelegate>
{
    UITextView *_inputTextView;
    UITextField *_inputTextField;
    
    UILabel *_textLimitLabel;
}
@property (nonatomic,retain) UILabel *noteLabel;
@end

@implementation YPBInputTextViewController

- (instancetype)initWithTextBlock:(BOOL)isTextBlock {
    self = [super init];
    if (self) {
        _isTextBlock = isTextBlock;
        
        if (isTextBlock) {
            _inputTextView = [[UITextView alloc] init];
            _inputTextView.font = [UIFont systemFontOfSize:14.];
            _inputTextView.textColor = kDefaultTextColor;
            _inputTextView.backgroundColor = [UIColor whiteColor];
            _inputTextView.layer.cornerRadius = 4;
            _inputTextView.layer.borderWidth = 0.5;
            _inputTextView.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:1].CGColor;
            _inputTextView.delegate = self;
            [self.view addSubview:_inputTextView];
            {
                [_inputTextView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.view).offset(15);
                    make.top.equalTo(self.view).offset(15);
                    make.right.equalTo(self.view).offset(-15);
                    make.height.mas_equalTo(100);
                }];
            }
        } else {
            _inputTextField = [[YPBTextField alloc] init];
            _inputTextField.delegate = self;
            _inputTextField.returnKeyType = UIReturnKeyDone;
            [self.view addSubview:_inputTextField];
            {
                [_inputTextField mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.view).offset(15);
                    make.right.equalTo(self.view).offset(-15);
                    make.top.equalTo(self.view).offset(15);
                    make.height.mas_equalTo(44);
                }];
            }
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChangeNotification:) name:UITextFieldTextDidChangeNotification object:nil];
        }
        
        
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kDefaultBackgroundColor;
    
    @weakify(self);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"保存"
                                                                                 style:UIBarButtonItemStylePlain
                                                                               handler:^(id sender)
    {
        @strongify(self);
        [self doSave];
    }];
    [self.navigationItem.rightBarButtonItem setTitlePositionAdjustment:UIOffsetMake(-5, 0) forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.rightBarButtonItem.enabled = NO;
}

- (UILabel *)noteLabel {
    if (_noteLabel) {
        return _noteLabel;
    }
    
    _noteLabel = [[UILabel alloc] init];
    _noteLabel.text = self.note;
    _noteLabel.font = [UIFont systemFontOfSize:14.];
    _noteLabel.textColor = [UIColor redColor];
    _noteLabel.numberOfLines = 2;
    _noteLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_noteLabel];
    {
        [_noteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.inputView);
            make.top.equalTo(self.inputView.mas_bottom).offset(10);
        }];
    }
    return _noteLabel;
}

- (UIView *)inputView {
    if (_isTextBlock) {
        return _inputTextView;
    } else {
        return _inputTextField;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (_isTextBlock) {
        [_inputTextView becomeFirstResponder];
    } else {
        [_inputTextField becomeFirstResponder];
    }
}

- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder;
    _inputTextView.placeholder = placeholder;
    _inputTextField.placeholder = placeholder;
}

- (void)setNote:(NSString *)note {
    _note = note;
    self.noteLabel.text = note;
}

- (void)setText:(NSString *)text {
    if (_isTextBlock) {
        _inputTextView.text = text;
    } else {
        _inputTextField.text = text;
    }
    
    self.navigationItem.rightBarButtonItem.enabled = text.length > 0;
}

- (NSString *)text {
    if (_isTextBlock) {
        return _inputTextView.text;
    } else {
        return _inputTextField.text;
    }
}

- (void)setLimitedTextLength:(NSUInteger)limitedTextLength {
    _limitedTextLength = limitedTextLength;
    
    if (limitedTextLength > 0 && !_textLimitLabel) {
        _textLimitLabel = [[UILabel alloc] init];
        _textLimitLabel.text = [NSString stringWithFormat:@"还可以输入%ld个字", limitedTextLength - self.text.length];
        _textLimitLabel.font = [UIFont systemFontOfSize:14.];
        _textLimitLabel.textColor = kDefaultTextColor;
        [self.view addSubview:_textLimitLabel];
        {
            [_textLimitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo([self inputView]);
                make.top.equalTo([self inputView].mas_bottom).offset(10);
            }];
        }
    }
    _textLimitLabel.hidden = limitedTextLength == 0;
}

- (BOOL)doSave {
    if (self.completionHandler) {
        if (self.completionHandler(self.text)) {
            [self.navigationController popViewControllerAnimated:YES];
            return YES;
        }
    } else {
        [self.navigationController popViewControllerAnimated:YES];
        return YES;
    }
    return NO;
}

- (void)doChangeText {
    if (self.limitedTextLength > 0) {
        _textLimitLabel.text = [NSString stringWithFormat:@"还可以输入%ld个字", self.limitedTextLength - self.text.length];
    }
    
    if (self.changeHandler) {
        self.navigationItem.rightBarButtonItem.enabled = self.changeHandler(self.text);
    } else {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)textFieldChangeNotification:(NSNotification *)notification {
    [self doChangeText];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return [self doSave];
}

- (void)textViewDidChange:(UITextView *)textView {
    [self doChangeText];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSUInteger newTextLength = textView.text.length - range.length + text.length;
    if (self.limitedTextLength > 0 && newTextLength > self.limitedTextLength) {
        return NO;
    }
    return YES;
}
@end
