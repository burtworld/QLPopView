//
//  QLPopView.m
//  QLCommonUtils
//
//  Created by Paramita on 2018/2/11.
//  Copyright © 2018年 Paramita. All rights reserved.
//

#import "QLPopView.h"
//#import "QLHJAPPManager.h"
//
//#import "NSString+QLFunctions.h"
//#import "UIColor+QLColor.h"
//#import "Masonry.h"


#define DEGREES_TO_RADIANS(degrees) ((3.14159265359 * degrees) / 180)


@interface QLPopView()

@property (nonatomic,strong) UIControl *maskView;;

@property (nonatomic,assign) CGPoint arrowShowPoint;

@end

@implementation QLPopView {
    
    CGPoint _showPoint;
    CGPoint _trianglePeak;
    CGFloat _betweenAtViewAndArrowHeight;
}

+ (instancetype)sharePopView {
    static QLPopView *popView = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        
        popView = [[[self class] alloc] init];
        
    });
    return popView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self commonInit];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        
        [self commonInit];
    }
    return self;
}


/// 通常初始化
- (void)commonInit {

    self.arrowSize = CGSizeMake(11.0, 9.0);
    if (@available(iOS 8.0, *)) {
        self.animationSpring = YES;
    }
    self.sideEdge = 4.0f;
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 5.0f;
    self.clipsToBounds = YES;
    self.contentInsets = UIEdgeInsetsMake(4, 4, 4, 4);
    _betweenAtViewAndArrowHeight = 4.0;
    self.needTriangleArrow = YES;
}


#pragma mark - Getter and Setter
- (void)setBackgroundColor:(UIColor *)backgroundColor {
    [super setBackgroundColor:[UIColor clearColor]];
    self.contentColor = backgroundColor;
}

- (void)setNeedTriangleArrow:(BOOL)needTriangleArrow {
    _needTriangleArrow = needTriangleArrow;
    if (needTriangleArrow) {
        self.arrowSize = CGSizeMake(11.0, 9.0);
    }else{
        self.arrowSize = CGSizeMake(0, 0);
    }
    [self setNeedsDisplay];
}

- (UIControl *)maskView {
    if (!_maskView) {
        _maskView = [UIControl new];
        _maskView.backgroundColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.3];
        [_maskView addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchDown];
    }
    
    return _maskView;
}


- (void)setup {
    /// 计算自身的frame
    CGRect frame = _contentView.frame;
    frame.size.height += (self.arrowSize.height + self.contentInsets.top + self.contentInsets.bottom);
    frame.size.width += (self.contentInsets.left + self.contentInsets.right);
    CGFloat frameMidx = self.arrowShowPoint.x - CGRectGetWidth(frame) * 0.5;
    frame.origin.x = frameMidx;
    CGFloat sideEdge = 0.0;
    
    /// 超出边界的情况进行左移
    if (CGRectGetWidth(frame) < CGRectGetWidth(_containerView.frame)) {
        sideEdge = self.sideEdge;
    }
    CGFloat outerSideEdge = CGRectGetMaxX(frame) - CGRectGetWidth(_containerView.bounds);
    if (outerSideEdge > 0) {
        frame.origin.x -= (outerSideEdge + sideEdge);
    } else {
        if (CGRectGetMinX(frame) < 0) {
            frame.origin.x += ABS(CGRectGetMinX(frame)) + sideEdge;
        }
    }
    
    self.frame = frame;
    /// 计算锚点
    CGPoint arrowPoint = [_containerView convertPoint:self.arrowShowPoint toView:self];
    CGPoint anchorPoint;
    switch (_popDirection) {
        case QLPop_Direction_Down: {
            frame.origin.y = self.arrowShowPoint.y;
            anchorPoint = CGPointMake(arrowPoint.x / CGRectGetWidth(frame), 0);
        } break;
        case QLPop_Direction_Up: {
            frame.origin.y = self.arrowShowPoint.y - CGRectGetHeight(frame) - self.arrowSize.height;
            anchorPoint = CGPointMake(arrowPoint.x / CGRectGetWidth(frame), 1);
        } break;
    }
    CGPoint lastAnchor = self.layer.anchorPoint;
    self.layer.anchorPoint = anchorPoint;
    self.layer.position = CGPointMake(
                                      self.layer.position.x + (anchorPoint.x - lastAnchor.x) * self.layer.bounds.size.width,
                                      self.layer.position.y + (anchorPoint.y - lastAnchor.y) * self.layer.bounds.size.height
                                      );
    self.frame = frame;
}


