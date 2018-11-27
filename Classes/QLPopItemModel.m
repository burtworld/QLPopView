//
//  QLPopItemModel.m
//  QLCommonUtils
//
//  Created by Paramita on 2018/6/7.
//  Copyright © 2018年 Paramita. All rights reserved.
//

#import "QLPopItemModel.h"

@implementation QLPopItemModel
@synthesize itemName = _itemName;
@synthesize itemImage = _itemImage;

+ (instancetype)itemWithItemName:(NSString *)itemName itemImage:(UIImage *)itemImage {
    QLPopItemModel *model = [QLPopItemModel new];
    model.itemName = itemName;
    model.itemImage = itemImage;
    return model;
}
@end
