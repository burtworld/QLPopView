//
//  QLPopTableView.h
//  QLCommonUtils
//
//  Created by paramita on 2018/9/19.
//  Copyright © 2018年 Paramita. All rights reserved.
//

#import "QLPopView.h"
#import "QLPopViewItemProtocol.h"
@interface QLPopTableView : QLPopView
@property (nonatomic,copy) void(^selectBlock)(NSInteger index);
@property (retain, nonatomic) NSArray<id<QLPopViewItemProtocol>>*itemArray;

- (void)showAtView:(UIView *)atView rowHeight:(CGFloat)rowHeight items:(NSArray<id<QLPopViewItemProtocol>>*)itemArray selectBlock:(void(^)(NSInteger index))block;
@end
