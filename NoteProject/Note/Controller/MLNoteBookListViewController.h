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
    MLNoteBookListChoose,
} MLNoteBookListType;

@interface MLNoteBookListViewController : MLViewController

@property (nonatomic, assign) MLNoteBookListType listType;

@property (nonatomic, strong) MLNote *regainNote;

@end
