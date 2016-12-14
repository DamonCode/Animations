//
//  ViewController.m
//  PackingList-animationWithAutoLayout
//
//  Created by Damon on 2016/11/23.
//  Copyright © 2016年 damon. All rights reserved.
//

#import "ViewController.h"
#import "HorizontalItemList.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *buttonMenu;
@property (strong, nonatomic) NSMutableArray<NSNumber *> *items;
@property (strong, nonatomic) HorizontalItemList *slider;
@property (assign, nonatomic) BOOL isMenuOpen;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *menuH;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.rowHeight = 54;
    self.items = @[@5, @6, @7].mutableCopy;
}
- (IBAction)onClickAdd:(id)sender {
    self.isMenuOpen = !self.isMenuOpen;
    for (NSLayoutConstraint *con in self.titleLabel.superview.constraints) {
        if (con.firstItem == self.titleLabel && con.firstAttribute == NSLayoutAttributeCenterX) {
            con.constant = self.isMenuOpen?-100:0;
        }
        
        if ([con.identifier isEqual: @"TitleCenterY"]) {
            con.active = NO;
            NSLayoutConstraint *newCon = [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.titleLabel.superview attribute:NSLayoutAttributeCenterY multiplier:self.isMenuOpen?0.67:1.0 constant:5];
            newCon.identifier = @"TitleCenterY";
            newCon.active = true;
        }
    }
    self.menuH.constant = self.isMenuOpen?200:64;
    self.titleLabel.text = self.isMenuOpen?@"Select Item":@"Packing List";
    [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseIn animations:^{
        [self.view layoutIfNeeded];
        CGFloat angle = self.isMenuOpen?M_PI_4:0;
        self.buttonMenu.transform = CGAffineTransformMakeRotation(angle);
    } completion:nil];
    if (self.isMenuOpen) {
        self.slider = [[HorizontalItemList alloc] initInView:self.view];
       __weak typeof(self) weakSelf = self;
        self.slider.didSelectItem = ^(NSInteger index){
            [weakSelf.items addObject:[NSNumber numberWithInteger:index]];
            [weakSelf.tableView reloadData];
            [weakSelf onClickAdd:nil];
        };
        [self.titleLabel.superview addSubview:self.slider];
    }else {
        [self.slider removeFromSuperview];
    }
    
}
- (void)showItemAtIndex:(NSInteger)index {
    NSLog(@"show:%@", [NSString stringWithFormat:@"show:summericons_100px_0%lu", index]);
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"summericons_100px_0%lu", index]]];
    imageView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    imageView.layer.cornerRadius = 5.;
    imageView.layer.masksToBounds = YES;
    imageView.translatesAutoresizingMaskIntoConstraints = false;
    [self.view addSubview:imageView];
    
    NSLayoutConstraint *conX = [imageView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor];
    NSLayoutConstraint *conBottom = [imageView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:imageView.frame.size.height];
    NSLayoutConstraint *conWidth = [imageView.widthAnchor constraintEqualToAnchor:self.view.widthAnchor multiplier:0.33 constant:-50];
    NSLayoutConstraint *conHeight = [imageView.heightAnchor constraintEqualToAnchor:imageView.widthAnchor];
    [NSLayoutConstraint activateConstraints:@[conX, conBottom, conWidth, conHeight]];
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:0.8 delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:0 options:0 animations:^{
        conBottom.constant = -imageView.frame.size.height/2;
        conWidth.constant = 0;
        [self.view layoutIfNeeded];
    } completion:nil];
    [UIView animateWithDuration:0.8 delay:1.0 usingSpringWithDamping:0.4 initialSpringVelocity:0 options:0 animations:^{
        conBottom.constant = imageView.frame.size.height;
        conWidth.constant = -50;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [imageView removeFromSuperview];
    }];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *itemTitles = @[@"Icecream money", @"Great weather", @"Beach ball", @"Swim suit for him", @"Swim suit for her", @"Beach games", @"Ironing board", @"Cocktail mood", @"Sunglasses", @"Flip flops"];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryNone;
    NSNumber *index = self.items[indexPath.row];
    cell.textLabel.text = itemTitles[index.integerValue];
    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"summericons_100px_0%lu", index.integerValue]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"select:%@", [NSString stringWithFormat:@"show:summericons_100px_0%lu", indexPath.row]);
    NSNumber *index = self.items[indexPath.row];
    [self showItemAtIndex:index.integerValue];
}

@end
