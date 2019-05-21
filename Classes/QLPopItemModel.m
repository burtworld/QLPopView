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
@synthesize context = _context;
+ (instancetype)instanceWithName:(NSString *)name img:(UIImage *)img context:(id)context {
    QLPopItemModel *model = [QLPopItemModel new];
    model.itemName = name;
    model.itemImage = img;
    model.context = context;
    return model;
}
@end
