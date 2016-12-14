//
//  HorizontalItemList.h
//  PackingList-animationWithAutoLayout
//
//  Created by Damon on 2016/11/25.
//  Copyright © 2016年 damon. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DidSelectItem)(NSInteger index);

@interface HorizontalItemList : UIScrollView


- (instancetype)initInView:(UIView *)aView;

@property (nonatomic, copy) DidSelectItem didSelectItem;
;


@end
