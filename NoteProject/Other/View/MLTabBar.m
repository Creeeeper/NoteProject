//
//  MLTabBar.m
//  NoteProject
//
//  Created by liby on 2018/6/12.
//  Copyright © 2018年 liby. All rights reserved.
//

#import "MLTabBar.h"


@interface MLTabBar ()
@property (strong, nonatomic) UIButton *publishButton;
@end

@implementation MLTabBar

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        //背景图片
//        [self setBackgroundImage:[UIImage imageNamed:@"tabbar-light"]];
        self.tintColor = [UIColor whiteColor];
        self.barTintColor = MLColor(51, 58, 73);
        //添加发布按钮
        UIButton *publishButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [publishButton setBackgroundImage:[UIImage imageNamed:@"iosPlus"] forState:(UIControlStateNormal)];
        [publishButton setBackgroundImage:[UIImage imageNamed:@"iosPlus"] forState:(UIControlStateHighlighted)];
        
        publishButton.bounds = CGRectMake(0, 0, publishButton.currentBackgroundImage.size.width, publishButton.currentBackgroundImage.size.height);
        publishButton.center = CGPointMake(self.frame.size.width/2.0, self.frame.size.height/2.0);
        [publishButton addTarget:self action:@selector(publishClick) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:publishButton];
        self.publishButton = publishButton;
    }
    return self;
}
//点击标签栏中间加号
- (void)publishClick{
    //    BSPostWordViewController *postWord = [[BSPostWordViewController alloc] init];
    //    BSNavigationController *nav = [[BSNavigationController alloc] initWithRootViewController:postWord];
    //    UIViewController *root = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    //    [root presentViewController:nav animated:YES completion:nil];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat width = self.W;
    CGFloat height = self.H;
    //设置发布按钮frame
    self.publishButton.W = self.publishButton.currentBackgroundImage.size.width;
    self.publishButton.H = self.publishButton.currentBackgroundImage.size.height;
    
    self.publishButton.center = CGPointMake(width/2.0, height/2.0);
    //设置其他按钮frame
    CGFloat btnY = 0;
    CGFloat btnW = width/5;
    CGFloat btnH = height;
    NSInteger index = 0;
    for (UIView *btn in self.subviews) {
        if ([btn isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            CGFloat btnX = btnW * ((index > 1) ? (index +1) : index);
            btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
            index++;
        }
    }
}
@end
