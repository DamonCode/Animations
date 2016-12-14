//
//  AnimatedMaskLabel.m
//  SlideToReveal
//
//  Created by Damon on 2016/12/13.
//  Copyright © 2016年 damon. All rights reserved.
//

#import "AnimatedMaskLabel.h"

IB_DESIGNABLE;
@interface AnimatedMaskLabel ()

@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@property (nonatomic, strong) NSDictionary *textAttributes;
@property (nonatomic, copy) IBInspectable NSString *text;

@end

@implementation AnimatedMaskLabel
- (void)didMoveToWindow {
    [super didMoveToWindow];
    [self.layer addSublayer:self.gradientLayer];
    CABasicAnimation *gradientAnimation = [CABasicAnimation animationWithKeyPath:@"locations"];
    gradientAnimation.fromValue = @[@0,@0,@0,@0,@0,@0.25];
    gradientAnimation.toValue = @[@0.65,@0.8,@0.85,@0.9,@0.95,@1.0];
    gradientAnimation.duration = 3.0;
    gradientAnimation.repeatCount = MAXFLOAT;
    [self.gradientLayer addAnimation:gradientAnimation forKey:nil];
    
}
- (void)layoutSubviews {
    self.gradientLayer.frame = CGRectMake(-self.bounds.size.width,
                                          self.bounds.origin.y,
                                          3*self.bounds.size.width,
                                          self.bounds.size.height);

    
}
- (void)draw {
    [self setNeedsDisplay];
    UIGraphicsBeginImageContextWithOptions(self.frame.size, false, 0);
    [self.text drawInRect:self.bounds withAttributes:self.textAttributes];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CALayer *maskLayer = [CALayer layer];
    maskLayer.backgroundColor = [UIColor clearColor].CGColor;
    maskLayer.frame = CGRectOffset(self.bounds, self.bounds.size.width, 0);
    maskLayer.contents = (__bridge id _Nullable)(image.CGImage);
    self.gradientLayer.mask = maskLayer;
}
- (CAGradientLayer *)gradientLayer {
    if (!_gradientLayer) {
        _gradientLayer = [CAGradientLayer layer];
        _gradientLayer.startPoint = CGPointMake(0, 0.5);
        _gradientLayer.endPoint = CGPointMake(1, 0.5);
        NSArray *colors = @[(__bridge id)[UIColor yellowColor].CGColor,
                            (__bridge id)[UIColor greenColor].CGColor,
                            (__bridge id)[UIColor orangeColor].CGColor,
                            (__bridge id)[UIColor cyanColor].CGColor,
                            (__bridge id)[UIColor redColor].CGColor,
                            (__bridge id)[UIColor yellowColor].CGColor];
        _gradientLayer.colors = colors;
        _gradientLayer.locations = @[@0,@0,@0,@0,@0,@0.25];
    }
    return _gradientLayer;
}
- (NSDictionary *)textAttributes {
    if (!_textAttributes) {
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        style.alignment = NSTextAlignmentCenter;
        _textAttributes = @{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue" size:28],
                            NSParagraphStyleAttributeName:style};
    }
    return _textAttributes;
}
- (void)setText:(NSString *)text {
    _text = text.copy;
    [self draw];
}
@end
