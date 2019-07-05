//
//  QLPopView.h
//  QLCommonUtils
//
//  Created by Paramita on 2018/2/11.
//  Copyright © 2018年 Paramita. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QLPopViewItemProtocol.h"

typedef NS_ENUM(NSInteger,QLPopDirection) {
    QLPop_Direction_Down      = 1, ///< default
    QLPop_Direction_Up          = 2,

};

typedef void(^QLPopViewBlock)(NSInteger index);

@interface QLPopView : UIView {
    
    UIView *_containerView;
    UIView *_contentView;
    /// pop dirction
    QLPopDirection _popDirection;
}

/// poper arrow size ,default is (11.0,9.0)
@property (nonatomic, assign) CGSize arrowSize;

/// the contentview inset off self default is (4.0,4.0,4.0,4.0)
@property (nonatomic,assign) UIEdgeInsets contentInsets;

/// Decide the nearest edge between the containerView's border and popover, default is 4.0
@property (nonatomic, assign) CGFloat sideEdge;

@property (nonatomic, strong) UIColor *contentColor;

/// use spring animation  ios8 above default is YES
@property (nonatomic,assign) BOOL animationSpring;


@property (nonatomic, copy) dispatch_block_t didShowHandler;
@property (nonatomic, copy) dispatch_block_t didDismissHandler;

/// mark the view is showed
@property (assign, nonatomic) BOOL showed;

/// mark if show the triangle arrow. default is yes
@property (nonatomic,assign) BOOL needTriangleArrow;

+ (instancetype)sharePopView;

/// init method ,This is for subclasses,you do not need to call it
- (void)commonInit;
/**
 pop 一个view
 
 @param point 在界面的哪个点中pop出来
 @param direction 指定pop的方向
 @param contentView 指定pop的内容
 @param containerView 指定pop的容器 即superview
 */
- (void)showAtPoint:(CGPoint)point
           dirction:(QLPopDirection)direction
        contentView:(UIView *)contentView
      containerView:(UIView *)containerView;

- (void)showAtView:(UIView *)atView contentView:(UIView *)contentView containerView:(UIView *)containerView ;
- (void)showAtView:(UIView *)atView contentView:(UIView *)contentView;
- (void)dismiss ;

@end
