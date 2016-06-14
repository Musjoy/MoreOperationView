//
//  MoreOperationView.m
//  Common
//
//  Created by 黄磊 on 16/6/13.
//  Copyright © 2016年 Musjoy. All rights reserved.
//

#import "MoreOperationView.h"


#define TOP_PADDING 0
#define RIGHT_PADDING 10

@interface MoreOperationView ()

@property (nonatomic, strong) UIView *viewBg;
@property (nonatomic, strong) UIView *viewContent;
@property (nonatomic, strong) UIView *viewBtns;

// viewContent约束
@property (nonatomic, strong) NSLayoutConstraint *lytH;
@property (nonatomic, strong) NSLayoutConstraint *lytV;

// viewBtns约束
@property (nonatomic, strong) NSLayoutConstraint *lytLeft;
@property (nonatomic, strong) NSLayoutConstraint *lytRight;
@property (nonatomic, strong) NSLayoutConstraint *lytTop;
@property (nonatomic, strong) NSLayoutConstraint *lytMove;          ///< 用于实现动画的lyt


@end

@implementation MoreOperationView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self settingView];
    }
    return self;
}

- (void)awakeFromNib
{
    [self settingView];
}

- (void)settingView
{
    if (_viewBg == nil) {
        _viewBg = [[UIView alloc] init];
        [_viewBg setBackgroundColor:[UIColor clearColor]];
        [_viewBg setAlpha:0];
        [_viewBg setFrame:self.bounds];
        [_viewBg setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBlank)];
        [tapGesture setNumberOfTapsRequired:1];
        [_viewBg addGestureRecognizer:tapGesture];
        [_viewBg setUserInteractionEnabled:YES];
        [self addSubview:_viewBg];
    }
    
    _isHide = YES;
    _hPadding = 0;
    _vPadding = 0;
    _bgColor = [UIColor whiteColor];
    _borderColor = [UIColor lightGrayColor];
    self.contentMode = UIViewContentModeTopRight;
    self.hidden = YES;
}

#pragma mark - Set & Get

- (void)setContentMode:(UIViewContentMode)contentMode
{
    if (contentMode < UIViewContentModeTopLeft
        && contentMode != UIViewContentModeTop
        && contentMode != UIViewContentModeBottom) {
        LogError(@"This content mode {%d} is not supoort!", (int)contentMode);
        return;
    }
    if (self.contentMode == contentMode) {
        return;
    }
    super.contentMode = contentMode;
    if (_viewContent) {
        
        [self relocateContentView];
    }
}


- (void)setSourceView:(UIView *)sourceView
{
    if (_sourceView = sourceView) {
        return;
    }
    _sourceView = sourceView;
    [self relocateContentView];
}

#pragma mark - Overwrite

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    [self relocateContentView];
}

#pragma mark - Action

- (void)buttonClick:(UIButton *)aBtn
{
    if (_delegate && [_delegate respondsToSelector:@selector(operationClickWithTag:)]) {
        [_delegate operationClickWithTag:aBtn.tag];
    }
    [self hide];
}

- (void)tapBlank
{
    [self hide];
}

#pragma mark - Public

