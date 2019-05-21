//
//  QLPopTableView.m
//  QLCommonUtils
//
//  Created by paramita on 2018/9/19.
//  Copyright © 2018年 Paramita. All rights reserved.
//

#import "QLPopTableView.h"


@interface QLPopTableView()<UITableViewDelegate, UITableViewDataSource> {
    
}
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,assign) CGFloat rowHeight;
@end

@implementation QLPopTableView


- (void)commonInit {
    [super commonInit];
    self.rowHeight = 44.0f;
}

- (CGFloat)calculatorMaxWidth {
    if (!_itemArray.count) {
        return 0;
    }
    
    id<QLPopViewItemProtocol>_item = nil;
    for (id<QLPopViewItemProtocol>item in _itemArray) {
        if (_item == nil) {
            _item = item;
        }else{
            if (_item.itemName.length < item.itemName.length) {
                _item = item;
            }
        }
    }
    CGFloat width = [_item.itemName boundingRectWithSize:CGSizeMake(self.rowHeight, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f]} context:nil].size.width;
    // 加上图片距离与边距
    if (_item.itemImage != nil) {
        width   += 74;
    }else{
        width += 40;
    }
    
    return width;
}

- (void)showAtView:(UIView *)atView rowHeight:(CGFloat)rowHeight items:(NSArray<id<QLPopViewItemProtocol>>*)itemArray selectBlock:(void(^)(NSInteger index))block {
    [self showAtView:atView containerView:[UIApplication sharedApplication].keyWindow.rootViewController.view rowHeight:rowHeight items:itemArray selectBlock:block];
}

- (void)showAtView:(UIView *)atView containerView:(UIView *)containerView rowHeight:(CGFloat)rowHeight items:(NSArray<id<QLPopViewItemProtocol>>*)itemArray selectBlock:(void(^)(NSInteger index))block {
    self.itemArray = itemArray;
    self.selectBlock = block;
    self.rowHeight = rowHeight;
    CGFloat maxWidth = [self calculatorMaxWidth];
    CGFloat height = _itemArray.count *rowHeight;
    self.tableView.frame = CGRectMake(0, 0, maxWidth, height);
    [self showAtView:atView contentView:self.tableView containerView:containerView];
}

- (void)showAtPoint:(CGPoint )point rowHeight:(CGFloat)rowHeight items:(NSArray<id<QLPopViewItemProtocol>>*)itemArray selectBlock:(void(^)(NSInteger index))block {
    self.itemArray = itemArray;
    self.selectBlock = block;
    self.rowHeight = rowHeight;
    CGFloat maxWidth = [self calculatorMaxWidth];
    CGFloat height = _itemArray.count *rowHeight;
    self.tableView.frame = CGRectMake(0, 0, maxWidth, height);
    [self showAtPoint:point dirction:QLPop_Direction_Down contentView:self.tableView containerView:nil];
}

#pragma mark - UITableViewDelegate and UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _itemArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * QLPopViewCellIdentify = @"QLPopViewCellIdentify";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:QLPopViewCellIdentify];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:QLPopViewCellIdentify];
        cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
        
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, self.rowHeight - 10, self.rowHeight - 10)];
        imgView.tag = 10001;
        [cell.contentView addSubview:imgView];
        
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imgView.frame) + 10, 0, self.frame.size.width - CGRectGetMaxX(imgView.frame) - 30, self.rowHeight)];
        lab.font = [UIFont systemFontOfSize:14.0f];
        lab.textColor = [UIColor colorWithRed:0.13 green:0.13 blue:0.13 alpha:1.0F];
        lab.tag = 10002;
        lab.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:lab];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.backgroundColor = [UIColor clearColor];
    }
    UIImageView *imgView = [cell.contentView viewWithTag:10001];
    UILabel *lab = [cell.contentView viewWithTag:10002];
    id<QLPopViewItemProtocol> item = _itemArray[indexPath.row];
    
    imgView.image = item.itemImage;
    lab.text = item.itemName;
    if (item.itemImage == nil) {
        if (!CGRectEqualToRect(imgView.frame, CGRectZero)) {
            imgView.frame = CGRectZero;
            lab.frame = CGRectMake(0, 0, self.frame.size.width - 10, self.rowHeight);
        }
    }else{
        if (CGRectEqualToRect(imgView.frame, CGRectZero)) {
            imgView.frame = CGRectMake(10, 5, self.rowHeight - 10, self.rowHeight - 10);
            lab.frame = CGRectMake(CGRectGetMaxX(imgView.frame) + 10, 0, self.frame.size.width - CGRectGetMaxX(imgView.frame) - 30, self.rowHeight);
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.rowHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_selectBlock) {
        _selectBlock(indexPath.row);
    }
    [self dismiss];
}

#pragma mark - getter and setter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.tableFooterView = [UIView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;
        _tableView.layer.cornerRadius = self.layer.cornerRadius;
        _tableView.layer.masksToBounds = YES;
        _tableView.rowHeight = 44.0f;
   
    }
    return _tableView;
}

- (void)dealloc {
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
