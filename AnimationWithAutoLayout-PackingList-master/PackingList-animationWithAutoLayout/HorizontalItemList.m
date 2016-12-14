//
//  HorizontalItemList.m
//  PackingList-animationWithAutoLayout
//
//  Created by Damon on 2016/11/25.
//  Copyright © 2016年 damon. All rights reserved.
//

#import "HorizontalItemList.h"

static CGFloat const buttonWidth = 60.0;
static CGFloat const padding = 10.0;

@implementation HorizontalItemList

- (instancetype)initInView:(UIView *)aView
{
    CGRect rect = CGRectMake(aView.bounds.size.width, 120.0, aView.bounds.size.width, 80.0);
    self = [super initWithFrame:rect];
    if (self) {
        self.alpha = 0.0;
        for (int i = 0; i < 10; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"summericons_100px_0%d", i]];
            UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
            imageView.center = CGPointMake(i*buttonWidth+buttonWidth/2, buttonWidth/2);
            imageView.tag = i;
            imageView.userInteractionEnabled = YES;
            [self addSubview:imageView];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapImage:)];
            [imageView addGestureRecognizer:tap];
            
        }
        self.contentSize = CGSizeMake(padding*buttonWidth, buttonWidth+2*padding);
        
    }
    return self;
}
- (void)didTapImage:(UITapGestureRecognizer *)tap {
    if (self.didSelectItem) {
        self.didSelectItem(tap.view.tag);
    }
}
- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    if (!self.superview) {
        return;
    }
    [UIView animateWithDuration:1 delay:0.01 usingSpringWithDamping:0.5 initialSpringVelocity:10 options:0 animations:^{
        self.alpha = 1;
        CGPoint p = self.center;
        p.x -= self.frame.size.width;
        self.center = p;
        
    } completion:nil];
}
@end
