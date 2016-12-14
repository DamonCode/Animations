//
//  ViewController.m
//  Flight Info
//
//  Created by Damon on 2016/11/12.
//  Copyright © 2016年 Damon. All rights reserved.
//

#import "ViewController.h"
#import "FlightData.h"
#import "SnowView.h"

typedef NS_ENUM(NSUInteger, AnimationDirection) {
    AnimationDirectionPositive = 1,
    AnimationDirectionNegative = -1,
};

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UIImageView *summaryIcon;
@property (weak, nonatomic) IBOutlet UILabel *summaryLabel;
@property (weak, nonatomic) IBOutlet UILabel *flightNr;
@property (weak, nonatomic) IBOutlet UILabel *gateNr;
@property (weak, nonatomic) IBOutlet UILabel *depFrom;
@property (weak, nonatomic) IBOutlet UILabel *arrTo;
@property (weak, nonatomic) IBOutlet UIImageView *planeImage;
@property (weak, nonatomic) IBOutlet UIImageView *statusImage;
@property (weak, nonatomic) IBOutlet UILabel *flightStatus;
@property (strong, nonatomic) FlightData *londonToParis;
@property (strong, nonatomic) FlightData *parisToRome;
@property (strong, nonatomic) SnowView *snowView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.summaryLabel addSubview:self.summaryIcon];
    CGPoint p = self.summaryIcon.center;
    p.y = self.summaryLabel.frame.size.height/2;
    self.summaryIcon.center = p;
    self.snowView = [[SnowView alloc] initWithFrame:CGRectMake(-150, -100, 300, 50)];
    [self.view addSubview:self.snowView];
    UIView *clipView = [[UIView alloc] initWithFrame:CGRectOffset(self.view.frame, 0, 50)];
    clipView.clipsToBounds = YES;
    [self.view addSubview:clipView];
    [clipView addSubview:self.snowView];
    [self changeFlightDataTo:self.londonToParis animated:NO];

}
- (void)changeFlightDataTo:(FlightData *)data
                  animated:(BOOL)animated {
    if (animated) {
        [self planeDepart];
        [self summarySwitchTo:data.summary];
        [self fadeImageView:self.bgImageView toImage:[UIImage imageNamed:data.weatherImageName] showEffects:data.showWeatherEffects];
        CGFloat rawValue = data.isTakingOff?1:-1;
        [self cubeTransition:self.flightNr text:data.flightNr rawValue:rawValue];
        [self cubeTransition:self.gateNr text:data.gateNr rawValue:rawValue];
        CGPoint offsetDeparting = CGPointMake(rawValue*80, 0);
        [self moveLabel:self.depFrom text:data.departingFrom offset:offsetDeparting];
        CGPoint offsetArriving = CGPointMake(0, rawValue*50);
        [self moveLabel:self.arrTo text:data.arrivingTo offset:offsetArriving];
        [self cubeTransition:self.flightStatus text:data.flightStatus rawValue:rawValue];

        
        
    } else {
        self.bgImageView.image = [UIImage imageNamed:data.weatherImageName];
        self.snowView.hidden = !data.showWeatherEffects;
        self.flightNr.text = data.flightNr;
        self.gateNr.text = data.gateNr;
        self.depFrom.text = data.departingFrom;
        self.arrTo.text = data.arrivingTo;
        self.flightStatus.text = data.flightStatus;
        self.summaryLabel.text = data.summary;
    }

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self changeFlightDataTo:data.isTakingOff?self.parisToRome:self.londonToParis animated:YES];
    });
    
}
- (void)planeDepart {
    CGPoint originalCenter = self.planeImage.center;
    [UIView animateKeyframesWithDuration:1.5 delay:0 options:0 animations:^{
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:0.25 animations:^{
           
            CGPoint p = self.planeImage.center;
            p.x += 80;
            p.y -= 10;
            self.planeImage.center = p;
            
        }];
        [UIView addKeyframeWithRelativeStartTime:0.1 relativeDuration:0.4 animations:^{
            self.planeImage.transform = CGAffineTransformMakeRotation(-M_PI_4/2);
        
        }];
        [UIView addKeyframeWithRelativeStartTime:0.25 relativeDuration:0.25 animations:^{
          
            CGPoint p = self.planeImage.center;
            p.x += 100;
            p.y -= 50;
            self.planeImage.center = p;
            self.planeImage.alpha = 0;

        }];
        [UIView addKeyframeWithRelativeStartTime:0.51 relativeDuration:0.01 animations:^{
            self.planeImage.transform = CGAffineTransformIdentity;
            CGPoint p = self.planeImage.center;
            p.x = 0;
            p.y = originalCenter.y;
            self.planeImage.center = p;
        }];
        [UIView addKeyframeWithRelativeStartTime:0.55 relativeDuration:0.45 animations:^{
            self.planeImage.alpha = 1;
            CGPoint p = self.planeImage.center;
            p.x = originalCenter.x;
            p.y = originalCenter.y;
            self.planeImage.center = p;
        }];
    } completion:nil];
}
- (void)summarySwitchTo:(NSString *)summaryText {
    [UIView animateKeyframesWithDuration:1 delay:0 options:0 animations:^{
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:0.45 animations:^{
         
            CGPoint p = self.summaryLabel.center;
            p.y-=100;
            self.summaryLabel.center = p;
            
        }];
        [UIView addKeyframeWithRelativeStartTime:0.45 relativeDuration:0.01 animations:^{
            
        }];
        [UIView addKeyframeWithRelativeStartTime:0.5 relativeDuration:0.45 animations:^{
            
            CGPoint p = self.summaryLabel.center;
            p.y+=100;
            self.summaryLabel.center = p;
        }];
    } completion:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.summaryLabel.text = summaryText;
    });
}
- (void)fadeImageView:(UIImageView *)imageView toImage:(UIImage *)image showEffects:(BOOL)show {
    [UIView transitionWithView:imageView duration:1.0 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        imageView.image = image;
    } completion:nil];
    [UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.snowView.alpha = show?1.0:0.0;
    } completion:nil];
}
- (void)cubeTransition:(UILabel *)label text:(NSString *)text rawValue:(CGFloat)rawValue {
    UILabel *auxLabel = [[UILabel alloc] initWithFrame:label.frame];
    auxLabel.text = text;
    auxLabel.font = label.font;
    auxLabel.textAlignment = label.textAlignment;
    auxLabel.textColor = label.textColor;
    auxLabel.backgroundColor = label.backgroundColor;
    CGFloat auxLabelOffset = rawValue*label.frame.size.height/2.0;
    auxLabel.transform = CGAffineTransformConcat(CGAffineTransformMakeScale(1.0, 0.1), CGAffineTransformMakeTranslation(0, -auxLabelOffset));
    [label.superview addSubview:auxLabel];
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        auxLabel.transform = CGAffineTransformIdentity;
        label.transform = CGAffineTransformConcat(CGAffineTransformMakeScale(1.0, 0.1), CGAffineTransformMakeTranslation(0, -auxLabelOffset));
    } completion:^(BOOL finished) {
        label.text = auxLabel.text;
        label.transform = CGAffineTransformIdentity;
        [auxLabel removeFromSuperview];
    }];
   
}
- (void)moveLabel:(UILabel *)label text:(NSString *)text offset:(CGPoint)offset {
    UILabel *auxLabel = [[UILabel alloc] initWithFrame:label.frame];
    auxLabel.text = text;
    auxLabel.font = label.font;
    auxLabel.textAlignment = label.textAlignment;
    auxLabel.textColor = label.textColor;
    auxLabel.backgroundColor = [UIColor clearColor];
    auxLabel.transform = CGAffineTransformMakeTranslation(offset.x, offset.y);
    auxLabel.alpha = 0;
    [self.view addSubview:auxLabel];
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        label.transform = CGAffineTransformMakeTranslation(offset.x, offset.y);
        label.alpha = 0;
    } completion:nil];
    [UIView animateWithDuration:0.25 delay:0.1 options:UIViewAnimationOptionCurveEaseIn animations:^{
        auxLabel.transform = CGAffineTransformIdentity;
        auxLabel.alpha = 1.0;
    } completion:^(BOOL finished) {
        [auxLabel removeFromSuperview];
        label.text = text;
        label.alpha = 1.0;
        label.transform = CGAffineTransformIdentity;
    }];
}
- (FlightData *)londonToParis {
    if (!_londonToParis) {
        _londonToParis = [[FlightData alloc] init];
        _londonToParis.summary = @"01 Apr 2300 09:42";
        _londonToParis.flightNr = @"ZY 2016";
        _londonToParis.gateNr = @"T1 A33";
        _londonToParis.departingFrom = @"YPW";
        _londonToParis.arrivingTo = @"WWG";
        _londonToParis.weatherImageName = @"bg-snowy";
        _londonToParis.showWeatherEffects = YES;
        _londonToParis.isTakingOff = YES;
        _londonToParis.flightStatus = @"Boarding";
    }
    return _londonToParis;
}
- (FlightData *)parisToRome {
    if (!_parisToRome) {
        _parisToRome = [[FlightData alloc] init];
        _parisToRome.summary = @"01 Apr 2015 09:42";
        _parisToRome.flightNr = @"AE 2260";
        _parisToRome.gateNr = @"056";
        _parisToRome.departingFrom = @"LGW";
        _parisToRome.arrivingTo = @"CDG";
        _parisToRome.weatherImageName = @"bg-sunny";
        _parisToRome.showWeatherEffects = NO;
        _parisToRome.isTakingOff = NO;
        _parisToRome.flightStatus = @"Delayed";
    }
    return _parisToRome;
}

@end
