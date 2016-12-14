//
//  ViewController.m
//  SlideToReveal
//
//  Created by Damon on 2016/12/13.
//  Copyright © 2016年 damon. All rights reserved.
//

#import "ViewController.h"
#import "AnimatedMaskLabel.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet AnimatedMaskLabel *slideView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSlide)];
    swipe.direction = UISwipeGestureRecognizerDirectionRight;
    [self.slideView addGestureRecognizer:swipe];
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(setTime) userInfo:nil repeats:YES];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [UIView animateWithDuration:0.33 delay:0 options:0 animations:^{
        self.time.alpha = 1;
    } completion:^(BOOL finished) {
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(setTime) userInfo:nil repeats:YES];
    }];
}
- (void)didSlide {
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"meme"]];
    image.center = CGPointMake(self.view.center.x+self.view.bounds.size.width, self.view.center.y);
    [self.view addSubview:image];
    [UIView animateWithDuration:0.33 delay:0 options:0 animations:^{
        CGPoint timeCenter = self.time.center;
        CGPoint slideCenter = self.slideView.center;
        CGPoint imageCenter = image.center;
        timeCenter.y-=200;
        slideCenter.y+=200;        imageCenter.x-=self.view.bounds.size.width;
        self.time.center = timeCenter;
        self.slideView.center = slideCenter;
        image.center = imageCenter;
    } completion:nil];
    [UIView animateWithDuration:0.33 delay:1.5 options:0 animations:^{
        CGPoint timeCenter = self.time.center;
        CGPoint slideCenter = self.slideView.center;
        CGPoint imageCenter = image.center;
        timeCenter.y+=200;
        slideCenter.y-=200;
        imageCenter.x+=self.view.bounds.size.width;
        self.time.center = timeCenter;
        self.slideView.center = slideCenter;
        image.center = imageCenter;
        
    } completion:^(BOOL finished) {
        [image removeFromSuperview];
    }];
    
}

- (void)setTime {
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitHour |
                            NSCalendarUnitMinute;
    NSDateComponents *dateComponents = [calendar components:unitFlags fromDate:now];
    
    NSString *minute = nil;
    if (dateComponents.minute<10) {
        minute = [NSString stringWithFormat:@"0%ld", dateComponents.minute];
    } else {
        minute = [NSString stringWithFormat:@"%ld", dateComponents.minute];
    }
   self.time.text =  [NSString stringWithFormat:@"%ld:%@", (long)dateComponents.hour, minute];
    [self.time sizeToFit];
    
}

@end
