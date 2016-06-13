//
//  MoreOperationView.h
//  Common
//
//  Created by 黄磊 on 16/6/13.
//  Copyright © 2016年 Musjoy. All rights reserved.
//  更多操作界面

#import <UIKit/UIKit.h>

@protocol MoreOperationDelegate <NSObject>

- (void)operationClickWithTag:(NSInteger)aTag;

@end

@interface MoreOperationView : UIView

@property (nonatomic, assign) BOOL isHide;              /**< 是否隐藏 */

// 可配置项
@property (nonatomic, strong) UIColor *bgColor;         ///< 背景色，默认白色
@property (nonatomic, strong) UIColor *borderColor;     ///< 边框颜色，默认为nil
@property (nonatomic, assign) CGFloat *borderWitdh;     ///< 边框大小，默认为0.5
@property (nonatomic, assign) CGFloat hPadding;         ///< 水平方向偏移，默认0
@property (nonatomic, assign) CGFloat vPadding;         ///< 垂直方向偏移，默认0
@property (nonatomic, strong) UIView *sourceView;       ///< 依赖的View，默认为nil

@property (nonatomic, assign) id<MoreOperationDelegate> delegate;

/** 用按钮列表初始化 {"icon":"","title":"","tag":1} */
- (void)refreshWithButtons:(NSArray *)arrBtns;

/** 显示 */
- (void)show;
/** 隐藏，可能出现为隐藏情况 */
- (void)hide;
/** 强制隐藏 */
- (void)hideForce:(BOOL)isForce;


@end