- (void)show {
    [self setup];
    CGRect contentViewFrame = _contentView.frame;
    CGFloat originY = 0.0;
    if (_popDirection == QLPop_Direction_Down) {
        originY = self.arrowSize.height;
    }
    
    contentViewFrame.origin.x = self.contentInsets.left;
    contentViewFrame.origin.y = originY + self.contentInsets.top;
    _contentView.frame = contentViewFrame;
    [self addSubview:_contentView];
    
    [_containerView addSubview:self];
    self.transform = CGAffineTransformMakeScale(0.0, 0.0);
    if (self.animationSpring) {
        [UIView animateWithDuration:0.25
                              delay:0
             usingSpringWithDamping:0.7
              initialSpringVelocity:3
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.transform = CGAffineTransformIdentity;
                         }
                         completion:^(BOOL finished) {
                             self.showed = YES;
                             if (self.didShowHandler) {
                                 self.didShowHandler();
                             }
                         }
         ];
    } else {
        [UIView animateWithDuration:0.25
                              delay:0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.transform = CGAffineTransformIdentity;
                         }
                         completion:^(BOOL finished) {
                             self.showed = YES;
                             if (self.didShowHandler) {
                                 self.didShowHandler();
                             }
                         }];
    }
}


/// dismiss event
- (void)dismiss {
    if (self.superview) {
        [UIView animateWithDuration:0.25
                              delay:0.0
                            options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.transform = CGAffineTransformMakeScale(0.0001, 0.0001);
                         }
                         completion:^(BOOL finished) {
                             self.transform = CGAffineTransformIdentity;
                             [self->_contentView removeFromSuperview];
                             [self.maskView removeFromSuperview];
                             [self removeFromSuperview];
                             self.showed = NO;
                             if (self.didDismissHandler) {
                                 self.didDismissHandler();
                             }
                         }];
    }
}







#pragma mark - Public Method

- (void)showAtPoint:(CGPoint)point
           dirction:(QLPopDirection)direction
        contentView:(UIView *)contentView
      containerView:(UIView *)containerView {
    
    if (containerView == nil) {
        containerView = [UIApplication sharedApplication].keyWindow.rootViewController.view;
    }
    CGFloat contentWidth = CGRectGetWidth(contentView.bounds);
    CGFloat contentHeight = CGRectGetHeight(contentView.bounds);
    CGFloat containerWidth = CGRectGetWidth(containerView.bounds);
    CGFloat containerHeight = CGRectGetHeight(containerView.bounds);
    NSAssert(contentWidth > 0 && contentHeight > 0,
             @"QLPopover contentView bounds.size should not be zero");
    NSAssert(containerWidth > 0 && containerHeight > 0,
             @"QLPopover containerView bounds.size should not be zero");
    NSAssert(containerWidth >= (contentWidth + self.contentInsets.left + self.contentInsets.right),
             @"QLPopover containerView width %f should be wider than contentViewWidth %f & "
             @"contentInset %@",
             containerWidth, contentWidth, NSStringFromUIEdgeInsets(self.contentInsets));
    
    _contentView = contentView;
    
    _containerView = containerView;
    
    _popDirection = direction;
    self.arrowShowPoint = point;
    self.maskView.frame = _containerView.bounds;
    [_containerView addSubview:self.maskView];
    [self show];
}

- (void)showAtView:(UIView *)atView contentView:(UIView *)contentView containerView:(UIView *)containerView {
    CGFloat contentViewHeight = CGRectGetHeight(contentView.bounds);
    CGRect atViewFrame = [containerView convertRect:atView.frame toView:containerView];
    
    /// 判断弹出方向
    BOOL upCanContain = CGRectGetMinY(atViewFrame) >= contentViewHeight;
    BOOL downCanContain = (CGRectGetHeight(containerView.bounds) -  CGRectGetMaxY(atViewFrame)) >= contentViewHeight;
    NSAssert((upCanContain || downCanContain),
             @"QLPopover no place for the popover show, check atView frame %@ "
             @"check contentView bounds %@ and containerView's bounds %@",
             NSStringFromCGRect(atViewFrame), NSStringFromCGRect(contentView.bounds),
             NSStringFromCGRect(containerView.bounds));
    CGPoint atPoint = CGPointMake(CGRectGetMidX(atViewFrame), 0);
    QLPopDirection popDirction;
    if (upCanContain) {
        popDirction = QLPop_Direction_Up;
        atPoint.y = CGRectGetMinY(atViewFrame);
    } else {
        popDirction = QLPop_Direction_Down;
        atPoint.y = CGRectGetMaxY(atViewFrame);
    }
    if (upCanContain && downCanContain) {
        CGFloat upHeight = CGRectGetMinY(atViewFrame);
        CGFloat downHeight = CGRectGetHeight(containerView.bounds) - CGRectGetMaxY(atViewFrame);
        BOOL useUp = upHeight > downHeight;
        
        // except you set outsider
        if (popDirction != 0) {
            useUp = popDirction == QLPop_Direction_Up ? YES : NO;
        }
        if (useUp) {
            popDirction = QLPop_Direction_Up;
            atPoint.y = CGRectGetMinY(atViewFrame);
        } else {
            popDirction = QLPop_Direction_Down;
            atPoint.y = CGRectGetMaxY(atViewFrame);
        }
    }
    [self showAtPoint:atPoint dirction:popDirction contentView:contentView containerView:containerView];
}

