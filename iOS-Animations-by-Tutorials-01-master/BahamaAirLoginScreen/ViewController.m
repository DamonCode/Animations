//
//  ViewController.m
//  BahamaAirLoginScreen
//
//  Created by Damon on 2016/11/9.
//  Copyright © 2016年 Damon. All rights reserved.
//

#import "ViewController.h"

#define LCDW self.view.bounds.size.width
static NSTimeInterval const duration = 0.5;
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UILabel *heading;
@property (weak, nonatomic) IBOutlet UIImageView *cloud1;
@property (weak, nonatomic) IBOutlet UIImageView *cloud2;
@property (weak, nonatomic) IBOutlet UIImageView *cloud3;
@property (weak, nonatomic) IBOutlet UIImageView *cloud4;
@property (weak, nonatomic) IBOutlet UIButton *login;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.login.layer.cornerRadius = 8;
    self.login.layer.masksToBounds = YES;
    self.cloud1.alpha = 0;
    self.cloud2.alpha = 0;
    self.cloud3.alpha = 0;
    self.cloud4.alpha = 0;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateOrginXForView:self.username withStep:LCDW];
    [self updateOrginXForView:self.password withStep:LCDW];
    [self updateOrginXForView:self.heading withStep:LCDW];
    
    
    
    
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
   
    [UIView animateWithDuration:duration animations:^{
        [self updateOrginXForView:self.heading withStep:-LCDW];
    }];
    
    [UIView animateWithDuration:duration delay:0.3 options:0 animations:^{
        [self updateOrginXForView:self.username withStep:-LCDW];
    } completion:nil];
    
    [UIView animateWithDuration:duration delay:0.4 options:0 animations:^{
        [self updateOrginXForView:self.password withStep:-LCDW];
    } completion:nil];
    
    [UIView animateWithDuration:duration delay:0.5 options:0 animations:^{
        self.cloud1.alpha = 1;
    } completion:nil];
    [UIView animateWithDuration:duration delay:0.6 options:0 animations:^{
        self.cloud2.alpha = 1;
    } completion:nil];
    [UIView animateWithDuration:duration delay:0.7 options:0 animations:^{
        self.cloud3.alpha = 1;
    } completion:nil];
    [UIView animateWithDuration:duration delay:0.9 options:0 animations:^{
        self.cloud4.alpha = 1;
    } completion:nil];
}
- (void)updateOrginXForView:(UIView *)aView withStep:(CGFloat)step{
    CGRect rect = aView.frame;
    rect.origin.x -= step;
    aView.frame = rect;
}
@end