- (void)refreshWithButtons:(NSArray *)arrBtns
{
    if (_viewContent == nil) {
        _viewContent = [[UIView alloc] init];
        _viewContent.backgroundColor = [UIColor clearColor];
        [_viewContent setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_viewContent setClipsToBounds:YES];
        [self addSubview:_viewContent];
        [self relocateContentView];
        
    }
    if (_viewBtns == nil) {
        _viewBtns = [[UIView alloc] init];
        _viewBtns.backgroundColor = _bgColor;
        CGFloat padding = 0;
        if (_borderColor) {
            _viewBtns.layer.borderColor = _borderColor.CGColor;
            _viewBtns.layer.borderWidth = 0.5;
            padding = 1;
        }
        [_viewBtns setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_viewContent addSubview:_viewBtns];
        
        // 水平方向
        _lytLeft = [NSLayoutConstraint constraintWithItem:_viewBtns attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_viewContent attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
        _lytRight = [NSLayoutConstraint constraintWithItem:_viewBtns attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:_viewContent attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
        
        // 创建垂直依赖
        _lytTop = [NSLayoutConstraint constraintWithItem:_viewBtns attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_viewContent attribute:NSLayoutAttributeTop multiplier:1 constant:padding];
        _lytTop.priority = UILayoutPriorityDefaultLow;
        if (self.contentMode == UIViewContentModeTopLeft
            || self.contentMode == UIViewContentModeTopRight
            || self.contentMode == UIViewContentModeTop) {
            _lytMove = [NSLayoutConstraint constraintWithItem:_viewBtns attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_viewContent attribute:NSLayoutAttributeTop multiplier:1 constant:padding];
            _lytTop.constant = -padding;
        } else {
            _lytMove = [NSLayoutConstraint constraintWithItem:_viewBtns attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_viewContent attribute:NSLayoutAttributeBottom multiplier:1 constant:padding];
        }
        
        // 添加大小约束
//        NSLayoutConstraint *lytWidth = [NSLayoutConstraint constraintWithItem:_viewBtns attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_viewContent attribute:NSLayoutAttributeWidth multiplier:1 constant:0];
        NSLayoutConstraint *lytHeight = [NSLayoutConstraint constraintWithItem:_viewBtns attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:_viewContent attribute:NSLayoutAttributeHeight multiplier:1 constant:0];
        
        [_viewContent addConstraints:@[_lytLeft, _lytRight, _lytTop, lytHeight]];
        
    } else {
        for (UIView *aView in _viewBtns.subviews) {
            [aView removeFromSuperview];
        }
    }

    // 在_viewBtns左上角添加参照view，便于btn排版
    UIView *viewAjust = [[UIView alloc] initWithFrame:CGRectZero];
    [viewAjust setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_viewBtns addSubview:viewAjust];

    NSDictionary *divViewAjust = NSDictionaryOfVariableBindings(viewAjust);
    NSString *vflH = @"H:|[viewAjust(0)]";
    [_viewBtns addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vflH options:0 metrics:nil views:divViewAjust]];
    NSString *vflV = @"V:|[viewAjust(0)]";
    [_viewBtns addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vflV options:0 metrics:nil views:divViewAjust]];
    
    UIView *topView = viewAjust;
    UIView *lastBtn = nil;
    
    for (NSInteger i=0, len=arrBtns.count; i<len; i++) {
        NSDictionary *aDic = arrBtns[i];
        UIButton *aBtn = [self createButtonWith:aDic];
        NSNumber *tag = aDic[@"tag"];
        if (tag) {
            [aBtn setTag:[tag integerValue]];
        } else {
            [aBtn setTag:i];
        }
        
        [_viewBtns addSubview:aBtn];
        
        // 添加一分割条线
        UIView *viewLine = [[UIView alloc] init];
        [viewLine setBackgroundColor:[UIColor lightGrayColor]];
        [viewLine setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_viewBtns addSubview:viewLine];
        NSDictionary *dicViews = NSDictionaryOfVariableBindings(aBtn, topView, viewLine);
        float lineHeight = 0.5;
        if (i == 0) {
            lineHeight = 0;
        }
        NSNumber *theLineHeight = [NSNumber numberWithFloat:lineHeight];
        NSDictionary *dicMetric = NSDictionaryOfVariableBindings(theLineHeight);
        
        // viewLine水平边距vfl
        NSString *vfl = @"H:|[viewLine]|";
        NSArray *hConstraintd =[NSLayoutConstraint constraintsWithVisualFormat:vfl options:0 metrics:nil views:dicViews];
        [_viewBtns addConstraints:hConstraintd];
        
        // 水平边距vfl
        NSString *vfl1 = @"H:|[aBtn]|";
        NSArray *hConstraintd1 =[NSLayoutConstraint constraintsWithVisualFormat:vfl1 options:0 metrics:nil views:dicViews];
        [_viewBtns addConstraints:hConstraintd1];
        
        // 垂直边距vfl
        NSString *vfl2 = @"V:[topView][viewLine(theLineHeight)][aBtn]";
        NSArray *vConstraintd = [NSLayoutConstraint constraintsWithVisualFormat:vfl2 options:0 metrics:dicMetric views:dicViews];
        [_viewBtns addConstraints:vConstraintd];
        
        if (lastBtn) {
            [_viewBtns addConstraint:
            [NSLayoutConstraint constraintWithItem:aBtn
                                         attribute:NSLayoutAttributeHeight
                                         relatedBy:NSLayoutRelationEqual
                                            toItem:lastBtn
                                         attribute:NSLayoutAttributeHeight
                                        multiplier:1 constant:0]];
        }
        
        [aBtn layoutIfNeeded];
        lastBtn = aBtn;
        topView = aBtn;
    }
    
    // 处理_viewBtns高度
    [_viewBtns addConstraint:
     [NSLayoutConstraint constraintWithItem:topView
                                  attribute:NSLayoutAttributeBottom
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:_viewBtns
                                  attribute:NSLayoutAttributeBottom
                                 multiplier:1 constant:0]];
    
    [_viewBtns layoutIfNeeded];
    if (_isHide && ![_viewContent.constraints containsObject:_lytMove]) {
        [_viewContent addConstraint:_lytMove];
    }
    
}