- (void)showAtView:(UIView *)atView contentView:(UIView *)contentView {
    [self showAtView:atView contentView:contentView containerView:[UIApplication sharedApplication].keyWindow.rootViewController.view];
}

#pragma mark 绘制三角形
- (void)drawRect:(CGRect)rect {
    if (!self.needTriangleArrow) {
        return;
    }
    UIBezierPath *arrow = [[UIBezierPath alloc] init];
    UIColor *contentColor = self.contentColor;
    // the point in the ourself view coordinator
    CGPoint arrowPoint = [_containerView convertPoint:self.arrowShowPoint toView:self];
    CGSize arrowSize = self.arrowSize;
    CGFloat cornerRadius = 3.0f;
    CGSize size = self.bounds.size;
    
    switch (_popDirection) {
        case QLPop_Direction_Down: {
            [arrow moveToPoint:CGPointMake(arrowPoint.x, 0)];
            [arrow
             addLineToPoint:CGPointMake(arrowPoint.x + arrowSize.width * 0.5, arrowSize.height)];
            [arrow addLineToPoint:CGPointMake(size.width - cornerRadius, arrowSize.height)];
            [arrow addArcWithCenter:CGPointMake(size.width - cornerRadius,
                                                arrowSize.height + cornerRadius)
                             radius:cornerRadius
                         startAngle:DEGREES_TO_RADIANS(270.0)
                           endAngle:DEGREES_TO_RADIANS(0)
                          clockwise:YES];
            [arrow addLineToPoint:CGPointMake(size.width, size.height - cornerRadius)];
            [arrow
             addArcWithCenter:CGPointMake(size.width - cornerRadius, size.height - cornerRadius)
             radius:cornerRadius
             startAngle:DEGREES_TO_RADIANS(0)
             endAngle:DEGREES_TO_RADIANS(90.0)
             clockwise:YES];
            [arrow addLineToPoint:CGPointMake(0, size.height)];
            [arrow addArcWithCenter:CGPointMake(cornerRadius, size.height - cornerRadius)
                             radius:cornerRadius
                         startAngle:DEGREES_TO_RADIANS(90)
                           endAngle:DEGREES_TO_RADIANS(180.0)
                          clockwise:YES];
            [arrow addLineToPoint:CGPointMake(0, arrowSize.height + cornerRadius)];
            [arrow addArcWithCenter:CGPointMake(cornerRadius, arrowSize.height + cornerRadius)
                             radius:cornerRadius
                         startAngle:DEGREES_TO_RADIANS(180.0)
                           endAngle:DEGREES_TO_RADIANS(270)
                          clockwise:YES];
            [arrow
             addLineToPoint:CGPointMake(arrowPoint.x - arrowSize.width * 0.5, arrowSize.height)];
        } break;
        case QLPop_Direction_Up: {
            [arrow moveToPoint:CGPointMake(arrowPoint.x, size.height)];
            [arrow addLineToPoint:CGPointMake(arrowPoint.x - arrowSize.width * 0.5,
                                              size.height - arrowSize.height)];
            [arrow addLineToPoint:CGPointMake(cornerRadius, size.height - arrowSize.height)];
            [arrow addArcWithCenter:CGPointMake(cornerRadius,
                                                size.height - arrowSize.height - cornerRadius)
                             radius:cornerRadius
                         startAngle:DEGREES_TO_RADIANS(90.0)
                           endAngle:DEGREES_TO_RADIANS(180.0)
                          clockwise:YES];
            [arrow addLineToPoint:CGPointMake(0, cornerRadius)];
            [arrow addArcWithCenter:CGPointMake(cornerRadius, cornerRadius)
                             radius:cornerRadius
                         startAngle:DEGREES_TO_RADIANS(180.0)
                           endAngle:DEGREES_TO_RADIANS(270.0)
                          clockwise:YES];
            [arrow addLineToPoint:CGPointMake(size.width - cornerRadius, 0)];
            [arrow addArcWithCenter:CGPointMake(size.width - cornerRadius, cornerRadius)
                             radius:cornerRadius
                         startAngle:DEGREES_TO_RADIANS(270.0)
                           endAngle:DEGREES_TO_RADIANS(0)
                          clockwise:YES];
            [arrow addLineToPoint:CGPointMake(size.width,
                                              size.height - arrowSize.height - cornerRadius)];
            [arrow addArcWithCenter:CGPointMake(size.width - cornerRadius,
                                                size.height - arrowSize.height - cornerRadius)
                             radius:cornerRadius
                         startAngle:DEGREES_TO_RADIANS(0)
                           endAngle:DEGREES_TO_RADIANS(90.0)
                          clockwise:YES];
            [arrow addLineToPoint:CGPointMake(arrowPoint.x + arrowSize.width * 0.5,
                                              size.height - arrowSize.height)];
        } break;
    }
    [contentColor setFill];
    [arrow fill];
}



@end
