//
//  QLPopViewItemProtocol.h
//  QLCommonUtils
//
//  Created by Paramita on 2018/2/11.
//  Copyright © 2018年 Paramita. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIkit.h>

@protocol QLPopViewItemProtocol <NSObject>
@property (nonatomic, retain) UIImage *itemImage;
@property (nonatomic, retain) NSString *itemName;
@end
