//
//  ViewController.m
//  BahamaAir-Challenges
//
//  Created by Damon on 2016/11/9.
//  Copyright © 2016年 Damon. All rights reserved.
//

#import "ViewController.h"
#define LCDW self.view.bounds.size.width

@interface ViewController ()<CAAnimationDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *heading;
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIButton *login;
@property (weak, nonatomic) IBOutlet UIImageView *cloud1;
@property (weak, nonatomic) IBOutlet UIImageView *cloud2;
@property (weak, nonatomic) IBOutlet UIImageView *cloud3;
@property (weak, nonatomic) IBOutlet UIImageView *cloud4;
@property (strong, nonatomic) UIActivityIndicatorView *spinner;
@property (strong, nonatomic) UIImageView *status;
@property (strong, nonatomic) UILabel *statusLabel;
@property (assign, nonatomic) CGPoint statusP;
@property (strong, nonatomic) UILabel *infoLabel;
@property (strong, nonatomic) UILabel *label;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.spinner.frame = CGRectMake(-20, 6, 20, 20);
    [self.spinner startAnimating];
    self.spinner.alpha = 0;
    [self.login addSubview:self.spinner];
    
    self.status = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"banner"]];
    self.status.center = self.login.center;
    self.status.bounds = CGRectMake(0, 0, 283, 49);
    self.status.hidden = YES;
    [self.view addSubview:self.status];
    
    self.label = [[UILabel alloc] initWithFrame:self.status.bounds];
    self.label.font = [UIFont fontWithName:@"HelveticaNeue" size:18];
    self.label.textColor = [UIColor colorWithRed:0.89 green:0.38 blue:0 alpha:1];
    self.label.textAlignment = NSTextAlignmentCenter;
    [self.status addSubview:self.label];
    
    self.statusP = self.status.center;
    
    self.infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMidY(self.login.frame)+60, self.view.bounds.size.width, 30)];
    self.infoLabel.backgroundColor = [UIColor clearColor];
    self.infoLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
    self.infoLabel.textAlignment = NSTextAlignmentCenter;
    self.infoLabel.textColor = [UIColor whiteColor];
    self.infoLabel.text = @"Tap on a field and enter username and password";
    [self.view insertSubview:self.infoLabel belowSubview:self.login];
    

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    CAAnimationGroup *formGroup = [CAAnimationGroup animation];
    formGroup.duration = 0.5;
    formGroup.fillMode = kCAFillModeBackwards;
    
    
    CABasicAnimation *flyRight = [CABasicAnimation animationWithKeyPath:@"position.x"];
    flyRight.fromValue = @(-self.view.bounds.size.width/2);
    flyRight.toValue = @(self.view.bounds.size.width/2);
   
    CABasicAnimation *fadeFiledIn = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeFiledIn.fromValue = @0.25;
    fadeFiledIn.toValue = @1.0;
    
    formGroup.animations = @[flyRight, fadeFiledIn];
    [self.heading.layer addAnimation:formGroup forKey:nil];
    
    formGroup.delegate = self;
    [formGroup setValue:@"form" forKey:@"name"];
    [formGroup setValue:self.username.layer forKey:@"layer"];
    
    formGroup.beginTime = CACurrentMediaTime()+0.3;
    [self.username.layer addAnimation:formGroup forKey:nil];
    
    [formGroup setValue:self.password.layer forKey:@"layer"];
    formGroup.beginTime = CACurrentMediaTime()+0.4;
    [self.password.layer addAnimation:formGroup forKey:nil];
    
    CABasicAnimation *fadeIn = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeIn.fromValue = @0;
    fadeIn.toValue = @1.0;
    fadeIn.duration = 0.5;
    fadeIn.fillMode = kCAFillModeBackwards;
    fadeIn.beginTime = CACurrentMediaTime()+0.5;
    [self.cloud1.layer addAnimation:fadeIn forKey:nil];
    
    fadeIn.beginTime = CACurrentMediaTime()+0.7;
    [self.cloud2.layer addAnimation:fadeIn forKey:nil];
    
    fadeIn.beginTime = CACurrentMediaTime()+0.9;
    [self.cloud3.layer addAnimation:fadeIn forKey:nil];
    
    fadeIn.beginTime = CACurrentMediaTime()+1.1;
    [self.cloud4.layer addAnimation:fadeIn forKey:nil];
    
    CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
    groupAnimation.beginTime = CACurrentMediaTime()+0.5;
    groupAnimation.duration = 0.5;
    groupAnimation.fillMode = kCAFillModeBackwards;
    groupAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    CABasicAnimation *scaleDown = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleDown.fromValue = @3.5;
    scaleDown.toValue = @1.0;
    
    CABasicAnimation *rotate = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotate.fromValue = @(M_PI_4);
    rotate.toValue = @0;
    
    CABasicAnimation *fade = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeIn.fromValue = @0;
    fade.toValue = @1.0;
    
    groupAnimation.animations = @[scaleDown, rotate, fade];
    [self.login.layer addAnimation:groupAnimation forKey:nil];
    
    [self animateCloud:self.cloud1.layer];
    [self animateCloud:self.cloud2.layer];
    [self animateCloud:self.cloud3.layer];
    [self animateCloud:self.cloud4.layer];
    
    CABasicAnimation *flyLeft = [CABasicAnimation animationWithKeyPath:@"position.x"];
    flyLeft.fromValue = @(self.infoLabel.layer.position.x+self.view.frame.size.width);
    flyLeft.toValue = @(self.infoLabel.layer.position.x);
    flyLeft.duration = 5;
    [self.infoLabel.layer addAnimation:flyLeft forKey:@"infoappear"];
    
    CABasicAnimation *fadeLabelIn = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeLabelIn.fromValue = @0.2;
    fadeLabelIn.toValue = @1.0;
    fadeLabelIn.duration = 4.5;
    [self.infoLabel.layer addAnimation:fadeLabelIn forKey:@"fadein"];
    
    self.username.delegate = self;
    self.password.delegate = self;
}

