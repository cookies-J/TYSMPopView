//
//  TYSMPopView.m
//  QLXIM
//
//  Created by doule on 31/8/2020.
//  Copyright © 2020 萧俊超. All rights reserved.
//


#import "TYSMPopView.h"
#import "UIView+JCCircular.h"

@interface TYSMPopView ()
@property (nonatomic, strong) NSArray <NSString *> *items;
@property (nonatomic, strong) NSArray <UIButton *> *titleButtons;
@property (nonatomic, strong) NSString *leftTitle;
@property (nonatomic, strong) NSString *rightTitle;
@property (nonatomic, strong) NSString *dismissTitle;
@property (nonatomic, copy) void(^clickBlock)(TYSMButtonType type);
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *backgroundView;
@end

@implementation TYSMPopView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (instancetype)init {
    if (self = [super init]) {
        self.backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [self.backgroundView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)]];
        self.backgroundView.backgroundColor = COLOR_HEX(0x999999);
        self.backgroundView.alpha = 0;
        
        self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
        
        [self addSubview:self.backgroundView];
        [self addSubview:self.contentView];
    }
    return self;
}

- (instancetype)initWithLeftBtnTitle:(NSString *)leftTitle RightBtnTitle:(NSString *)rightTitle items:(NSArray<NSString *> *)items handleClickBlock:(void(^)(TYSMButtonType type))clickBlock {
    if (self = [self init]) {
        
        self.leftTitle = leftTitle;
        self.rightTitle = rightTitle;
        
        [self setTopButtonFrame];
        self.items = items;
        self.clickBlock = clickBlock;
    }
    return self;
}

- (instancetype)initWithItems:(NSArray<NSString *> *)items dismissTitle:(NSString *)dismissTitle handleClickBlock:(void (^)(TYSMButtonType))clickBlock {
    if (self = [self init]) {
        self.items = items;
        self.dismissTitle = dismissTitle;
        self.clickBlock = clickBlock;
        [self setMiddleButtonFrame];
        [self setBottomButtonFrame];
        [self setLine];
    }
    return self;
}

- (UIButton *)createButtonWithTitle:(NSString *)title tag:(TYSMButtonType)tag{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:COLOR_HEX(0x333333) forState:UIControlStateNormal];
    [button setTitleColor:COLOR_HEX(0xFA8D00) forState:UIControlStateSelected];
    [button addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = tag;
    return button;
}

- (void)buttonPress:(UIButton *)button {
    self.clickBlock == nil ? : self.clickBlock((TYSMButtonType)button.tag);
}

// 加载顶部左右
- (void)setTopButtonFrame {
    self.contentView.height += 64;

    UIButton *leftButton = [self createButtonWithTitle:self.leftTitle tag:TYSMButtonTypeCancel];
    UIButton *rightButton = [self createButtonWithTitle:self.rightTitle tag:TYSMButtonTypeConfirm];
    rightButton.selected = YES;
    UIView *topView = [[UIView alloc] init];
    [self.contentView addSubview:topView];
    [topView addSubview:leftButton];
    [topView addSubview:rightButton];
    [topView setBackgroundColor:UIColor.whiteColor];
    
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
        make.height.equalTo(@(JCAdaption(64)));
    }];
    
    [leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topView).offset(JCAdaption(20));
        make.centerY.equalTo(topView);
    }];
    
    [rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(topView).offset(- JCAdaption(20));
        make.centerY.equalTo(topView);
    }];
    
    [topView addRoundedCorners:UIRectCornerTopLeft | UIRectCornerTopRight
                     withRadii:CGSizeMake(20, 20) viewRect:self.contentView.bounds];


}

// 加载中间数据 items
- (void)setMiddleButtonFrame {
    CGFloat currentTop = self.contentView.height;
    self.contentView.height += self.items.count * 44;
    UIView *middleView = [[UIView alloc] init];
    
    middleView.backgroundColor = UIColor.whiteColor;
    
    [self.contentView addSubview:middleView];
    
    [middleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(currentTop);
        make.left.right.bottom.equalTo(self.contentView);
    }];
    
    [middleView addRoundedCorners:UIRectCornerTopLeft | UIRectCornerTopRight
                        withRadii:CGSizeMake(20, 20) viewRect:self.contentView.bounds];
    
    for (NSInteger idx = 0; idx < self.items.count; idx ++) {
        
        UIButton *button = [self createButtonWithTitle:self.items[idx] tag:1000 + idx];

        [self.contentView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(middleView).offset(currentTop);
            make.left.right.equalTo(middleView);
            make.height.lessThanOrEqualTo(@(44));
        }];
        currentTop += 44;
    }
}

- (void)setBottomButtonFrame {
    CGFloat currentTop = self.contentView.height;
    self.contentView.height += 64;
    
    UIButton *dismissButton = [self createButtonWithTitle:self.dismissTitle tag:TYSMButtonTypeDismiss];
    dismissButton.backgroundColor = UIColor.whiteColor;
    [self.contentView addSubview:dismissButton];
    [dismissButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(currentTop);
        make.left.right.bottom.equalTo(self.contentView);
    }];
}

- (void)setLine {
    NSInteger lineNum = self.items.count - 1;
    self.contentView.height += lineNum * 0.5;

    lineNum += kStringIsEmpty(self.dismissTitle) ? 0 : 1;
    self.contentView.height += kStringIsEmpty(self.dismissTitle) ? 0 : 5;
    
    for (NSInteger idx = 0; idx < lineNum; idx ++) {

        UIView  *currentItemView = [self.contentView viewWithTag: 1000 +idx];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = COLOR_HEX(0xe6e6e6);
        [self.contentView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(currentItemView.mas_bottom);
            make.left.right.equalTo(currentItemView);
            make.height.equalTo(@(0.5));
        }];
        
        
        UIView *nextItemView = [self.contentView viewWithTag:1000 +idx +1];
        if (nextItemView) {
            [nextItemView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(lineView.mas_bottom);
            }];
        } else if (kStringIsEmpty(self.dismissTitle) == NO) {
            self.contentView.height += 5;

            UIView *lineView = [[UIView alloc] init];
            lineView.backgroundColor = COLOR_HEX(0xf8f8f8);
            [self.contentView addSubview:lineView];
            [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(currentItemView.mas_bottom);
                make.left.right.equalTo(currentItemView);
                make.height.equalTo(@(5));
            }];


            UIView *nextItemView = [self.contentView viewWithTag:TYSMButtonTypeDismiss];
            if (nextItemView) {
                [nextItemView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(lineView.mas_bottom);
                }];
            }
        }
    }

}

#pragma mark - *********** show & dismiss ***********

- (void)showInView:(UIView *)view{
    [view addSubview:self];
    self.frame = view.bounds;
    self.contentView.top = self.height;
    self.hidden = NO;
    [UIView animateWithDuration:.3 animations:^{
        self.backgroundView.alpha = 0.25;
        self.contentView.top = self.height - self.contentView.height;
    } completion:^(BOOL finished) {

    }];
}

- (void)dismiss{
    [UIView animateWithDuration:.3 animations:^{
        self.backgroundView.alpha = 0;
        self.contentView.top = self.height;
    } completion:^(BOOL finished) {
        self.hidden = YES;
        [self removeFromSuperview];
    }];
}

@end
