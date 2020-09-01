//
//  TYSMPopView.h
//  QLXIM
//
//  Created by doule on 31/8/2020.
//  Copyright © 2020 萧俊超. All rights reserved.
//

typedef NS_OPTIONS(NSUInteger, TYSMButtonType) {
    TYSMButtonTypeCancel,
    TYSMButtonTypeConfirm,
    TYSMButtonTypeSexMale,
    TYSMButtonTypeSexFemale,
    TYSMButtonTypeDismiss
};

typedef NS_OPTIONS(NSUInteger, TYSMPopViewType) {
    TYSMPopViewTypeTopLeftRight, // 顶部左右操作
    TYSMPopViewTypeCustom,  // 中间自定义
    TYSMPopViewTypeBottomCancel // 底部取消
};

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TYSMPopView : UIView
- (instancetype)initWithLeftBtnTitle:(NSString *)leftTitle
                        RightBtnTitle:(NSString *)rightTitle
                               items:(NSArray <NSString *> *)items
                    handleClickBlock:(void(^)(TYSMButtonType type))clickBlock;

- (instancetype)initWithItems:(NSArray <NSString *> *)items
                 dismissTitle:(NSString *)dismissTitle
             handleClickBlock:(void(^)(TYSMButtonType type))clickBlock;

- (void)showInView:(UIView *)view;
- (void)dismiss;
@end

NS_ASSUME_NONNULL_END
