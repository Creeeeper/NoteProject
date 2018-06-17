//
//  MLViewController.h
//  NoteProject
//
//  Created by liby on 2018/6/15.
//  Copyright © 2018年 liby. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MLNotesManager.h"

@interface MLViewController : UIViewController
/** 数据源 */
@property (nonatomic, strong) MLNotesManager *manager;
/**
 一维
 */
@property (nonatomic, strong) NSNumber *fFloor;

/**
 二维
 */
@property (nonatomic, strong) NSNumber *sFloor;

/**
 三维
 */
@property (nonatomic, strong) NSNumber *tFloor;
@end
