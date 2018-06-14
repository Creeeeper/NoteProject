//
//  MLNavigationController.m
//  NoteProject
//
//  Created by liby on 2018/6/12.
//  Copyright © 2018年 liby. All rights reserved.
//

#import "MLNavigationController.h"

@interface MLNavigationController ()

@end

@implementation MLNavigationController

+ (void)initialize{
    //当导航栏用在BSNavigationController中,才会生效
    //    UINavigationBar *bar = [UINavigationBar appearanceWhenContainedInInstancesOfClasses:@[[self class]]];
    UINavigationBar *bar = [UINavigationBar appearance];
//    [bar setBackgroundImage:[UIImage imageNamed:@"navigationbarBackgroundWhite"] forBarMetrics:(UIBarMetricsDefault)];
    [bar setTitleTextAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:18]}];
    bar.tintColor = MLColor(70, 195, 107);
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    [item setTitleTextAttributes:@{NSForegroundColorAttributeName : MLColor(70, 195, 107), NSFontAttributeName : [UIFont systemFontOfSize:17]} forState:(UIControlStateNormal)];
    [item setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor lightGrayColor], NSFontAttributeName : [UIFont systemFontOfSize:17]} forState:(UIControlStateDisabled)];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
//可以再这个方法中拦截所有push进来的控制器
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    //先创建返回按钮
    if (self.childViewControllers.count > 0) {//如果push进来的不是第一个控制器
        UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [btn setImage:[UIImage imageNamed:@"Back Chevron"] forState:(UIControlStateNormal)];
        [btn sizeToFit];
        btn.contentEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
        [btn addTarget:self action:@selector(back) forControlEvents:(UIControlEventTouchUpInside)];
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
        //隐藏tabbar
        if ([viewController isKindOfClass:[MLNoteViewController class]]) {
            viewController.hidesBottomBarWhenPushed = YES;
        }
    }
    //再调用父类方法,这样可以自己定义左按钮覆盖返回按钮
    [super pushViewController:viewController animated:animated];
}
- (void)back{
    [self popViewControllerAnimated:YES];
}




@end
