//
//  QLPopItemModel.h
//  QLCommonUtils
//
//  Created by Paramita on 2018/6/7.
//  Copyright © 2018年 Paramita. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QLPopViewItemProtocol.h"
//! 可直接使用的模型类
@interface QLPopItemModel : NSObject<QLPopViewItemProtocol>
+ (instancetype)itemWithItemName:(NSString *)itemName itemImage:(UIImage *)itemImage;
@end
