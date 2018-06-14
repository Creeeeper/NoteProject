//
//  MLNotesManager.h
//  NoteProject
//
//  Created by liby on 2018/6/14.
//  Copyright © 2018年 liby. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"

@interface MLNotesManager : NSObject
SingletonH(MLNotesManager)

/* ---------------------------------------------------- */

/**
 笔记本字典
 @key       UUID
 @value     笔记模型
 */
@property (nonatomic, strong) NSMutableDictionary *noteListDict;

/** 更新笔记 */
- (void)updateNote:(MLNote *)model complete:(void(^)(BOOL succeed))complete;
/** 更新笔记本 */
- (void)updateNoteBook:(MLNoteBook *)model complete:(void(^)(BOOL succeed))complete;
/** 更新笔记本组 */
- (void)updateNoteBookGroup:(MLNoteBookGroup *)model complete:(void(^)(BOOL succeed))complete;
/** 查询 */
- (void)getNoteModelWithUUID:(NSString *)UUID complete:(void(^)(id model))complete;
@end
