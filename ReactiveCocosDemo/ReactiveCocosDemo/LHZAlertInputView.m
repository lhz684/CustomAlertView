//
//  LHZAlertInputView.m
//  ReactiveCocosDemo
//
//  Created by mac on 2019/9/12.
//  Copyright © 2019 mac. All rights reserved.
//

#import "LHZAlertInputView.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <Masonry/Masonry.h>

#define RGB(r,g,b) [UIColor colorWithRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:1]
#define RGBA(r,g,b,a) [UIColor colorWithRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:a]

#define ScreenW [UIScreen mainScreen].bounds.size.width
#define ScreenH [UIScreen mainScreen].bounds.size.height

@interface LHZAlertInputView()

@property (nonatomic,strong) UIView * mainView;
@property (nonatomic,strong) UILabel * lbTitle;
@property (nonatomic,strong) UITextField * textField;
@property (nonatomic,strong) UILabel * lbTip;
@property (nonatomic,strong) UIView * btnBgView;
@property (nonatomic,strong) UIButton * btncancel;
@property (nonatomic,strong) UIButton * btnSure;

@property (nonatomic,strong) NSString * titleText;
@property (nonatomic,strong) NSString * placeholderText;
@property (nonatomic, copy) NSString * cancelBtnTitle; ///<
@property (nonatomic,strong) NSString * sureBtnTitle;

@property (nonatomic, copy) LHZAlertInputViewResultBlock resultBlock ; ///< 结果
@property (nonatomic, copy) LHZAlertInputViewSiftBlock siftBlock ; ///< 文字筛选

@end

@implementation LHZAlertInputView

+ (LHZAlertInputView *)alertInputViewWithTitle:(NSString *)title placeholder:(NSString *)placeholder cancelBtnTitle:(NSString *)cancelTitle sureBtnTitles:(NSString *)sureBtnTitle {
    LHZAlertInputView * alertView = [[LHZAlertInputView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    alertView.titleText = title;
    alertView.placeholderText = placeholder;
    alertView.cancelBtnTitle = cancelTitle;
    alertView.sureBtnTitle = sureBtnTitle;
    [alertView createViews];
    return alertView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGBA(51, 51, 51, 0.5);
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.mainView.layer.masksToBounds = YES;
    self.mainView.layer.cornerRadius = 5;
}

#pragma mark - 显示

/**
 显示
 @param siftBlock 文字筛选
 @param resultBlock 结果
 */
- (void)showInView:(UIView *)showView textSiftBlock:(LHZAlertInputViewSiftBlock)siftBlock resultBlock:(LHZAlertInputViewResultBlock)resultBlock {
    for (UIView * view in showView.subviews) {
        if ([view isKindOfClass:[LHZAlertInputView class]]) {
            LHZAlertInputView * alertView = (LHZAlertInputView *)view;
            [alertView hiddenView];
        }
    }
    
    self.resultBlock = resultBlock;
    self.siftBlock = siftBlock;
    
    [showView addSubview:self];
    
    [self needsUpdateConstraints];
    [UIView animateWithDuration:0.25 animations:^{
        [self.mainView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(self.mas_width).multipliedBy(0.7);
            make.centerX.equalTo(self.mas_centerX);
            make.centerY.equalTo(self.mas_centerY);
        }];
        [self layoutIfNeeded];
    }];
    
}

/** 隐藏 */
- (void)hiddenView {
    
    [self needsUpdateConstraints];
    [UIView animateWithDuration:0.25 animations:^{
        [self.mainView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(self.mas_width).multipliedBy(0.7);
            make.centerX.equalTo(self.mas_centerX);
            make.top.equalTo(self.mas_bottom);
        }];
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - create View

- (void)createViews {
    [self addSubview:self.mainView];
    
    [self.mainView addSubview:self.lbTitle];
    [self.mainView addSubview:self.textField];
    [self.mainView addSubview:self.lbTip];
    [self.mainView addSubview:self.btnBgView];
    [self.btnBgView addSubview:self.btncancel];
    [self.btnBgView addSubview:self.btnSure];
    
    [self addLayout];
}

#pragma mark - layout

- (void)addLayout {
    
    [self.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.mas_width).multipliedBy(0.7);
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.mas_bottom);
    }];
    
    
    CGFloat titleTop = self.titleText.length > 0 ? 15 : 0;
    [self.lbTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(titleTop);
    }];
    
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.equalTo(self.lbTitle.mas_bottom).offset(15);
        make.height.mas_equalTo(35);
    }];
    
    [self.lbTip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.equalTo(self.textField.mas_bottom).offset(8);
    }];
    
    [self.btnBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(-0);
        make.top.equalTo(self.textField.mas_bottom).offset(30);
        make.bottom.mas_equalTo(0);
    }];
    
   
    [self.btncancel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(1);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(40);
    }];
    
    [self.btnSure mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.btncancel.mas_right).offset(1);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(1);
        make.height.mas_equalTo(40);
        make.width.equalTo(self.btncancel.mas_width);
    }];
    
}