- (void)showMessageAtIndex:(NSInteger)index {
    NSArray *messages = @[@"Connecting", @"Authorizing", @"Sending credentials", @"Failed"];
   
    [UIView transitionWithView:self.status duration:0.33
                       options:UIViewAnimationOptionCurveEaseOut |
                                UIViewAnimationOptionTransitionFlipFromBottom
                    animations:^{
                        self.status.hidden = NO;
                        [self.status addSubview:self.statusLabel];
                        self.statusLabel.text = messages[index];
                        [self.statusLabel sizeToFit];
    } completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (index < messages.count -1) {
                [self removeMessage:index];
            } else {
                [self resetForm];
            }
        });
    }];
    
    
    
}
- (void)removeMessage:(NSInteger)index {
    [UIView animateWithDuration:0.33 delay:0 options:0 animations:^{
        [self updateOrginXForView:self.status withStep:-LCDW];
    } completion:^(BOOL finished) {
        self.status.hidden = YES;
        self.status.center = self.statusP;
        [self showMessageAtIndex:index+1];
    }];
}
- (void)resetForm {
    [UIView transitionWithView:self.status duration:0.2 options:0 animations:^{
        self.status.hidden = YES;
        self.status.center = self.statusP;
    } completion:nil];
    [UIView transitionWithView:self.status duration:0.2 options:UIViewAnimationOptionTransitionFlipFromTop animations:^{
        self.spinner.center = CGPointMake(-20, 16);
        self.spinner.alpha = 0;
        self.login.backgroundColor = [UIColor colorWithRed:0.63 green:0.84 blue:0.35 alpha:1];
        [self zoomBoundsWidthForView:self.login withStep:-80];
        [self updateOrginYForView:self.login withStep:-60];
    } completion:^(BOOL finished) {
        UIColor *tintColor = [UIColor colorWithRed:0.63 green:0.84 blue:0.35 alpha:1.0];
        [self tintBackgroundColor:self.login.layer toColor:tintColor];
        [self roundCornersToRadius:10 withLayer:self.login.layer];
    }];
    CAKeyframeAnimation *wobble = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];
    wobble.duration = 0.25;
    wobble.repeatCount = 4;
    wobble.values = @[@0, @(-M_PI_4/4), @0, @(M_PI_4/4), @.0];
    
    wobble.keyTimes = @[@0, @0.25, @0.5, @0.75, @1.0];
    [self.heading.layer addAnimation:wobble forKey:nil];
    
    
    
}
- (void)tintBackgroundColor:(CALayer *)layer toColor:(UIColor *)color {
    CASpringAnimation *tint = [CASpringAnimation animationWithKeyPath:@"backgroundColor"];
    tint.damping = 5.0;
    tint.fromValue = (__bridge id _Nullable)(layer.backgroundColor);
    tint.toValue = (__bridge id _Nullable)(color.CGColor);
    tint.duration = tint.settlingDuration;
    [layer addAnimation:tint forKey:nil];
    layer.backgroundColor = color.CGColor;

}
- (void)animateCloud:(CALayer *)layer {
    double cloudSpeed = LCDW/60;
    NSTimeInterval duration = (self.view.layer.frame.size.width - layer.frame.origin.x)/cloudSpeed;
    CABasicAnimation *cloudMove = [CABasicAnimation animationWithKeyPath:@"position.x"];
    cloudMove.duration = duration;
    cloudMove.toValue = @(self.view.bounds.size.width+layer.bounds.size.width);
    cloudMove.delegate = self;
    [cloudMove setValue:@"cloud" forKey:@"name"];
    [cloudMove setValue:layer forKey:@"layer"];
    [layer addAnimation:cloudMove forKey:nil];
    
}
- (IBAction)login:(id)sender {
    /* eg.2 */
    [UIView animateWithDuration:1.5 delay:0 usingSpringWithDamping:0.2 initialSpringVelocity:0.0 options:0 animations:^{
        [self zoomBoundsWidthForView:self.login withStep:80];
        
    } completion:nil];
    [UIView animateWithDuration:0.33 delay:0.0 usingSpringWithDamping:0.7 initialSpringVelocity:0.0 options:0 animations:^{
        [self updateOrginYForView:self.login withStep:60];
        self.spinner.center = CGPointMake(40, self.login.frame.size.height/2);
        self.spinner.alpha = 1.0;
    } completion:^(BOOL finished){
        [self showMessageAtIndex:0];
    }];
    UIColor *tintColor = [UIColor colorWithRed:0.85 green:0.83 blue:0.45 alpha:1];
    [self tintBackgroundColorToColor:tintColor withLayer:self.login.layer];
    [self roundCornersToRadius:10 withLayer:self.login.layer];
    
    CALayer *balloon = [CALayer layer];
    balloon.contents = [UIImage imageNamed:@"balloon"];
    balloon.frame = CGRectMake(-50, 0, 50, 65);
    [self.view.layer insertSublayer:balloon above:self.username.layer];
    
    CAKeyframeAnimation *flight = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    flight.duration = 12;
    NSValue *value0 = [NSValue valueWithCGPoint:CGPointMake(-50, 0)];
    NSValue *value1 = [NSValue valueWithCGPoint:CGPointMake(self.view.frame.size.width+50, 160)];
    NSValue *value2 = [NSValue valueWithCGPoint:CGPointMake(-50, self.login.center.y)];
    
    flight.values = @[value0, value1, value2];
    flight.keyTimes = @[@0.0, @0.5, @1.0];
    [balloon addAnimation:flight forKey:nil];
    balloon.position = CGPointMake(-50, self.login.center.y);
    
}
- (void)roundCornersToRadius:(CGFloat )toRadius withLayer:(CALayer *)layer {
    CASpringAnimation *round = [CASpringAnimation animationWithKeyPath:@"cornerRadius"];
    round.damping = 5.0;
    round.fromValue = @(layer.cornerRadius);
    round.toValue = @(toRadius);
    round.duration = round.settlingDuration;
    [layer addAnimation:round forKey:nil];
    layer.cornerRadius = toRadius;
}
- (void)tintBackgroundColorToColor:(UIColor *)color withLayer:(CALayer *)layer {
    CABasicAnimation *tint = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
    tint.fromValue = (__bridge id _Nullable)(layer.backgroundColor);
    tint.toValue = (__bridge id _Nullable)(color.CGColor);
    tint.duration = 1.0;
    [layer addAnimation:tint forKey:nil];
    layer.backgroundColor = color.CGColor;
    
}
- (void)zoomBoundsWidthForView:(UIView *)aView withStep:(CGFloat)step {
    CGRect rect = aView.frame;
    rect.size.width += step;
    rect.origin.x -= step/2;
    aView.frame = rect;
}
- (void)updateOrginXForView:(UIView *)aView withStep:(CGFloat)step{
    CGRect rect = aView.frame;
    rect.origin.x -= step;
    aView.frame = rect;
}
- (void)updateOrginYForView:(UIView *)aView withStep:(CGFloat)step{
    CGRect rect = aView.frame;
    rect.origin.y += step;
    aView.frame = rect;
}
- (UILabel *)statusLabel {
    if (!_statusLabel) {
        _statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 20, 100, 10)];
        _statusLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:18];
        _statusLabel.textColor = [UIColor colorWithRed:0.89 green:0.38 blue:0 alpha:1];
        _statusLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _statusLabel;
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    NSLog(@"animation did stop");
    NSString *name = [anim valueForKey:@"name"];
    if ([name isEqualToString:@"form"]) {
        CALayer *layer = [anim valueForKey:@"layer"];
        [anim setValue:nil forKey:@"layer"];
        CABasicAnimation *pulse = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        pulse.fromValue = @1.25;
        pulse.toValue = @1.0;
        pulse.duration = 0.25;
        [layer addAnimation:pulse forKey:nil];
        
    }else if ([name isEqualToString:@"cloud"]) {
        CALayer *layer = [anim valueForKey:@"layer"];
        [anim setValue:nil forKey:@"layer"];
        CGPoint p = layer.position;
        p.x = -layer.bounds.size.width/2;
        layer.position = p;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self animateCloud:layer];
        });
    }
}
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self.infoLabel.layer removeAnimationForKey:@"infoappear"];
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.text.length < 5) {
        CASpringAnimation *jump = [CASpringAnimation animationWithKeyPath:@"position.y"];
        jump.initialVelocity = 100;
        jump.mass = 10;
        jump.stiffness = 1500;
        jump.damping = 50;
        
        jump.fromValue = @(textField.layer.position.y+1);
        jump.toValue = @(textField.layer.position.y);
        jump.duration = jump.settlingDuration;
        [textField.layer addAnimation:jump forKey:nil];
        
        textField.layer.borderColor = [UIColor clearColor].CGColor;
        textField.layer.borderWidth = 3.0;
        
        CASpringAnimation *flash = [CASpringAnimation animationWithKeyPath:@"borderColor"];
        flash.damping = 7.0;
        flash.stiffness = 200.0;
        flash.fromValue = [UIColor colorWithRed:0.96 green:0.27 blue:0 alpha:1];
        flash.toValue = (__bridge id _Nullable)([UIColor clearColor].CGColor);
        flash.duration = flash.settlingDuration;
        [textField.layer addAnimation:flash forKey:nil];
    }
}
@end
