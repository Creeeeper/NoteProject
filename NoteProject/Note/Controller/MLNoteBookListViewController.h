//
//  MLNoteBookListViewController.h
//  NoteProject
//
//  Created by liby on 2018/6/12.
//  Copyright © 2018年 liby. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    MLNoteBookListNormal,
    MLNoteBookListChooseFromDelete,
    MLNoteBookListChooseFromNormal
} MLNoteBookListType;

@interface MLNoteBookListViewController : MLViewController

/**
 列表类型
 */
@property (nonatomic, assign) MLNoteBookListType listType;

/**
 MLNoteBookListChooseFromDelete | MLNoteBookListChooseFromNormal
 持有的笔记
 */
@property (nonatomic, strong) MLNote *note;

/**
 MLNoteBookListChooseFromNormal
 笔记原属笔记本的index
 */
@property (nonatomic, strong) NSIndexPath *selectIndexPath;

@end