#pragma mark - 懒加载

- (UIView *)mainView {
    if (!_mainView) {
        _mainView = [[UIView alloc] initWithFrame:CGRectMake(ScreenW / 2.0, ScreenH, 0, 0)];
        _mainView.backgroundColor = RGB(248, 248, 248 );
    }
    return _mainView;
}

- (UIView *)btnBgView {
    if (!_btnBgView) {
        _btnBgView = [[UIView alloc] initWithFrame:CGRectZero];
        _btnBgView.backgroundColor = RGB(153, 153, 153);
    }
    return _btnBgView;
}

- (UILabel *)lbTitle {
    if (!_lbTitle) {
        _lbTitle = [[UILabel alloc] initWithFrame:CGRectZero];
        _lbTitle.textColor =  RGB(51, 51, 51);
        _lbTitle.font = [UIFont systemFontOfSize:17];
        _lbTitle.text = self.titleText;
        _lbTitle.textAlignment = NSTextAlignmentCenter;
    }
    return _lbTitle;
}

- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] initWithFrame:CGRectZero];
        _textField.placeholder = self.placeholderText;
        _textField.backgroundColor = [UIColor whiteColor];
        _textField.textAlignment = NSTextAlignmentCenter;
        _textField.font = [UIFont systemFontOfSize:14];
        @weakify(self);
        [[_textField.rac_textSignal
          map:^id(NSString * text) {
              @strongify(self);
              return self.siftBlock ? self.siftBlock(text) : @"";
          }]
         subscribeNext:^(NSString * tip) {
             self.lbTip.text = tip;
             self.btnSure.enabled = tip.length == 0;
         }];
    }
    return _textField;
}

- (UILabel *)lbTip {
    if (!_lbTip) {
        _lbTip = [[UILabel alloc] initWithFrame:CGRectZero];
        _lbTip.textColor =  RGB(154, 154, 154);
        _lbTip.font = [UIFont systemFontOfSize:12];
        _lbTip.text = @"";
//        _lbTip.textAlignment = NSTextAlignmentCenter;
        _lbTip.numberOfLines = 1;
    }
    return _lbTip;
}

- (UIButton *)btncancel {
    if (!_btncancel) {
        _btncancel = [[UIButton alloc] initWithFrame:CGRectZero];
        [_btncancel setTitle:self.cancelBtnTitle.length > 0 ? self.cancelBtnTitle : @"取消" forState:(UIControlStateNormal)];
        [_btncancel setTitleColor:RGB(102, 102, 102) forState:(UIControlStateNormal)];
        [_btncancel setBackgroundColor:RGB(248, 248, 248 )];
        _btncancel.titleLabel.font = [UIFont systemFontOfSize:15];
        @weakify(self);
        [[_btncancel rac_signalForControlEvents:(UIControlEventTouchUpInside)]
         subscribeNext:^(id value) {
             @strongify(self);
             [self hiddenView];
         }];
    }
    return _btncancel;
}

- (UIButton *)btnSure {
    if (!_btnSure) {
        _btnSure = [[UIButton alloc] initWithFrame:CGRectZero];
        [_btnSure setTitle:self.cancelBtnTitle.length > 0 ? self.sureBtnTitle : @"确定" forState:(UIControlStateNormal)];
        [_btnSure setTitleColor:RGB(102, 102, 102) forState:(UIControlStateNormal)];
        [_btnSure setBackgroundColor:RGB(248, 248, 248 )];
        _btnSure.titleLabel.font = [UIFont systemFontOfSize:15];
        @weakify(self);
        [[_btnSure rac_signalForControlEvents:(UIControlEventTouchUpInside)]
         subscribeNext:^(id value) {
             @strongify(self);
             [self hiddenView];
             if (self.resultBlock) {
                 self.resultBlock(self.textField.text);
             }
         }];
    }
    return _btnSure;
}

@end
