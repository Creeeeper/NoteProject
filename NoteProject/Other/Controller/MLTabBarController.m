//
//  MLTabBarController.m
//  NoteProject
//
//  Created by liby on 2018/6/12.
//  Copyright © 2018年 liby. All rights reserved.
//

#import "MLTabBarController.h"
#import "MLNavigationController.h"
#import "MLTabBar.h"
#import "MLNoteBookListViewController.h"


@interface MLTabBarController ()

@end

@implementation MLTabBarController
+ (void)initialize{
    UITabBarItem *item = [UITabBarItem appearance];
    [item setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12], NSForegroundColorAttributeName:[UIColor grayColor]} forState:(UIControlStateNormal)];
    [item setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12], NSForegroundColorAttributeName:[UIColor whiteColor]} forState:(UIControlStateSelected)];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //添加子控制器
    [self setupChildVC:[[MLNoteBookListViewController alloc] init] title:@"笔记" image:@"iosAllNotes" selectedImage:@"iosAllNotesS"];
    [self setupChildVC:[[UIViewController alloc] init] title:@"搜索" image:@"iosSearch" selectedImage:@"iosSearchS"];
    [self setupChildVC:[[UIViewController alloc] init] title:@"快捷" image:@"iosStar" selectedImage:@"iosStarS"];
    [self setupChildVC:[[UIViewController alloc] init] title:@"账户" image:@"iosUser" selectedImage:@"iosUserS"];
    //更换tabbar
    [self setValue:[[MLTabBar alloc] init] forKeyPath:@"tabBar"];
}
- (void)setupChildVC:(UIViewController *)vc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage{
    vc.navigationItem.title = title;
    vc.tabBarItem.title = title;
    vc.tabBarItem.image = [UIImage imageNamed:image];
    vc.tabBarItem.selectedImage = [UIImage imageNamed:selectedImage];
    [self addChildViewController:vc];
    MLNavigationController *nav = [[MLNavigationController alloc] initWithRootViewController:vc];
    [self addChildViewController:nav];
}

@end
