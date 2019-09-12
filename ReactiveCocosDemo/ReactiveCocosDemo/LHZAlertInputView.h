//
//  LHZAlertInputView.h
//  ReactiveCocosDemo
//
//  Created by mac on 2019/9/12.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^LHZAlertInputViewResultBlock)(NSString * str);
typedef NSString *_Nullable(^LHZAlertInputViewSiftBlock)(NSString * str);

@interface LHZAlertInputView : UIView

+ (LHZAlertInputView *)alertInputViewWithTitle:(NSString *)title placeholder:(NSString *)placeholder cancelBtnTitle:(NSString *)cancelTitle sureBtnTitles:(NSString *)sureBtnTitle ;

/**
 显示
 @param siftBlock 文字筛选 需返回错误提示语，没提示语表示验证通过
 @param resultBlock 结果
 */
- (void)showInView:(UIView *)showView textSiftBlock:(LHZAlertInputViewSiftBlock)siftBlock resultBlock:(LHZAlertInputViewResultBlock)resultBlock ;

@end

NS_ASSUME_NONNULL_END
