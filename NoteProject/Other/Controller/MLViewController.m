//
//  MLViewController.m
//  NoteProject
//
//  Created by liby on 2018/6/15.
//  Copyright © 2018年 liby. All rights reserved.
//

#import "MLViewController.h"

@interface MLViewController ()

@end

@implementation MLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.manager = [MLNotesManager sharedManager];
//    NSLog(@"显示%@ - %@ - %@", self.manager.fFloor, self.manager.sFloor, self.manager.tFloor);
}

- (void)dealloc {
    NSLog(@"dealloc - %@", NSStringFromClass([self class]));
//    NSLog(@"消失%@ - %@ - %@", [MLNotesManager sharedManager].fFloor, [MLNotesManager sharedManager].sFloor, [MLNotesManager sharedManager].tFloor);
}
@end