- (void)show
{
    if (self.superview == nil) {
        return;
    }
    if (!_isHide) {
        return;
    }
    [self.superview bringSubviewToFront:self];
    _isHide = NO;
    self.hidden = NO;
    [self layoutIfNeeded];
    [UIView animateWithDuration:DEFAULT_ANIMATE_DURATION animations:^{
        [_viewContent removeConstraint:_lytMove];
        [_viewBg setAlpha:0.5];
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
    
}

- (void)hide
{
    [self hideForce:NO];
}

- (void)hideForce:(BOOL)isForce
{
    if (self.superview == nil) {
        return;
    }
    if (_isHide) {
        return;
    }
    [self.superview bringSubviewToFront:self];
    _isHide = YES;
    [self layoutIfNeeded];
    [UIView animateWithDuration:DEFAULT_ANIMATE_DURATION animations:^{
        [_viewContent addConstraint:_lytMove];
        [_viewBg setAlpha:0];
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (finished || isForce) {
            self.hidden = YES;
        }
    }];
}

#pragma mark - Private

- (void)relocateContentView
{
    UIView *superView = self.superview;
    if (superView == nil) {
        return;
    }
    if (_lytH) {
        if ([self.constraints containsObject:_lytH]) {
            [self removeConstraint:_lytH];
        } else {
            if ([superView.constraints containsObject:_lytH]) {
                [superView removeConstraint:_lytH];
            }
        }
        _lytH = nil;
    }
    if (_lytV) {
        if ([self.constraints containsObject:_lytV]) {
            [self removeConstraint:_lytV];
        } else {
            if ([superView.constraints containsObject:_lytV]) {
                [superView removeConstraint:_lytV];
            }
        }
        _lytV = nil;
    }
    
    UIView *relyView = self;
    UIView *containerView = self;
    BOOL isReverse = NO;
    if (_sourceView && superView) {
        // 有sourceView依赖
        relyView = _sourceView;
        containerView = superView;
        isReverse = YES;
    }
    // 创建水平依赖
    if (self.contentMode == UIViewContentModeTopLeft
        || self.contentMode == UIViewContentModeBottomLeft) {
        // 左对齐
        _lytH = [NSLayoutConstraint constraintWithItem:_viewContent attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:relyView attribute:NSLayoutAttributeLeft multiplier:1 constant:_hPadding];
    } else if (self.contentMode == UIViewContentModeTopRight
               || self.contentMode == UIViewContentModeBottomRight) {
        _lytH = [NSLayoutConstraint constraintWithItem:_viewContent attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:relyView attribute:NSLayoutAttributeRight multiplier:1 constant:isReverse?(-_hPadding):_hPadding];
    } else {
        _lytH = [NSLayoutConstraint constraintWithItem:_viewContent attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:relyView attribute:NSLayoutAttributeCenterX multiplier:1 constant:_hPadding];
    }
    [containerView addConstraint:_lytH];
    
    // 创建垂直依赖
    if (self.contentMode == UIViewContentModeTopLeft
        || self.contentMode == UIViewContentModeTopRight
        || self.contentMode == UIViewContentModeTop) {
        // 左对齐
        _lytV = [NSLayoutConstraint constraintWithItem:_viewContent attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:relyView attribute:isReverse?NSLayoutAttributeBottom:NSLayoutAttributeTop multiplier:1 constant:_vPadding];
    } else {
        _lytV = [NSLayoutConstraint constraintWithItem:_viewContent attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:relyView attribute:isReverse?NSLayoutAttributeTop:NSLayoutAttributeBottom multiplier:1 constant:_vPadding];
    }
    [containerView addConstraint:_lytV];
    
    
}

- (UIButton *)createButtonWith:(NSDictionary *)aDic
{
    UIButton *aBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [aBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [aBtn setTitleColor:self.tintColor forState:UIControlStateNormal];
//    [aBtn setBackgroundImage:[UIImage createImageWithColor:kAppActiveColor] forState:UIControlStateHighlighted];
    [aBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [aBtn setTranslatesAutoresizingMaskIntoConstraints:NO];
    [aBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    NSString *icon = aDic[@"icon"];
    NSString *title = aDic[@"title"];
    CGFloat insetRight = 10;
    if (icon.length > 0) {
        [aBtn setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
        if (title.length > 0) {
            insetRight += 8;
            [aBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 8, 0, -8)];
        }
    }
    if (title.length > 0) {
        [aBtn setTitle:title forState:UIControlStateNormal];
    }
    [aBtn setContentEdgeInsets:UIEdgeInsetsMake(10, 10, 10, insetRight)];
    
    return aBtn;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
