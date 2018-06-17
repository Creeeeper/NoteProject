//
//  MLNoteViewController.h
//  NoteProject
//
//  Created by liby on 2018/6/14.
//  Copyright © 2018年 liby. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLViewController.h"

@interface MLNoteViewController : MLViewController
/** 笔记 */
@property (nonatomic, strong) MLNote *note;
/** 所属笔记本类型 */
@property (nonatomic, assign) MLBookType bookType;
@end
