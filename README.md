# QLQRCodeUtils

[![CI Status](https://img.shields.io/travis/burtworld/QLRefreshTableView.svg?style=flat)](https://travis-ci.org/burtworld/QLRefreshTableView)
[![Version](https://img.shields.io/cocoapods/v/QLRefreshTableView.svg?style=flat)](https://cocoapods.org/pods/QLRefreshTableView)
[![License](https://img.shields.io/cocoapods/l/QLRefreshTableView.svg?style=flat)](https://cocoapods.org/pods/QLRefreshTableView)
[![Platform](https://img.shields.io/cocoapods/p/QLRefreshTableView.svg?style=flat)](https://cocoapods.org/pods/QLRefreshTableView)

## Troduce
   QLPopView 
   自定义弹框View，可以自定义显示的方向，显示的内容等
## Usage
1.  弹出一个Label
```
	UILabel *lable = [[UILabel alloc]initWithFrame:CGRectZero];
	lable.text = @"显示文字";
	lable.font = [UIFont systemFontOfSize:14.0f];
	lable.textColor = [UIColor yellowColor];
	[lable sizeToFit];
	QLPopView *popView = [QLPopView new];
	[popView showAtView:sender contentView:lable];
```

2.  弹出一个ImageView
```
	UIImageView *imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"timg.jpeg"]];
	
	QLPopView *popView = [QLPopView new];
	[popView showAtPoint:CGPointMake(sender.center.x, CGRectGetMaxY(sender.frame)) dirction:QLPop_Direction_Down contentView:imgView containerView:self.view];
```

3.  弹出一个TableView
```
	QLPopTableView *popTableView = [QLPopTableView new];
	NSArray *array = @[
	[QLPopItemModel itemWithItemName:@"银行1" itemImage:[UIImage imageNamed:@"bank_0"]],
	[QLPopItemModel itemWithItemName:@"银行2" itemImage:[UIImage imageNamed:@"bank_1"]],
	[QLPopItemModel itemWithItemName:@"银行3" itemImage:[UIImage imageNamed:@"bank_2"]],
	];
	[popTableView showAtView:sender rowHeight:44 items:array selectBlock:^(NSInteger index) {
	NSLog(@"选择了--%zd",index);
	}];
```

## Example

使用情况详见我的 [Demo仓库](https://github.com/burtworld/QLDemoProject).
	里面还包含其他的库

## Installation

QLPopView is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'QLPopView'
```

## Author

	paramita, baqkoo007@aliyun.com

## License

QLPopView is available under the MIT license. See the LICENSE file for more info.
